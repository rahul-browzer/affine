#!/usr/bin/env python3
"""Emit H1v2 train progress JSON on the pod for host harvest SCP."""
from __future__ import annotations

import json
import re
import time
import urllib.request
from pathlib import Path


def main() -> None:
    log = Path("/root/logs/h1v2_train.nohup")
    raw = (
        log.read_bytes().decode("utf-8", "replace").replace("\r", "\n")
        if log.exists()
        else ""
    )
    steps = [int(m.group(1)) for m in re.finditer(r"(\d+)/55\s*\[", raw)]
    last = steps[-1] if steps else None
    train_dir = Path("/root/h1v2/train")
    ckpts = (
        sorted(d.name for d in train_dir.glob("checkpoint-*") if d.is_dir())
        if train_dir.is_dir()
        else []
    )
    engines = {}
    for port, name in [(8000, "teacher"), (8001, "king"), (8002, "chall")]:
        try:
            with urllib.request.urlopen(
                f"http://127.0.0.1:{port}/health", timeout=3
            ) as r:
                engines[name] = r.status
        except Exception as e:  # noqa: BLE001
            engines[name] = str(e)

    losses = []
    for m in re.finditer(
        r"\[train-log\] step=(\d+) (\{.*\})", raw
    ):
        try:
            payload = json.loads(m.group(2))
        except json.JSONDecodeError:
            continue
        if "loss" in payload:
            losses.append(
                {"step": int(m.group(1)), "loss": float(payload["loss"])}
            )

    out = {
        "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "experiment": "s4-h1v2-sft",
        "step": last,
        "total": 55,
        "frac": (last / 55.0) if last is not None else None,
        "train_done": (train_dir / "train.done").exists(),
        "adapter_present": (train_dir / "adapter_config.json").exists(),
        "ckpt_dirs": ckpts,
        "engines": engines,
        "n_loss_logs": len(losses),
        "first_loss": losses[0]["loss"] if losses else None,
        "last_loss": losses[-1]["loss"] if losses else None,
        "pipe_waiting": Path("/root/logs/h1v2_pipeline.nohup").exists()
        and not Path("/root/logs/h1v2_pipeline.done").exists(),
        "pipe_done": Path("/root/logs/h1v2_pipeline.done").exists(),
        "pipe_aborted": Path("/root/logs/h1v2_pipeline.aborted").exists(),
        "n40_present": Path("/root/affine_data/h1v2_sim_result_n40.json").exists(),
    }
    dest = Path("/root/affine_data/h1v2_train_progress.json")
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_text(json.dumps(out, indent=2) + "\n")
    print(json.dumps(out))


if __name__ == "__main__":
    main()
