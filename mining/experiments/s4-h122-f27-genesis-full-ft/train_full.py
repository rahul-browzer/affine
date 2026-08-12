#!/usr/bin/env python3
"""H122/F27 Genesis: dense full-FT (no LoRA) thought-only SFT on high-Λ2 z_A.

Freezes model.visual.*; updates all other params. Same data/mask path as
train_lora.py — structural difference is dense vs low-rank adapters.
"""
from __future__ import annotations

import argparse
import json
import os
import sys
import time
from pathlib import Path

import torch
from torch.utils.data import Dataset
from transformers import (
    AutoModelForCausalLM,
    AutoTokenizer,
    Trainer,
    TrainerCallback,
    TrainingArguments,
)

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "s4-h1v2-sft"))
from thought_mask import thought_cut_char  # noqa: E402

THINK_OPEN = "<think>"


class PrintLossCallback(TrainerCallback):
    def on_log(self, args, state, control, logs=None, **kwargs):  # noqa: ANN001
        if not logs or not state.is_world_process_zero:
            return
        payload = {}
        for k in ("loss", "grad_norm", "learning_rate", "epoch"):
            if k not in logs:
                continue
            v = logs[k]
            try:
                if hasattr(v, "item"):
                    v = v.item()
                payload[k] = float(v)
            except (TypeError, ValueError):
                payload[k] = str(v)
        if "loss" not in payload:
            return
        print(
            f"[train-log] step={state.global_step} {json.dumps(payload)}",
            flush=True,
        )


def _msg_chars(row: dict) -> int:
    return sum(len(m.get("content") or "") for m in row.get("messages") or [])


class RefSFTDataset(Dataset):
    def __init__(self, path: Path, tokenizer, max_len: int, loss_on: str = "thought"):
        raw: list[dict] = []
        with path.open() as f:
            for line in f:
                if line.strip():
                    raw.append(json.loads(line))
        self.tok = tokenizer
        self.max_len = max_len
        if loss_on not in ("thought", "full"):
            raise ValueError(f"loss_on must be thought|full, got {loss_on!r}")
        self.loss_on = loss_on
        if loss_on == "thought":
            budget = int(max_len * 2.5)
            kept = [r for r in raw if _msg_chars(r) <= budget]
            kept.sort(key=_msg_chars)
            print(
                f"[train] fit-filter max_len={max_len} budget_chars={budget} "
                f"kept={len(kept)}/{len(raw)}",
                flush=True,
            )
            self.rows = kept
        else:
            self.rows = raw
        self.n_no_fence = 0
        self.n_thought_ok = 0
        if self.loss_on == "thought":
            for r in self.rows:
                if thought_cut_char(r["completion"]) is None:
                    self.n_no_fence += 1
                else:
                    self.n_thought_ok += 1

    def __len__(self) -> int:
        return len(self.rows)

    def __getitem__(self, idx: int) -> dict:
        r = self.rows[idx]
        prompt = self.tok.apply_chat_template(
            r["messages"], tokenize=False, add_generation_prompt=True
        )
        if not prompt.rstrip().endswith(THINK_OPEN):
            prompt = prompt + THINK_OPEN
        completion = r["completion"]
        full = prompt + completion
        enc = self.tok(
            full,
            add_special_tokens=False,
            truncation=True,
            max_length=self.max_len,
            return_offsets_mapping=True,
        )
        full_ids = enc["input_ids"]
        offsets = enc["offset_mapping"]
        labels = list(full_ids)
        prompt_end = len(prompt)
        for i, (a, b) in enumerate(offsets):
            if b <= prompt_end:
                labels[i] = -100
        if self.loss_on == "thought":
            cut = thought_cut_char(completion)
            if cut is None:
                labels = [-100] * len(full_ids)
            else:
                action_start = prompt_end + cut
                for i, (a, b) in enumerate(offsets):
                    if labels[i] == -100:
                        continue
                    if a >= action_start:
                        labels[i] = -100
        if sum(1 for x in labels if x != -100) < 2:
            labels = [-100] * len(full_ids)
        attn = [1] * len(full_ids)
        return {
            "input_ids": torch.tensor(full_ids, dtype=torch.long),
            "attention_mask": torch.tensor(attn, dtype=torch.long),
            "labels": torch.tensor(labels, dtype=torch.long),
        }


