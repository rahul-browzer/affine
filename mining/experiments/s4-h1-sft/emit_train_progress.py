#!/usr/bin/env python3
"""Emit H1 train progress/loss JSON on the pod for host harvest SCP.

Parses tqdm step from h1_train.nohup, trainer_state.json loss history at
save_steps, and any stdout / [train-log] loss dicts between checkpoints.
"""
from __future__ import annotations

import json
import re
import shutil
import time
import urllib.request
from pathlib import Path


def _num(v):
    if v is None:
        return None
    try:
        return float(v)
    except (TypeError, ValueError):
        return None


def main() -> None:
    raw = (
        Path("/root/logs/h1_train.nohup")
        .read_bytes()
        .decode("utf-8", "replace")
        .replace("\r", "\n")
    )
    steps = [int(m.group(1)) for m in re.finditer(r"(\d+)/110\s*\[", raw)]
    last = steps[-1] if steps else None
    ckpt_root = Path("/root/h1/train/checkpoints")

    def _ckpt_step(path: Path) -> int:
        # Lexical sort puts checkpoint-100 before checkpoint-50; use numeric step.
        m = re.search(r"checkpoint-(\d+)$", path.name if path.is_dir() else path.parent.name)
        return int(m.group(1)) if m else -1

    ckpt_dirs = (
        [d for d in ckpt_root.glob("checkpoint-*") if d.is_dir()]
        if ckpt_root.is_dir()
        else []
    )
    ckpts = [d.name for d in sorted(ckpt_dirs, key=_ckpt_step)]
    engines = {}
    for port, name in [(8000, "teacher"), (8001, "king"), (8002, "chall")]:
        try:
            with urllib.request.urlopen(
                f"http://127.0.0.1:{port}/health", timeout=3
            ) as r:
                engines[name] = r.status
        except Exception as e:
            engines[name] = str(e)

    loss_logs = []
    state_path = None
    candidates = []
    if ckpt_root.is_dir():
        candidates.extend(
            sorted(
                ckpt_root.glob("checkpoint-*/trainer_state.json"),
                key=lambda p: _ckpt_step(p.parent),
            )
        )
    adapter_state = Path("/root/h1/train/adapter/trainer_state.json")
    if adapter_state.is_file():
        candidates.append(adapter_state)
    if candidates:
        state_path = candidates[-1]
        try:
            st = json.loads(state_path.read_text())
            for row in st.get("log_history") or []:
                if "loss" in row:
                    loss_logs.append(
                        {
                            "step": row.get("step"),
                            "epoch": row.get("epoch"),
                            "loss": row.get("loss"),
                            "grad_norm": row.get("grad_norm"),
                            "learning_rate": row.get("learning_rate"),
                            "source": "trainer_state",
                        }
                    )
        except Exception as e:
            loss_logs = [{"error": str(e)}]

    stdout_losses = []
    for m in re.finditer(r"\[train-log\]\s+step=(\d+)\s+(\{[^\n]*\})", raw):
        try:
            payload = json.loads(m.group(2))
        except Exception:
            continue
        if "loss" not in payload:
            continue
        stdout_losses.append(
            {
                "step": int(m.group(1)),
                "epoch": _num(payload.get("epoch")),
                "loss": _num(payload.get("loss")),
                "grad_norm": _num(payload.get("grad_norm")),
                "learning_rate": _num(payload.get("learning_rate")),
                "source": "train-log",
            }
        )
    # Bare Trainer dict dumps (single-quoted); often concatenated on one line
    # after a tqdm clear, so scan the whole buffer with finditer.
    for m in re.finditer(
        r"\{[^{}]*?'loss':\s*'([^']+)'[^{}]*?'grad_norm':\s*'([^']+)'"
        r"[^{}]*?'learning_rate':\s*'([^']+)'[^{}]*?'epoch':\s*'([^']+)'[^{}]*?\}",
        raw,
        flags=re.DOTALL,
    ):
        stdout_losses.append(
            {
                "step": None,
                "epoch": _num(m.group(4)),
                "loss": _num(m.group(1)),
                "grad_norm": _num(m.group(2)),
                "learning_rate": _num(m.group(3)),
                "source": "stdout-dict",
            }
        )

    by_step = {r["step"]: r for r in loss_logs if r.get("step") is not None}
    for r in stdout_losses:
        s = r.get("step")
        if s is not None:
            if s in by_step:
                continue
            loss_logs.append(r)
            continue
        r = dict(r)
        ep = r.get("epoch")
        if (
            last is not None
            and ep is not None
            and abs(ep - round(ep)) < 1e-6
            and abs(ep - (last / 110.0) * 2.0) < 0.2
        ):
            r["step"] = last
        loss_logs.append(r)
    def _loss_key(r):
        # Prefer highest known step, then epoch. Untagged stdout rows sort first.
        return (
            r.get("step") if r.get("step") is not None else -1,
            r.get("epoch") if r.get("epoch") is not None else -1,
        )

    loss_logs.sort(key=_loss_key)

    seen = Path("/root/h1/mid_ckpt_salvaged.txt")
    mid_salvaged = (
        [ln.strip() for ln in seen.read_text().splitlines() if ln.strip()]
        if seen.is_file()
        else []
    )
    out = {
        "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "step": last,
        "total": 110,
        "frac": (last / 110 if last is not None else None),
        "train_done": Path("/root/h1/train/train.done").exists(),
        "ckpt_dirs": ckpts,
        "pipeline_alive": Path("/root/logs/h1_pipeline.pid").exists(),
        "engines": engines,
        "trainer_state": str(state_path) if state_path else None,
        "n_loss_logs": len(loss_logs),
        "first_loss": next(
            (r["loss"] for r in loss_logs if r.get("loss") is not None), None
        ),
        "last_loss": next(
            (r["loss"] for r in reversed(loss_logs) if r.get("loss") is not None),
            None,
        ),
        "loss_logs": loss_logs,
        "mid_salvaged": mid_salvaged,
        "n_stdout_losses": len(stdout_losses),
    }
    Path("/root/affine_data").mkdir(parents=True, exist_ok=True)
    Path("/root/affine_data/h1_train_progress.json").write_text(
        json.dumps(out, indent=2) + "\n"
    )
    Path("/root/affine_data/h1_train_loss.json").write_text(
        json.dumps(
            {
                "utc": out["utc"],
                "step": last,
                "trainer_state": out["trainer_state"],
                "first_loss": out["first_loss"],
                "last_loss": out["last_loss"],
                "n_loss_logs": out["n_loss_logs"],
                "n_stdout_losses": out["n_stdout_losses"],
                "loss_logs": loss_logs,
                "note": "trainer_state at save_steps + stdout/[train-log] dicts between ckpts",
            },
            indent=2,
        )
        + "\n"
    )
    if state_path and state_path.is_file():
        shutil.copy2(state_path, "/root/affine_data/h1_trainer_state.json")
    print(json.dumps({k: out[k] for k in out if k != "loss_logs"}))
    print(
        "loss_logs",
        len(loss_logs),
        "stdout",
        len(stdout_losses),
        "first",
        out["first_loss"],
        "last",
        out["last_loss"],
    )


if __name__ == "__main__":
    main()
