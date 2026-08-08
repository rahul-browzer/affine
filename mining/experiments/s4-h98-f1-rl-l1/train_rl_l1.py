#!/usr/bin/env python3
"""H98/F1: REINFORCE on thought tokens maximizing self-clipped L1lift.

Reward per sample z:
  r = clip( lp_per_byte(y | prompt+z) − lp_per_byte(y | prompt+empty), ±0.1 )

Policy gradient with G-sample mean baseline. No CE on harvested z — the
harvested file supplies (messages, y) prefixes only.
"""
from __future__ import annotations

import argparse
import json
import math
import os
import time
from pathlib import Path

import torch
import torch.nn.functional as F
from peft import LoraConfig, TaskType, get_peft_model
from transformers import AutoModelForCausalLM, AutoTokenizer

THINK_OPEN = "<think>"
THINK_CLOSE = "</think>"
EMPTY_THOUGHT = f"{THINK_OPEN}\n\n{THINK_CLOSE}\n\n"


def _msg_chars(row: dict) -> int:
    return sum(len(m.get("content") or "") for m in row.get("messages") or [])


def _lp_per_byte(
    model, tok, prompt: str, continuation: str, device: torch.device
) -> tuple[float, int]:
    """Mean logprob per UTF-8 byte of continuation under teacher-forcing."""
    if not continuation:
        return 0.0, 0
    full = prompt + continuation
    enc = tok(full, add_special_tokens=False, return_tensors="pt")
    prompt_ids = tok(prompt, add_special_tokens=False, return_tensors="pt")[
        "input_ids"
    ]
    n_prompt = prompt_ids.shape[1]
    input_ids = enc["input_ids"].to(device)
    if input_ids.shape[1] <= n_prompt + 1:
        return 0.0, 0
    with torch.no_grad():
        logits = model(input_ids=input_ids).logits
    # token i predicts token i+1
    logp = F.log_softmax(logits[0, n_prompt - 1 : -1], dim=-1)
    targets = input_ids[0, n_prompt:]
    tok_lp = logp.gather(1, targets.unsqueeze(1)).squeeze(1)
    total_lp = float(tok_lp.sum().item())
    nbytes = max(1, len(continuation.encode("utf-8")))
    return total_lp / nbytes, nbytes


