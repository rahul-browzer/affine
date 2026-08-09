#!/usr/bin/env python3
"""H139/F44: Online DPO on self-sampled thoughts labeled by teacher Λ2.

Sample G=2 thoughts from the live policy, score each with teacher:
  r = lpC(y | z) − lpC(y | ∅)
chosen = higher-r, rejected = lower-r. DPO vs frozen base (adapters off).

Orthogonal to F43 (offline duel prefs, no sampling) and F37/F42
(REINFORCE / BoN-CE on the same reward).
"""
from __future__ import annotations

import argparse
import json
import math
import os
import sys
import time
from pathlib import Path

import httpx
import torch
import torch.nn.functional as F
from peft import LoraConfig, TaskType, get_peft_model
from transformers import AutoModelForCausalLM, AutoTokenizer

_AFFINE = Path("/root/mining_src/affine_pkg")
if _AFFINE.is_dir() and str(_AFFINE) not in sys.path:
    sys.path.insert(0, str(_AFFINE))
from evalsrv.chat import THINK_CLOSE, THINK_OPEN, force_text  # noqa: E402

EMPTY_THOUGHTS = ""


def _msg_chars(row: dict) -> int:
    return sum(len(m.get("content") or "") for m in row.get("messages") or [])


def _normalize_z(z_text: str) -> str:
    if THINK_CLOSE in z_text:
        latent, _, _rest = z_text.partition(THINK_CLOSE)
        return latent.strip()
    for marker in ("```bash", "THOUGHT:"):
        i = z_text.find(marker)
        if i >= 0:
            return z_text[:i].strip()
    return z_text.strip()


def _teacher_lp_per_byte(
    client: httpx.Client,
    teacher_url: str,
    teacher_model: str,
    teacher_repo: str,
    teacher_rev: str | None,
    messages: list[dict],
    thoughts: str,
    action: str,
) -> float:
    full = force_text(teacher_repo, teacher_rev, messages, thoughts, action)
    action_start = len(full) - len(action)
    from evalsrv.chat import get_tokenizer

    tok = get_tokenizer(teacher_repo, teacher_rev)
    enc = tok(full, add_special_tokens=False, return_offsets_mapping=True)
    n_prompt = sum(1 for s, _ in enc["offset_mapping"] if s < action_start)
    r = client.post(
        f"{teacher_url.rstrip('/')}/completions",
        json={
            "model": teacher_model,
            "prompt": full,
            "max_tokens": 1,
            "temperature": 0,
            "echo": True,
            "logprobs": 0,
            "add_special_tokens": False,
        },
        timeout=180.0,
    )
    r.raise_for_status()
    lp = r.json()["choices"][0]["logprobs"]["token_logprobs"]
    span = [x for x in lp[n_prompt:-1] if x is not None]
    n_bytes = max(len(action.encode()), 1)
    return sum(span) / n_bytes if span else 0.0


def _resolve_teacher_model(client: httpx.Client, teacher_url: str) -> str:
    d = client.get(f"{teacher_url.rstrip('/')}/models", timeout=30.0).json()
    ids = [m["id"] for m in d.get("data", [])]
    if not ids:
        raise RuntimeError(f"no models at {teacher_url}")
    return ids[0]


def _generate_thought(
    model,
    tok,
    prompt: str,
    max_new: int,
    temperature: float,
    device: torch.device,
) -> str:
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
    return text[:cut]


