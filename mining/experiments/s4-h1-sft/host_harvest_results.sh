#!/usr/bin/env bash
# Lightweight host-side poller: SCP H1 artifacts off mine-sim-1 before TTL.
# No GPU/weights on host — JSON/meta only.
set -euo pipefail

SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o StrictHostKeyChecking=accept-new
     -o ConnectTimeout=15 -p 40301 root@69.63.236.160)
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o StrictHostKeyChecking=accept-new
     -P 40301)
OUT=/home/const/subnet120/mining/experiments/s4-h1-sft/results
mkdir -p "$OUT"
log() { echo "[host-harvest] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

log "polling mine-sim-1 for H1 artifacts → $OUT"
# Aligned with pass-33 host deadman (pod kill 07:00Z); was 04:50Z under Lium TTL.
deadline=$(date -u -d '2026-08-07T06:55:00Z' +%s 2>/dev/null || date -u -d '2026-08-07 06:55:00' +%s)
got_sim=0
got_salvage=0
got_train=0

# Emit / refresh train step JSON on the pod (tqdm uses \r; parse on pod).
# Loss is NOT in h1_train.nohup under transformers 5.14 + tqdm+nohup — scrape
# trainer_state.json log_history once checkpoint-* appears (save_steps=50).
_emit_train_progress() {
  "${SSH[@]}" 'python3 - <<"PY"
from pathlib import Path
import json, re, time, urllib.request, shutil
raw = Path("/root/logs/h1_train.nohup").read_bytes().decode("utf-8", "replace").replace("\r", "\n")
steps = [int(m.group(1)) for m in re.finditer(r"(\d+)/110\s*\[", raw)]
last = steps[-1] if steps else None
ckpt_root = Path("/root/h1/train/checkpoints")
ckpts = sorted(d.name for d in ckpt_root.glob("checkpoint-*") if d.is_dir()) if ckpt_root.is_dir() else []
engines = {}
for port, name in [(8000, "teacher"), (8001, "king"), (8002, "chall")]:
    try:
        with urllib.request.urlopen(f"http://127.0.0.1:{port}/health", timeout=3) as r:
            engines[name] = r.status
    except Exception as e:
        engines[name] = str(e)
# Prefer newest trainer_state.json under checkpoints/ (or final adapter dir).
loss_logs = []
state_path = None
candidates = []
if ckpt_root.is_dir():
    candidates.extend(sorted(ckpt_root.glob("checkpoint-*/trainer_state.json")))
adapter_state = Path("/root/h1/train/adapter/trainer_state.json")
if adapter_state.is_file():
    candidates.append(adapter_state)
if candidates:
    state_path = candidates[-1]
    try:
        st = json.loads(state_path.read_text())
        for row in st.get("log_history") or []:
            if "loss" in row:
                loss_logs.append({
                    "step": row.get("step"),
                    "epoch": row.get("epoch"),
                    "loss": row.get("loss"),
                    "grad_norm": row.get("grad_norm"),
                    "learning_rate": row.get("learning_rate"),
                })
    except Exception as e:
        loss_logs = [{"error": str(e)}]
# Mid-salvage seen list (empty until first HF push).
seen = Path("/root/h1/mid_ckpt_salvaged.txt")
mid_salvaged = [ln.strip() for ln in seen.read_text().splitlines() if ln.strip()] if seen.is_file() else []
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
    "first_loss": loss_logs[0]["loss"] if loss_logs and "loss" in loss_logs[0] else None,
    "last_loss": loss_logs[-1]["loss"] if loss_logs and "loss" in loss_logs[-1] else None,
    "loss_logs": loss_logs,
    "mid_salvaged": mid_salvaged,
}
Path("/root/affine_data").mkdir(parents=True, exist_ok=True)
Path("/root/affine_data/h1_train_progress.json").write_text(json.dumps(out, indent=2) + "\n")
# Also drop a compact loss-only file for triage.
Path("/root/affine_data/h1_train_loss.json").write_text(json.dumps({
    "utc": out["utc"],
    "step": last,
    "trainer_state": out["trainer_state"],
    "first_loss": out["first_loss"],
    "last_loss": out["last_loss"],
    "n_loss_logs": out["n_loss_logs"],
    "loss_logs": loss_logs,
    "note": "stdout loss swallowed by tqdm+nohup; source=trainer_state.json after save_steps",
}, indent=2) + "\n")
# Stage newest trainer_state for SCP (overwrite).
if state_path and state_path.is_file():
    shutil.copy2(state_path, "/root/affine_data/h1_trainer_state.json")
print(json.dumps({k: out[k] for k in out if k != "loss_logs"}))
print("loss_logs", len(loss_logs), "first", out["first_loss"], "last", out["last_loss"])
PY' 2>/dev/null || true
}