def _sample_thought(
    model,
    tok,
    prompt: str,
    max_new: int,
    temperature: float,
    device: torch.device,
) -> tuple[str, torch.Tensor]:
    """Sample a thought; return (text, sum_logprob) with grad on logprob."""
    enc = tok(prompt, add_special_tokens=False, return_tensors="pt")
    model.eval()
    with torch.no_grad():
        out = model.generate(
            input_ids=enc["input_ids"].to(device),
            attention_mask=enc["attention_mask"].to(device),
            max_new_tokens=max_new,
            do_sample=True,
            temperature=temperature,
            top_p=0.95,
            pad_token_id=tok.pad_token_id or tok.eos_token_id,
            eos_token_id=tok.eos_token_id,
        )
    new_tokens = out[0, enc["input_ids"].shape[1] :]
    text = tok.decode(new_tokens, skip_special_tokens=True)
    cut = len(text)
    for marker in ("```bash", THINK_CLOSE):
        i = text.find(marker)
        if i >= 0:
            cut = min(
                cut, i + (len(THINK_CLOSE) if marker == THINK_CLOSE else 0)
            )
    text = text[:cut]
    # Teacher-force the sample under train mode for Σ log π(z)
    forced = tok(prompt + text, add_special_tokens=False, return_tensors="pt")
    ids = forced["input_ids"].to(device)
    n_p = enc["input_ids"].shape[1]
    model.train()
    logits = model(input_ids=ids).logits
    logp = F.log_softmax(logits[0, n_p - 1 : -1], dim=-1)
    targets = ids[0, n_p:]
    if targets.numel() == 0:
        return text, torch.zeros((), device=device, requires_grad=True)
    tok_lp = logp.gather(1, targets.unsqueeze(1)).squeeze(1)
    return text, tok_lp.sum()


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", required=True)
    ap.add_argument("--data", type=Path, required=True)
    ap.add_argument("--out-dir", type=Path, required=True)
    ap.add_argument("--max-len", type=int, default=6144)
    ap.add_argument("--max-new", type=int, default=256)
    ap.add_argument("--epochs", type=float, default=1.0)
    ap.add_argument("--lr", type=float, default=5e-6)
    ap.add_argument("--lora-r", type=int, default=16)
    ap.add_argument("--lora-alpha", type=int, default=32)
    ap.add_argument("--group-size", type=int, default=2)
    ap.add_argument("--temperature", type=float, default=0.8)
    ap.add_argument("--max-steps", type=int, default=200)
    ap.add_argument("--clip", type=float, default=0.1)
    args = ap.parse_args()

    t0 = time.time()
    args.out_dir.mkdir(parents=True, exist_ok=True)
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

    raw = [
        json.loads(l)
        for l in args.data.read_text().splitlines()
        if l.strip()
    ]
    budget = int(args.max_len * 2.0)
    rows = [r for r in raw if r.get("y") and _msg_chars(r) <= budget]
    rows.sort(key=_msg_chars)
    print(f"[rl] kept={len(rows)}/{len(raw)} budget_chars={budget}", flush=True)
    if len(rows) < 50:
        raise SystemExit(f"too few rows after fit-filter: {len(rows)}")

    meta = {
        "experiment": "s4-h98-f1-rl-l1",
        "family": "F1",
        "base": args.base,
        "data": str(args.data),
        "n_rows": len(rows),
        "lr": args.lr,
        "lora_r": args.lora_r,
        "lora_alpha": args.lora_alpha,
        "group_size": args.group_size,
        "max_new": args.max_new,
        "max_steps": args.max_steps,
        "clip": args.clip,
        "cuda_visible": os.environ.get("CUDA_VISIBLE_DEVICES"),
        "started_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    }
    (args.out_dir / "train_config.json").write_text(json.dumps(meta, indent=2))
    print(json.dumps(meta, indent=2), flush=True)

    tok = AutoTokenizer.from_pretrained(args.base, trust_remote_code=False)
    if tok.pad_token is None:
        tok.pad_token = tok.eos_token

    print(f"[rl] loading base {args.base}", flush=True)
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

    lora = LoraConfig(
        task_type=TaskType.CAUSAL_LM,
        r=args.lora_r,
        lora_alpha=args.lora_alpha,
        lora_dropout=0.05,
        target_modules=[
            "q_proj",
            "k_proj",
            "v_proj",
            "o_proj",
            "gate_proj",
            "up_proj",
            "down_proj",
        ],
    )
    model = get_peft_model(model, lora)
    model.print_trainable_parameters()
    opt = torch.optim.AdamW(
        (p for p in model.parameters() if p.requires_grad), lr=args.lr
    )

    steps = 0
    epoch = 0
    hist: list[dict] = []
    while steps < args.max_steps and epoch < math.ceil(args.epochs):
        epoch += 1
        for row in rows:
            if steps >= args.max_steps:
                break
            prompt = tok.apply_chat_template(
                row["messages"], tokenize=False, add_generation_prompt=True
            )
            if not prompt.rstrip().endswith(THINK_OPEN):
                prompt = prompt + THINK_OPEN
            # Truncate prompt tokens if needed
            p_ids = tok(prompt, add_special_tokens=False)["input_ids"]
            if len(p_ids) > args.max_len - args.max_new - 64:
                continue
            y = row["y"]
            if not y.startswith("\n") and not y.startswith("```"):
                # harvest y is usually the bash body; wrap as action block
                y_text = f"```bash\n{y}\n```"
            else:
                y_text = y

            rewards: list[float] = []
            logps: list[torch.Tensor] = []
            texts: list[str] = []
            for g in range(args.group_size):
                z_text, sum_lp = _sample_thought(
                    model,
                    tok,
                    prompt,
                    args.max_new,
                    args.temperature,
                    device,
                )
                # Build conditioned / empty prompts for y
                # After thought: close think if not present, then y
                z_body = z_text
                if THINK_CLOSE not in z_body:
                    z_full = z_body + f"\n{THINK_CLOSE}\n\n"
                else:
                    z_full = z_body if z_body.endswith("\n\n") else z_body + "\n\n"
                cond_prompt = prompt + z_full
                empty_prompt = (
                    prompt[: -len(THINK_OPEN)] + EMPTY_THOUGHT
                    if prompt.endswith(THINK_OPEN)
                    else prompt + "\n\n" + THINK_CLOSE + "\n\n"
                )
                # Actually EMPTY should replace thought: prompt without open + empty
                base_prompt = prompt
                if base_prompt.endswith(THINK_OPEN):
                    empty_prompt = base_prompt[: -len(THINK_OPEN)] + EMPTY_THOUGHT
                lp_c, n_c = _lp_per_byte(model, tok, cond_prompt, y_text, device)
                lp_e, n_e = _lp_per_byte(model, tok, empty_prompt, y_text, device)
                r = max(-args.clip, min(args.clip, lp_c - lp_e))
                rewards.append(r)
                logps.append(sum_lp)
                texts.append(z_text[:80])

            mean_r = sum(rewards) / len(rewards)
            loss = torch.zeros((), device=next(model.parameters()).device)
            for r, lp in zip(rewards, logps):
                adv = r - mean_r
                loss = loss + (-adv) * lp
            loss = loss / max(1, len(rewards))

            opt.zero_grad(set_to_none=True)
            if loss.requires_grad:
                loss.backward()
                torch.nn.utils.clip_grad_norm_(
                    (p for p in model.parameters() if p.requires_grad), 1.0
                )
                opt.step()

            steps += 1
            rec = {
                "step": steps,
                "mean_r": mean_r,
                "rewards": rewards,
                "loss": float(loss.detach().item()) if torch.is_tensor(loss) else 0.0,
                "z0": texts[0] if texts else "",
            }
            hist.append(rec)
            if steps % 5 == 0 or steps <= 3:
                print(f"[rl-log] {json.dumps(rec)}", flush=True)
            if steps % 50 == 0:
                ckpt = args.out_dir / "checkpoints" / f"step-{steps}"
                ckpt.mkdir(parents=True, exist_ok=True)
                model.save_pretrained(ckpt)
                tok.save_pretrained(ckpt)

    adapter = args.out_dir / "adapter"
    adapter.mkdir(parents=True, exist_ok=True)
    model.save_pretrained(adapter)
    tok.save_pretrained(adapter)
    result = {
        "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "steps": steps,
        "elapsed_s": time.time() - t0,
        "mean_reward_last20": (
            sum(h["mean_r"] for h in hist[-20:]) / max(1, len(hist[-20:]))
        ),
        "adapter": str(adapter),
    }
    (args.out_dir / "train_result.json").write_text(json.dumps(result, indent=2))
    (args.out_dir / "train_history.jsonl").write_text(
        "\n".join(json.dumps(h) for h in hist) + "\n"
    )
    (args.out_dir / "train.done").write_text(
        time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()) + "\n"
    )
    print(f"[rl] DONE {json.dumps(result)}", flush=True)


if __name__ == "__main__":
    main()
