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
_emit_train_progress() {
  "${SSH[@]}" 'python3 - <<"PY"
from pathlib import Path
import json, re, time, urllib.request
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
out = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "step": last,
    "total": 110,
    "frac": (last / 110 if last is not None else None),
    "train_done": Path("/root/h1/train/train.done").exists(),
    "ckpt_dirs": ckpts,
    "pipeline_alive": Path("/root/logs/h1_pipeline.pid").exists(),
    "engines": engines,
}
Path("/root/affine_data").mkdir(parents=True, exist_ok=True)
Path("/root/affine_data/h1_train_progress.json").write_text(json.dumps(out, indent=2) + "\n")
print(json.dumps(out))
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