while true; do
  now=$(date -u +%s)
  if (( now >= deadline )); then
    log "deadline reached (host harvest stop 06:55Z; deadman 07:00Z); stop"
    exit 0
  fi

  # Best-effort train + sim progress (overwrites); survives pod kill.
  _emit_train_progress
  if "${SSH[@]}" 'test -f /root/affine_data/h1_train_progress.json' 2>/dev/null; then
    "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1_train_progress.json \
      "$OUT/h1_train_progress.json" 2>/dev/null || true
  fi
  if "${SSH[@]}" 'test -f /root/affine_data/h1_train_loss.json' 2>/dev/null; then
    "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1_train_loss.json \
      "$OUT/h1_train_loss.json" 2>/dev/null || true
  fi
  if "${SSH[@]}" 'test -f /root/affine_data/h1_trainer_state.json' 2>/dev/null; then
    "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1_trainer_state.json \
      "$OUT/h1_trainer_state.json" 2>/dev/null || true
  fi
  if "${SSH[@]}" 'test -f /root/affine_data/h1_sim_progress.json' 2>/dev/null; then
    "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1_sim_progress.json \
      "$OUT/h1_sim_progress.json" 2>/dev/null || true
  fi
  if "${SSH[@]}" 'test -f /root/affine_data/h1_sim_progress_n40.json' 2>/dev/null; then
    "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1_sim_progress_n40.json \
      "$OUT/h1_sim_progress_n40.json" 2>/dev/null || true
  fi
  "${SCP[@]}" 'root@69.63.236.160:/root/h1/mid_*_salvage.json' \
    "$OUT/" 2>/dev/null || true

  # n40 probe is TTL insurance; harvest even if full 80 never finishes.
  if [[ ! -f "$OUT/h1_sim_result_n40.json" ]]; then
    if "${SSH[@]}" 'test -f /root/affine_data/h1_sim_result_n40.json' 2>/dev/null; then
      "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1_sim_result_n40.json \
        "$OUT/h1_sim_result_n40.json"
      log "got h1_sim_result_n40.json"
    fi
  fi

  if (( got_sim == 0 )); then
    if "${SSH[@]}" 'test -f /root/affine_data/h1_sim_result.json' 2>/dev/null; then
      "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1_sim_result.json \
        "$OUT/h1_sim_result.json"
      log "got h1_sim_result.json"
      got_sim=1
    elif [[ -f "$OUT/h1_sim_result_n40.json" ]] \
      && "${SSH[@]}" 'test -f /root/logs/h1_pipeline.done' 2>/dev/null; then
      # Pipeline exited after n40-only (TTL soft cutoff); treat as harvested sim.
      log "pipeline done with n40-only; counting as sim harvest"
      got_sim=1
    fi
  fi

  if (( got_salvage == 0 )); then
    if "${SSH[@]}" 'test -f /root/h1/adapter_salvage.json' 2>/dev/null; then
      "${SCP[@]}" root@69.63.236.160:/root/h1/adapter_salvage.json \
        "$OUT/adapter_salvage.json"
      log "got adapter_salvage.json"
      got_salvage=1
    fi
  fi

  if (( got_train == 0 )); then
    if "${SSH[@]}" 'test -f /root/h1/train/train_result.json' 2>/dev/null; then
      "${SCP[@]}" root@69.63.236.160:/root/h1/train/train_result.json \
        "$OUT/train_result.json"
      log "got train_result.json"
      got_train=1
    fi
  fi

  if (( got_sim == 1 && got_salvage == 1 && got_train == 1 )); then
    date -u +%Y-%m-%dT%H:%M:%SZ >"$OUT/host_harvest.done"
    log "all artifacts harvested; done"
    exit 0
  fi

  sleep 60
done