def collate(features: list[dict]) -> dict:
    max_len = max(f["input_ids"].numel() for f in features)
    pad_id = 0

    def pad(t: torch.Tensor, value: int) -> torch.Tensor:
        if t.numel() == max_len:
            return t
        out = torch.full((max_len,), value, dtype=t.dtype)
        out[: t.numel()] = t
        return out

    return {
        "input_ids": torch.stack([pad(f["input_ids"], pad_id) for f in features]),
        "attention_mask": torch.stack([pad(f["attention_mask"], 0) for f in features]),
        "labels": torch.stack([pad(f["labels"], -100) for f in features]),
    }


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", required=True)
    ap.add_argument("--data", type=Path, required=True)
    ap.add_argument("--out-dir", type=Path, required=True)
    ap.add_argument("--max-len", type=int, default=8192)
    ap.add_argument("--epochs", type=float, default=1.0)
    ap.add_argument("--lr", type=float, default=1e-6)
    ap.add_argument("--batch", type=int, default=1)
    ap.add_argument("--grad-accum", type=int, default=8)
    ap.add_argument("--warmup-ratio", type=float, default=0.03)
    ap.add_argument("--save-steps", type=int, default=50)
    ap.add_argument("--logging-steps", type=int, default=5)
    ap.add_argument("--loss-on", choices=("thought", "full"), default="thought")
    ap.add_argument(
        "--max-shard-size",
        default="5GB",
        help="save_pretrained max_shard_size (avoid gocryptfs hang)",
    )
    args = ap.parse_args()

    t0 = time.time()
    args.out_dir.mkdir(parents=True, exist_ok=True)
    meta = {
        "experiment": "s4-h122-f27-genesis-full-ft",
        "family": "F27",
        "recipe": "full_ft_no_lora",
        "base": args.base,
        "data": str(args.data),
        "max_len": args.max_len,
        "epochs": args.epochs,
        "lr": args.lr,
        "batch": args.batch,
        "grad_accum": args.grad_accum,
        "loss_on": args.loss_on,
        "cuda_visible": os.environ.get("CUDA_VISIBLE_DEVICES"),
        "started_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    }
    (args.out_dir / "train_config.json").write_text(json.dumps(meta, indent=2))
    print(json.dumps(meta, indent=2), flush=True)

    tok = AutoTokenizer.from_pretrained(args.base, trust_remote_code=False)
    if tok.pad_token is None:
        tok.pad_token = tok.eos_token
    if not getattr(tok, "is_fast", False):
        raise SystemExit("need a fast tokenizer for offset_mapping thought mask")

    print(f"[train] loading base {args.base} (full FT, no LoRA)", flush=True)
    model = AutoModelForCausalLM.from_pretrained(
        args.base,
        torch_dtype=torch.bfloat16,
        device_map="auto",
        trust_remote_code=False,
        attn_implementation="sdpa",
    )
    model.config.use_cache = False
    if hasattr(model, "gradient_checkpointing_enable"):
        model.gradient_checkpointing_enable()

    n_freeze = 0
    n_train = 0
    for name, p in model.named_parameters():
        if "visual" in name:
            p.requires_grad = False
            n_freeze += p.numel()
        else:
            p.requires_grad = True
            n_train += p.numel()
    print(
        f"[train] trainable={n_train:,} frozen_visual={n_freeze:,} "
        f"frac_train={n_train / max(1, n_train + n_freeze):.4f}",
        flush=True,
    )
    if n_train < 1_000_000:
        raise SystemExit("too few trainable params — full FT misconfigured")

    ds = RefSFTDataset(args.data, tok, args.max_len, loss_on=args.loss_on)
    print(
        f"[train] examples={len(ds)} loss_on={args.loss_on} "
        f"thought_ok={ds.n_thought_ok} no_fence={ds.n_no_fence}",
        flush=True,
    )
    if len(ds) < 20:
        raise SystemExit("too few examples")
    if args.loss_on == "thought" and ds.n_thought_ok < 20:
        raise SystemExit("too few thought-cuttable examples")

    sample = ds[0]
    n_sup = int((sample["labels"] != -100).sum().item())
    n_tok = int(sample["input_ids"].numel())
    print(f"[train] sample0 supervised_tokens={n_sup}/{n_tok}", flush=True)
    if args.loss_on == "thought" and n_sup < 4:
        raise SystemExit("thought mask produced empty supervised span on row0")

    targs = TrainingArguments(
        output_dir=str(args.out_dir / "checkpoints"),
        num_train_epochs=args.epochs,
        per_device_train_batch_size=args.batch,
        gradient_accumulation_steps=args.grad_accum,
        learning_rate=args.lr,
        lr_scheduler_type="cosine",
        warmup_ratio=args.warmup_ratio,
        logging_steps=args.logging_steps,
        # Never dump Adam onto gocryptfs /root (p2238: 130G optimizer hang after 26/26).
        # Final weights are saved explicitly to /tmp below.
        save_strategy="no",
        save_steps=args.save_steps,
        save_total_limit=2,
        bf16=True,
        tf32=True,
        optim="adamw_torch",
        report_to=[],
        remove_unused_columns=False,
        dataloader_num_workers=2,
        gradient_checkpointing=True,
        max_grad_norm=1.0,
    )
    trainer = Trainer(
        model=model,
        args=targs,
        train_dataset=ds,
        data_collator=collate,
        callbacks=[PrintLossCallback()],
    )
    print("[train] starting full FT", flush=True)
    trainer.train()

    # Save to /tmp first (gocryptfs EFAULT lessons), then symlink/copy.
    full_dir = args.out_dir / "full_ft"
    tmp_out = Path("/tmp/h122_full_ft_save")
    if tmp_out.exists():
        import shutil

        shutil.rmtree(tmp_out)
    tmp_out.mkdir(parents=True)
    print(f"[train] saving full model → {tmp_out} shard={args.max_shard_size}", flush=True)
    # Contig-clone tensors off mmap before save (visual restore / gocryptfs lessons).
    trainer.model.save_pretrained(
        str(tmp_out),
        safe_serialization=True,
        max_shard_size=args.max_shard_size,
    )
    tok.save_pretrained(str(tmp_out))
    # Never copytree onto gocryptfs /root — hangs (WCHAN=request_wait_answer; p472/p473).
    import shutil

    if full_dir.is_symlink():
        full_dir.unlink()
    elif full_dir.exists():
        shutil.rmtree(full_dir)
    full_dir.symlink_to(tmp_out)
    print(f"[train] symlinked save → {full_dir} -> {tmp_out}", flush=True)

    meta["elapsed_s"] = time.time() - t0
    meta["finished_utc"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
    meta["full_ft_dir"] = str(full_dir)
    meta["trainable_params"] = int(n_train)
    meta["frozen_visual_params"] = int(n_freeze)
    meta["sample0_supervised_tokens"] = n_sup
    meta["thought_ok"] = ds.n_thought_ok
    (args.out_dir / "train_result.json").write_text(json.dumps(meta, indent=2))
    (args.out_dir / "train.done").write_text(meta["finished_utc"] + "\n")
    print(json.dumps(meta, indent=2), flush=True)
    print("[train] DONE", flush=True)


if __name__ == "__main__":
    main()