def _logp_continuation(
    model,
    tok,
    prompt: str,
    text: str,
    device: torch.device,
) -> torch.Tensor:
    enc = tok(prompt, add_special_tokens=False, return_tensors="pt")
    forced = tok(prompt + text, add_special_tokens=False, return_tensors="pt")
    ids = forced["input_ids"].to(device)
    n_p = enc["input_ids"].shape[1]
    logits = model(input_ids=ids).logits
    logp = F.log_softmax(logits[0, n_p - 1 : -1], dim=-1)
    targets = ids[0, n_p:]
    if targets.numel() == 0:
        return torch.zeros((), device=device, requires_grad=True)
    tok_lp = logp.gather(1, targets.unsqueeze(1)).squeeze(1)
    return tok_lp.mean()


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", required=True)
    ap.add_argument("--data", type=Path, required=True)
    ap.add_argument("--out-dir", type=Path, required=True)
    ap.add_argument("--teacher-url", default="http://127.0.0.1:8000/v1")
    ap.add_argument("--teacher-repo", default="zai-org/GLM-4.5-Air-FP8")
    ap.add_argument("--teacher-rev", default="")
    ap.add_argument("--max-len", type=int, default=6144)
    ap.add_argument("--max-new", type=int, default=256)
    ap.add_argument("--epochs", type=float, default=1.0)
    ap.add_argument("--lr", type=float, default=5e-6)
    ap.add_argument("--lora-r", type=int, default=16)
    ap.add_argument("--lora-alpha", type=int, default=32)
    ap.add_argument("--beta", type=float, default=0.1)
    ap.add_argument("--group-size", type=int, default=2)
    ap.add_argument("--temperature", type=float, default=0.8)
    ap.add_argument("--max-steps", type=int, default=150)
    ap.add_argument("--min-gap", type=float, default=0.005)
    args = ap.parse_args()

    t0 = time.time()
    args.out_dir.mkdir(parents=True, exist_ok=True)
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    teacher_rev = args.teacher_rev or None

    raw = [
        json.loads(l)
        for l in args.data.read_text().splitlines()
        if l.strip()
    ]
    budget = int(args.max_len * 2.0)
    rows = [r for r in raw if r.get("y") and _msg_chars(r) <= budget]
    rows.sort(key=_msg_chars)
    print(f"[odpo] kept={len(rows)}/{len(raw)} budget_chars={budget}", flush=True)
    if len(rows) < 50:
        raise SystemExit(f"too few rows after fit-filter: {len(rows)}")

    http = httpx.Client()
    for i in range(120):
        try:
            teacher_model = _resolve_teacher_model(http, args.teacher_url)
            break
        except Exception as e:
            print(f"[odpo] wait teacher ({i}): {e}", flush=True)
            time.sleep(15)
    else:
        raise SystemExit(f"teacher not ready at {args.teacher_url}")
    print(f"[odpo] teacher_model={teacher_model}", flush=True)

    meta = {
        "experiment": "s4-h139-f44-tok-online-dpo-l2",
        "family": "F44",
        "method": "online_dpo_teacher_l2",
        "base": args.base,
        "data": str(args.data),
        "n_rows": len(rows),
        "lr": args.lr,
        "lora_r": args.lora_r,
        "lora_alpha": args.lora_alpha,
        "beta": args.beta,
        "group_size": args.group_size,
        "min_gap": args.min_gap,
        "max_new": args.max_new,
        "max_steps": args.max_steps,
        "teacher_url": args.teacher_url,
        "teacher_repo": args.teacher_repo,
        "teacher_model": teacher_model,
        "cuda_visible": os.environ.get("CUDA_VISIBLE_DEVICES"),
        "started_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    }
    (args.out_dir / "train_config.json").write_text(json.dumps(meta, indent=2))
    print(json.dumps(meta, indent=2), flush=True)

    tok = AutoTokenizer.from_pretrained(args.base, trust_remote_code=False)
    if tok.pad_token is None:
        tok.pad_token = tok.eos_token

    print(f"[odpo] loading base {args.base}", flush=True)
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
            messages = row["messages"]
            prompt = tok.apply_chat_template(
                messages, tokenize=False, add_generation_prompt=True
            )
            if not prompt.rstrip().endswith(THINK_OPEN):
                prompt = prompt + THINK_OPEN
            p_ids = tok(prompt, add_special_tokens=False)["input_ids"]
            if len(p_ids) > args.max_len - args.max_new - 64:
                continue
            y = row["y"]
            if not y.startswith("\n") and not y.startswith("```"):
                y_text = f"```bash\n{y}\n```"
            else:
                y_text = y

            rewards: list[float] = []
            texts: list[str] = []
            for _g in range(args.group_size):
                z_text = _generate_thought(
                    model,
                    tok,
                    prompt,
                    args.max_new,
                    args.temperature,
                    device,
                )
                z_norm = _normalize_z(z_text)
                try:
                    lp_c = _teacher_lp_per_byte(
                        http,
                        args.teacher_url,
                        teacher_model,
                        args.teacher_repo,
                        teacher_rev,
                        messages,
                        z_norm,
                        y_text,
                    )
                    lp_e = _teacher_lp_per_byte(
                        http,
                        args.teacher_url,
                        teacher_model,
                        args.teacher_repo,
                        teacher_rev,
                        messages,
                        EMPTY_THOUGHTS,
                        y_text,
                    )
                    r = float(lp_c - lp_e)
                except Exception as e:
                    print(
                        f"[odpo] teacher score fail step={steps}: {e}",
                        flush=True,
                    )
                    raise SystemExit(
                        f"teacher score fail at step={steps}: {e}"
                    )
                rewards.append(r)
                texts.append(z_norm)

            if len(rewards) < 2:
                continue
            order = sorted(range(len(rewards)), key=lambda i: rewards[i], reverse=True)
            best_i, worst_i = order[0], order[-1]
            gap = rewards[best_i] - rewards[worst_i]
            if gap < args.min_gap or texts[best_i] == texts[worst_i]:
                print(
                    f"[odpo] skip step={steps}: gap={gap:.5f} min={args.min_gap}",
                    flush=True,
                )
                continue

            chosen = texts[best_i]
            rejected = texts[worst_i]

            model.train()
            lp_c = _logp_continuation(model, tok, prompt, chosen, device)
            lp_r = _logp_continuation(model, tok, prompt, rejected, device)
            with torch.no_grad():
                with model.disable_adapter():
                    model.eval()
                    ref_c = _logp_continuation(model, tok, prompt, chosen, device)
                    ref_r = _logp_continuation(
                        model, tok, prompt, rejected, device
                    )
            model.train()

            logits = args.beta * ((lp_c - ref_c) - (lp_r - ref_r))
            loss = -F.logsigmoid(logits)

            opt.zero_grad(set_to_none=True)
            loss.backward()
            torch.nn.utils.clip_grad_norm_(
                (p for p in model.parameters() if p.requires_grad), 1.0
            )
            opt.step()

            steps += 1
            rec = {
                "step": steps,
                "loss": float(loss.detach().item()),
                "logit": float(logits.detach().item()),
                "gap": gap,
                "best_r": rewards[best_i],
                "worst_r": rewards[worst_i],
                "rewards": rewards,
                "z0": chosen[:80],
            }
            hist.append(rec)
            if steps % 5 == 0 or steps <= 3:
                print(f"[odpo-log] {json.dumps(rec)}", flush=True)
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
        "mean_loss_last20": (
            sum(h["loss"] for h in hist[-20:]) / max(1, len(hist[-20:]))
        ),
        "mean_gap_last20": (
            sum(h["gap"] for h in hist[-20:]) / max(1, len(hist[-20:]))
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
    print(f"[odpo] DONE {json.dumps(result)}", flush=True)


if __name__ == "__main__":
    main()
