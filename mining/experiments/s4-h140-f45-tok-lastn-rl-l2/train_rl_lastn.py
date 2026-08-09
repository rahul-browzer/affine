#!/usr/bin/env python3
"""H140/F45: last-N-layer full-rank REINFORCE maximizing teacher Λ2.

Orthogonal to F37 LoRA-REINFORCE: LESSONS say LoRA cannot move Λ2 (base-model
property). Unfreeze the last N transformer layers + lm_head (freeze visual +
earlier layers) and run the same teacher-Λ2 reward.

Reward: r = lpC(y|z) − lpC(y|∅). G-sample mean baseline. Save full weights
to /tmp (gocryptfs lesson) and symlink under out_dir/full_ft.
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
import re
from transformers import AutoModelForCausalLM, AutoTokenizer

# evalsrv chat helpers (force_text / empty) — same contract as the validator.
_AFFINE = Path("/root/mining_src/affine_pkg")
if _AFFINE.is_dir() and str(_AFFINE) not in sys.path:
    sys.path.insert(0, str(_AFFINE))
from evalsrv.chat import THINK_CLOSE, THINK_OPEN, force_text  # noqa: E402

EMPTY_THOUGHTS = ""


def _msg_chars(row: dict) -> int:
    return sum(len(m.get("content") or "") for m in row.get("messages") or [])


def _normalize_z(z_text: str) -> str:
    """Sample started inside <think>; strip close-tag / bash for force_text z."""
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
    # Locate action token span with teacher tokenizer offsets.
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


def _sample_thought(
    model,
    tok,
    prompt: str,
    max_new: int,
    temperature: float,
    device: torch.device,
) -> tuple[str, torch.Tensor]:
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
    ap.add_argument("--teacher-url", default="http://127.0.0.1:8000/v1")
    ap.add_argument("--teacher-repo", default="zai-org/GLM-4.5-Air-FP8")
    ap.add_argument("--teacher-rev", default="")
    ap.add_argument("--max-len", type=int, default=6144)
    ap.add_argument("--max-new", type=int, default=256)
    ap.add_argument("--epochs", type=float, default=1.0)
    ap.add_argument("--lr", type=float, default=1e-6)
    ap.add_argument("--last-n", type=int, default=8)
    ap.add_argument("--group-size", type=int, default=2)
    ap.add_argument("--temperature", type=float, default=0.8)
    ap.add_argument("--max-steps", type=int, default=150)
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
    print(f"[rl] kept={len(rows)}/{len(raw)} budget_chars={budget}", flush=True)
    if len(rows) < 50:
        raise SystemExit(f"too few rows after fit-filter: {len(rows)}")

    http = httpx.Client()
    # Wait for teacher
    for i in range(120):
        try:
            teacher_model = _resolve_teacher_model(http, args.teacher_url)
            break
        except Exception as e:
            print(f"[rl] wait teacher ({i}): {e}", flush=True)
            time.sleep(15)
    else:
        raise SystemExit(f"teacher not ready at {args.teacher_url}")
    print(f"[rl] teacher_model={teacher_model}", flush=True)

    meta = {
        "experiment": "s4-h140-f45-tok-lastn-rl-l2",
        "family": "F45",
        "method": "reinforce_teacher_l2_lastn_fullrank",
        "base": args.base,
        "data": str(args.data),
        "n_rows": len(rows),
        "lr": args.lr,
        "last_n": args.last_n,
        "group_size": args.group_size,
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

    layer_re = re.compile(r"(?:^|\.)layers\.(\d+)\.")
    layer_ids = sorted(
        {
            int(m.group(1))
            for n, _ in model.named_parameters()
            if (m := layer_re.search(n))
        }
    )
    if not layer_ids:
        raise SystemExit("no layers.* params found — cannot select last-N")
    cutoff = layer_ids[-args.last_n] if len(layer_ids) >= args.last_n else layer_ids[0]
    n_train = n_freeze = 0
    for name, p in model.named_parameters():
        m = layer_re.search(name)
        train = False
        if "visual" in name:
            train = False
        elif m is not None:
            train = int(m.group(1)) >= cutoff
        elif "lm_head" in name:
            train = True
        elif name.endswith("norm.weight") or ".norm.weight" in name or "model.norm" in name:
            train = True
        else:
            train = False
        p.requires_grad = train
        if train:
            n_train += p.numel()
        else:
            n_freeze += p.numel()
    print(
        f"[rl] last_n={args.last_n} layers={layer_ids[0]}..{layer_ids[-1]} "
        f"cutoff>={cutoff} trainable={n_train:,} frozen={n_freeze:,}",
        flush=True,
    )
    if n_train < 1_000_000:
        raise SystemExit(f"too few trainable params: {n_train}")
    # SGD: Adam moments on multi-B MoE last layers OOM on 2×H200.
    opt = torch.optim.SGD(
        (p for p in model.parameters() if p.requires_grad),
        lr=args.lr,
        momentum=0.9,
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
            logps: list[torch.Tensor] = []
            texts: list[str] = []
            for _g in range(args.group_size):
                z_text, sum_lp = _sample_thought(
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
                    print(f"[rl] teacher score fail step={steps}: {e}", flush=True)
                    r = 0.0
                if not math.isfinite(r):
                    r = 0.0
                rewards.append(r)
                logps.append(sum_lp)
                texts.append(z_norm[:80])

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
            # No mid-ckpt: full MoE shards are huge; final save only.

    # Save to /tmp then symlink (gocryptfs hang lesson p472/p493).
    import shutil

    tmp_out = Path("/tmp/h140_full_ft_save")
    if tmp_out.exists():
        shutil.rmtree(tmp_out)
    tmp_out.mkdir(parents=True)
    print(f"[rl] saving full model → {tmp_out}", flush=True)
    model.save_pretrained(
        str(tmp_out), safe_serialization=True, max_shard_size="5GB"
    )
    tok.save_pretrained(str(tmp_out))
    # Restore processor/visual sidecars from base if missing.
    base_p = Path(args.base)
    for name in (
        "preprocessor_config.json",
        "processor_config.json",
        "chat_template.jinja",
        "model-visual-restored.safetensors",
    ):
        src = base_p / name
        dst = tmp_out / name
        if src.is_file() and not dst.exists():
            shutil.copy2(src, dst)
    full_dir = args.out_dir / "full_ft"
    if full_dir.is_symlink():
        full_dir.unlink()
    elif full_dir.exists():
        shutil.rmtree(full_dir)
    full_dir.symlink_to(tmp_out)
    # Also point merged-style marker for post_train.
    (args.out_dir / "adapter").mkdir(parents=True, exist_ok=True)
    (args.out_dir / "adapter" / "FULL_FT_MARKER").write_text(
        str(full_dir) + "\n"
    )
    result = {
        "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "steps": steps,
        "elapsed_s": time.time() - t0,
        "mean_reward_last20": (
            sum(h["mean_r"] for h in hist[-20:]) / max(1, len(hist[-20:]))
        ),
        "full_ft": str(full_dir),
        "last_n": args.last_n,
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
