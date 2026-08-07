#!/usr/bin/env python3
"""Short LoRA SFT from kevin init on harvested teacher_refs.

Runs on free GPUs (default 6,7) while teacher/king/chall stay hot on 0-5.
Exports adapter under --out-dir; merge_lora.py builds a full safetensors dir
for stock vllm serve.
"""
from __future__ import annotations

import argparse
import json
import os
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


class PrintLossCallback(TrainerCallback):
    """Force loss lines onto stdout — tqdm.write is swallowed under nohup redirects."""

    def on_log(self, args, state, control, logs=None, **kwargs):  # noqa: ANN001
        if not logs or not state.is_world_process_zero:
            return
        payload = {k: logs[k] for k in ("loss", "grad_norm", "learning_rate", "epoch") if k in logs}
        print(
            f"[train-log] step={state.global_step} {json.dumps(payload)}",
            flush=True,
        )


THINK_OPEN = "<think>"


class RefSFTDataset(Dataset):
    def __init__(self, path: Path, tokenizer, max_len: int):
        self.rows = []
        with path.open() as f:
            for line in f:
                if line.strip():
                    self.rows.append(json.loads(line))
        self.tok = tokenizer
        self.max_len = max_len

    def __len__(self) -> int:
        return len(self.rows)

    def __getitem__(self, idx: int) -> dict:
        r = self.rows[idx]
        prompt = self.tok.apply_chat_template(
            r["messages"], tokenize=False, add_generation_prompt=True
        )
        if not prompt.rstrip().endswith(THINK_OPEN):
            prompt = prompt + THINK_OPEN
        full = prompt + r["completion"]
        # Tokenize full; mask prompt tokens in labels.
        prompt_ids = self.tok(prompt, add_special_tokens=False)["input_ids"]
        full_ids = self.tok(
            full,
            add_special_tokens=False,
            truncation=True,
            max_length=self.max_len,
        )["input_ids"]
        labels = list(full_ids)
        n_prompt = min(len(prompt_ids), len(full_ids))
        for i in range(n_prompt):
            labels[i] = -100
        # If truncated into the prompt, skip (Trainer will ignore empty-ish).
        if n_prompt >= len(full_ids) - 1:
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
    ap.add_argument("--epochs", type=float, default=2.0)
    ap.add_argument("--lr", type=float, default=1e-4)
    ap.add_argument("--lora-r", type=int, default=16)
    ap.add_argument("--lora-alpha", type=int, default=32)
    ap.add_argument("--batch", type=int, default=1)
    ap.add_argument("--grad-accum", type=int, default=8)
    ap.add_argument("--warmup-ratio", type=float, default=0.03)
    ap.add_argument("--save-steps", type=int, default=50)
    ap.add_argument("--logging-steps", type=int, default=5)
    args = ap.parse_args()

    t0 = time.time()
    args.out_dir.mkdir(parents=True, exist_ok=True)
    meta = {
        "base": args.base,
        "data": str(args.data),
        "max_len": args.max_len,
        "epochs": args.epochs,
        "lr": args.lr,
        "lora_r": args.lora_r,
        "lora_alpha": args.lora_alpha,
        "batch": args.batch,
        "grad_accum": args.grad_accum,
        "cuda_visible": os.environ.get("CUDA_VISIBLE_DEVICES"),
        "started_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    }
    (args.out_dir / "train_config.json").write_text(json.dumps(meta, indent=2))
    print(json.dumps(meta, indent=2), flush=True)

    tok = AutoTokenizer.from_pretrained(args.base, trust_remote_code=False)
    if tok.pad_token is None:
        tok.pad_token = tok.eos_token

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

    # Qwen3-ish: target common proj modules; fall back if names differ.
    target = ["q_proj", "k_proj", "v_proj", "o_proj", "gate_proj", "up_proj", "down_proj"]
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

    ds = RefSFTDataset(args.data, tok, args.max_len)
    print(f"[train] examples={len(ds)}", flush=True)
    if len(ds) < 20:
        raise SystemExit("too few examples")

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
    (args.out_dir / "train_result.json").write_text(json.dumps(meta, indent=2))
    (args.out_dir / "train.done").write_text(meta["finished_utc"] + "\n")
    print(json.dumps(meta, indent=2), flush=True)
    print("[train] DONE", flush=True)


if __name__ == "__main__":
    main()
