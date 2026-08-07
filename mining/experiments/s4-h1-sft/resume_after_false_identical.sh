#!/usr/bin/env bash
# Resume H1 pipeline after false-positive first_1MiB identity refuse.
# Merged weights already on disk at /root/h1/merged and DIFF from kevin
# (tail windows + q/k/v/o_proj tensors). Skip re-merge; push→serve→n40→n80.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export HF_HOME=/root/hf
export PYTHONPATH=/root/mining_src/affine_pkg:/root/mining_src:${PYTHONPATH:-}

MERGED=/root/h1/merged
BASE=/root/hf/hub/models--kevin954--Affine-5dfqbbh8ev-sft/snapshots/6a5815fad8f4e34c983b1933c1fae5762fe25220
SIM_OUT=/root/affine_data/h1_sim_result.json
SIM_N40=/root/affine_data/h1_sim_result_n40.json
MARKER=/root/logs/h1_pipeline.done
MERGED_PUSH_META=/root/affine_data/h1_merged_salvage.json

log() { echo "[h1-resume] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

if [[ -f "$MARKER" ]]; then
  log "already done ($(cat "$MARKER")); exit"
  exit 0
fi
if [[ ! -f "$MERGED/model-00001-of-00002.safetensors" ]]; then
  log "ERROR: merged weights missing at $MERGED"
  exit 1
fi

log "rewrite merge_meta with multi-window identity probe (no re-merge)"
python3 - <<'PY'
import hashlib, json, os, time
from pathlib import Path

base = Path("/root/hf/hub/models--kevin954--Affine-5dfqbbh8ev-sft/snapshots/6a5815fad8f4e34c983b1933c1fae5762fe25220")
out = Path("/root/h1/merged")

def window_sha(path: Path, offset: int, nbytes: int = 1 << 20) -> str:
    h = hashlib.sha256()
    size = path.stat().st_size
    off = max(0, min(offset, max(0, size - nbytes)))
    with open(path, "rb") as f:
        f.seek(off)
        h.update(f.read(nbytes))
    return h.hexdigest()

shard_windows = {}
any_diff = False
# Numbered LM shards only (skip base extras like model-visual-extra.safetensors).
shard_paths = sorted(base.glob("model-*-of-*.safetensors"))
for shard_path in shard_paths:
    name = shard_path.name
    out_p = out / name
    if not out_p.is_file():
        any_diff = True
        shard_windows[name] = {"out_missing": True}
        continue
    size = shard_path.stat().st_size
    windows = {
        "head": (window_sha(shard_path, 0), window_sha(out_p, 0)),
        "mid": (window_sha(shard_path, size // 2), window_sha(out_p, size // 2)),
        "tail": (
            window_sha(shard_path, max(0, size - (1 << 20))),
            window_sha(out_p, max(0, out_p.stat().st_size - (1 << 20))),
        ),
    }
    eqs = {k: a == b for k, (a, b) in windows.items()}
    if not all(eqs.values()):
        any_diff = True
    shard_windows[name] = {
        "size_base": size,
        "size_out": out_p.stat().st_size,
        "equal": eqs,
        "sha": {k: {"base": a, "out": b} for k, (a, b) in windows.items()},
    }

# tensor probes (LoRA targets vs untouched)
from safetensors import safe_open
import torch

idx = json.loads((base / "model.safetensors.index.json").read_text())
wm = idx["weight_map"]

def tsha(path, key):
    with safe_open(str(path), framework="pt") as f:
        t = f.get_tensor(key)
        return hashlib.sha256(
            t.detach().cpu().contiguous().view(torch.uint8).numpy().tobytes()
        ).hexdigest()

tensor_cmp = {}
for key in [
    "model.language_model.embed_tokens.weight",
    "lm_head.weight",
    "model.language_model.layers.11.self_attn.q_proj.weight",
    "model.language_model.layers.11.self_attn.k_proj.weight",
    "model.language_model.layers.11.self_attn.v_proj.weight",
    "model.language_model.layers.11.self_attn.o_proj.weight",
    "model.language_model.layers.0.mlp.shared_expert.gate_proj.weight",
]:
    shard = wm[key]
    bh = tsha(base / shard, key)
    oh = tsha(out / shard, key)
    tensor_cmp[key] = {"shard": shard, "equal": bh == oh}

first = next(iter(sorted(base.glob("model-*.safetensors"))))
base_fp = window_sha(first, 0)
out_fp = window_sha(out / first.name, 0)
identical = (not any_diff) and (base_fp == out_fp)

meta = {
    "base": str(base),
    "adapter": "/root/h1/train/adapter",
    "out": str(out),
    "device_map": "auto (prior merge; resume no re-merge)",
    "base_first_shard": str(first),
    "out_first_shard": str(out / first.name),
    "base_first_1MiB_sha256": base_fp,
    "out_first_1MiB_sha256": out_fp,
    "first_1MiB_identical": base_fp == out_fp,
    "shard_windows": {
        k: {kk: vv for kk, vv in v.items() if kk != "sha"}
        for k, v in shard_windows.items()
    },
    "tensor_cmp": tensor_cmp,
    "weight_identical": identical,
    "false_positive_first_1MiB_gate": (base_fp == out_fp) and any_diff,
    "resume_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "pass47: first_1MiB gate false-positive; multi-window+tensor prove LoRA applied",
}
Path("/root/affine_data").mkdir(parents=True, exist_ok=True)
(out / "merge_meta.json").write_text(json.dumps(meta, indent=2) + "\n")
Path("/root/affine_data/h1_merge_meta.json").write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2))
if identical:
    raise SystemExit("still weight-identical after multi-window probe — abort")
print("[resume] merge OK (not weight-identical)", flush=True)
PY

MERGED_PUSH_PID=""
if [[ -n "${HF_TOKEN:-}" ]]; then
  if [[ -f /root/logs/h1_push_merged.pid ]] && kill -0 "$(cat /root/logs/h1_push_merged.pid)" 2>/dev/null; then
    MERGED_PUSH_PID=$(cat /root/logs/h1_push_merged.pid)
    log "merged push already running pid=$MERGED_PUSH_PID"
  else
    log "background HF push merged → unconst/Affine-5czsc2fc98-h1-merged"
    nohup python3 /root/mining_src/s4-h1-sft/push_merged.py \
      --merged "$MERGED" \
      --out-meta "$MERGED_PUSH_META" \
      >>/root/logs/h1_push_merged.nohup 2>&1 &
    MERGED_PUSH_PID=$!
    echo "$MERGED_PUSH_PID" >/root/logs/h1_push_merged.pid
    log "merged push pid=$MERGED_PUSH_PID"
  fi
else
  log "WARN: HF_TOKEN unset; skipping merged HF push"
fi

log "re-serve chall=$MERGED (king=kevin kept hot; teacher kept)"
RESTART_KING=0 MERGE="$MERGED" bash /root/mining_src/s4-h2-merge/restart_for_h2.sh
log "serve READY"

if [[ -d /root/merges/h2-kp65 ]]; then
  log "reclaim /root/merges/h2-kp65"
  rm -rf /root/merges/h2-kp65
fi

TTL_DEADLINE_EPOCH=$(date -u -d '2026-08-07T06:50:00Z' +%s 2>/dev/null || echo 0)

log "launch sim n=40 → $SIM_N40"
python /root/mining_src/s4-h2-merge/run_sim_duel.py \
  --chall-repo "$MERGED" \
  --out "$SIM_N40" \
  --hotkey local-h1-sim-n40 \
  --n-turns 40 \
  --progress-out /root/affine_data/h1_sim_progress_n40.json \
  --save-artifact \
  >>/root/logs/h1_sim.nohup 2>&1
log "SIM_N40_DONE → $SIM_N40"
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h1_sim_n40.done

now_epoch=$(date -u +%s)
if [[ "$TTL_DEADLINE_EPOCH" =~ ^[0-9]+$ ]] && (( TTL_DEADLINE_EPOCH > 0 )); then
  remain=$(( TTL_DEADLINE_EPOCH - now_epoch ))
else
  remain=99999
fi

wait_merged_push() {
  if [[ -z "${MERGED_PUSH_PID}" ]]; then
    return 0
  fi
  log "waiting for merged HF push pid=$MERGED_PUSH_PID (max 2700s)"
  for _ in $(seq 1 540); do
    kill -0 "$MERGED_PUSH_PID" 2>/dev/null || break
    sleep 5
  done
  if kill -0 "$MERGED_PUSH_PID" 2>/dev/null; then
    log "WARN: merged HF push still running after wait; leaving it"
  elif [[ -f "$MERGED_PUSH_META" ]]; then
    log "merged HF push DONE → $MERGED_PUSH_META"
  else
    log "WARN: merged HF push exited without meta at $MERGED_PUSH_META"
  fi
}

if (( remain < 3000 )); then
  log "WARN: only ${remain}s to soft TTL deadline; skipping full n=80"
  wait_merged_push
  {
    date -u +%Y-%m-%dT%H:%M:%SZ
    echo "n40_only remain_s=$remain resume_after_false_identical"
  } >"$MARKER"
  exit 0
fi

log "launch sim n=80 → $SIM_OUT (${remain}s to soft deadline)"
python /root/mining_src/s4-h2-merge/run_sim_duel.py \
  --chall-repo "$MERGED" \
  --out "$SIM_OUT" \
  --hotkey local-h1-sim \
  --n-turns 80 \
  --progress-out /root/affine_data/h1_sim_progress.json \
  --save-artifact \
  >>/root/logs/h1_sim.nohup 2>&1

date -u +%Y-%m-%dT%H:%M:%SZ >"$MARKER"
log "SIM_DONE → $SIM_OUT"
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h1_sim.done
wait_merged_push
log "RESUME_PIPELINE_DONE"
