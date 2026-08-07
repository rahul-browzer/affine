#!/usr/bin/env python3
"""H1v2 LoRA SFT: thought-only (or full) loss from kevin init on teacher_refs.

Default --loss-on thought masks labels from the first bash fence onward so
we distill z_C without fitting y_C under z_C (H1 envelope failure).
Runs on free GPUs (default 6,7) while teacher/king/chall stay on 0-5.
"""
from __future__ import annotations

import argparse
import json
import os
import sys
import time
from pathlib import Path

import torch
from peft import LoraConfig, TaskType, get_peft_model
from torch.utils.data import Dataset
from transformers import (
    AutoModelForCausalLM,
    AutoTokenizer,
    Trainer,
    TrainerCallback,
    TrainingArguments,
)

# Allow `python train_lora.py` from this dir.
sys.path.insert(0, str(Path(__file__).resolve().parent))
from thought_mask import thought_cut_char  # noqa: E402

THINK_OPEN = "<think>"


class PrintLossCallback(TrainerCallback):
    """Force loss lines onto stdout — tqdm.write is swallowed under nohup redirects."""

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


class RefSFTDataset(Dataset):
    def __init__(
        self,
        path: Path,
        tokenizer,
        max_len: int,
        loss_on: str = "thought",
    ):
        self.rows = []
        with path.open() as f:
            for line in f:
                if line.strip():
                    self.rows.append(json.loads(line))
        self.tok = tokenizer
        self.max_len = max_len
        if loss_on not in ("thought", "full"):
            raise ValueError(f"loss_on must be thought|full, got {loss_on!r}")
        self.loss_on = loss_on
        self.n_no_fence = 0
        self.n_thought_ok = 0
        self._probe_cuts()

    def _probe_cuts(self) -> None:
        if self.loss_on != "thought":
            return
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

        # Mask prompt tokens via char offsets (prompt is a prefix of `full`).
        prompt_end = len(prompt)
        for i, (a, b) in enumerate(offsets):
            # Special / empty span tokens: keep masked if they sit in prompt.
            if b <= prompt_end:
                labels[i] = -100

        if self.loss_on == "thought":
            cut = thought_cut_char(completion)
            if cut is None:
                # No fence → do not train this row (all -100).
                labels = [-100] * len(full_ids)
            else:
                # Absolute char index in `full` where action/fence begins.
                action_start = prompt_end + cut
                for i, (a, b) in enumerate(offsets):
                    if labels[i] == -100:
                        continue
                    # Mask any token that overlaps the action region.
                    if a >= action_start:
                        labels[i] = -100

        # If truncated into the prompt / empty supervised span, skip.
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
        "attention_mask": torch.stack(
            [pad(f["attention_mask"], 0) for f in features]
        ),
        "labels": torch.stack([pad(f["labels"], -100) for f in features]),
    }


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", required=True, help="kevin snapshot or Hub id")
    ap.add_argument("--data", type=Path, required=True)
    ap.add_argument("--out-dir", type=Path, required=True)
    ap.add_argument("--max-len", type=int, default=8192)
    ap.add_argument("--epochs", type=float, default=1.0)
    ap.add_argument("--lr", type=float, default=2e-5)
    ap.add_argument("--lora-r", type=int, default=16)
    ap.add_argument("--lora-alpha", type=int, default=32)
    ap.add_argument("--batch", type=int, default=1)
    ap.add_argument("--grad-accum", type=int, default=8)
    ap.add_argument("--warmup-ratio", type=float, default=0.03)
    ap.add_argument("--save-steps", type=int, default=50)
    ap.add_argument("--logging-steps", type=int, default=5)
    ap.add_argument(
        "--loss-on",
        choices=("thought", "full"),
        default="thought",
        help="thought = mask from bash fence; full = H1-style whole completion",
    )
    args = ap.parse_args()

    t0 = time.time()
    args.out_dir.mkdir(parents=True, exist_ok=True)
    meta = {
        "experiment": "s4-h1v2-sft",
        "base": args.base,
        "data": str(args.data),
        "max_len": args.max_len,
        "epochs": args.epochs,
        "lr": args.lr,
        "lora_r": args.lora_r,
        "lora_alpha": args.lora_alpha,
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

    print(f"[train] loading base {args.base}", flush=True)
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

    target = [
        "q_proj",
        "k_proj",
        "v_proj",
        "o_proj",
        "gate_proj",
        "up_proj",
        "down_proj",
    ]
    lora = LoraConfig(
        task_type=TaskType.CAUSAL_LM,
        r=args.lora_r,
        lora_alpha=args.lora_alpha,
        lora_dropout=0.05,
        target_modules=target,
        bias="none",
    )
    model = get_peft_model(model, lora)
    model.print_trainable_parameters()

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

    # One-row mask sanity (supervised token count).
    sample = ds[0]
    n_sup = int((sample["labels"] != -100).sum().item())
    n_tok = int(sample["input_ids"].numel())
    print(
        f"[train] sample0 supervised_tokens={n_sup}/{n_tok}",
        flush=True,
    )
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
    print("[train] starting", flush=True)
    trainer.train()
    adapter_dir = args.out_dir / "adapter"
    trainer.save_model(str(adapter_dir))
    tok.save_pretrained(str(adapter_dir))
    meta["elapsed_s"] = time.time() - t0
    meta["finished_utc"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
    meta["adapter_dir"] = str(adapter_dir)
    meta["sample0_supervised_tokens"] = n_sup
    meta["sample0_total_tokens"] = n_tok
    meta["thought_ok"] = ds.n_thought_ok
    meta["no_fence"] = ds.n_no_fence
    (args.out_dir / "train_result.json").write_text(json.dumps(meta, indent=2))
    (args.out_dir / "train.done").write_text(meta["finished_utc"] + "\n")
    print(json.dumps(meta, indent=2), flush=True)
    print("[train] DONE", flush=True)


if __name__ == "__main__":
    main()
