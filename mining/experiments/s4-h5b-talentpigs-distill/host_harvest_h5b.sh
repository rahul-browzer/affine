#!/usr/bin/env bash
# Host-side poller for H5b n80 → triage → h5b_decision.json.
# Also scrapes train progress and waits on HF salvage PIDs after triage so
# early exit cannot leave a silent "done" while the only LoRA is mid-upload.
set -euo pipefail

SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o StrictHostKeyChecking=accept-new
     -o ConnectTimeout=15 -p 40301 root@69.63.236.160)
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o StrictHostKeyChecking=accept-new
     -P 40301)
OUT=/home/const/subnet120/mining/experiments/s4-h5b-talentpigs-distill/results
TRIAGE_PY=/home/const/subnet120/mining/experiments/s4-h1-sft/triage_sim.py
mkdir -p "$OUT" "$OUT/triage_in"
log() { echo "[h5b-harvest] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

HARVEST_STOP_UTC=${HARVEST_STOP_UTC:-2026-08-07T11:45:00Z}
deadline=$(date -u -d "$HARVEST_STOP_UTC" +%s 2>/dev/null || date -u -d '2026-08-07 11:45:00' +%s)
got_result=0
got_triage=0
got_progress=0
push_grace_logged=0

_h5b_push_still_running() {
  "${SSH[@]}" 'bash -s' <<'EOS' 2>/dev/null
set -e
for pidf in /root/logs/h5b_push_merged.pid /root/logs/h5b_push_adapter.pid; do
  if [[ -f "$pidf" ]]; then
    pid=$(cat "$pidf" 2>/dev/null || true)
    if [[ -n "${pid:-}" ]] && kill -0 "$pid" 2>/dev/null; then
      exit 0
    fi
  fi
done
if pgrep -af "push_merged.py|salvage_adapter.py" 2>/dev/null \
  | grep -qE "h5b|5czsc2fc98-h5b"; then
  exit 0
fi
# mid-ckpt watcher still alive and train not done → salvage in flight
if pgrep -f "s4-h5b-talentpigs-distill/mid_ckpt_salvage.sh" >/dev/null 2>&1 \
  && [[ ! -f /root/h5b/train/train.done ]]; then
  exit 0
fi
exit 1
EOS
}

_scrape_train_progress() {
  "${SSH[@]}" 'bash -s' <<'EOS' 2>/dev/null >"$OUT/h5b_train_progress.json" || true
python3 - <<'PY'
import json, re, pathlib, datetime
from pathlib import Path
logp = Path("/root/logs/h5b_train.nohup")
out = {
    "utc": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "experiment": "s4-h5b-talentpigs-distill",
    "train_done": Path("/root/h5b/train/train.done").is_file(),
    "adapter_present": Path("/root/h5b/train/adapter/adapter_config.json").is_file(),
    "ckpt_dirs": sorted(
        p.name for p in Path("/root/h5b/train/checkpoints").glob("checkpoint-*")
    ) if Path("/root/h5b/train/checkpoints").is_dir() else [],
    "pipe_waiting": False,
    "pipe_done": Path("/root/logs/h5b_pipeline.done").is_file(),
    "pipe_aborted": Path("/root/logs/h5b_pipeline.aborted").is_file(),
    "mid_salvaged": [],
}
seen = Path("/root/h5b/mid_ckpt_salvaged.txt")
if seen.is_file():
    out["mid_salvaged"] = [ln.strip() for ln in seen.read_text().splitlines() if ln.strip()]
# engines
engines = {}
for name, port in (("teacher", 8000), ("king", 8001), ("chall", 8002)):
    try:
        import urllib.request
        r = urllib.request.urlopen(f"http://127.0.0.1:{port}/health", timeout=2)
        engines[name] = r.status
    except Exception:
        engines[name] = 0
out["engines"] = engines
text = logp.read_text(errors="replace") if logp.is_file() else ""
bars = re.findall(r"\|\s*(\d+)/55\s*", text)
steps = re.findall(
    r'step=(\d+)\s+(\{[^}]+\})',
    text,
)
out["total"] = 55
if bars:
    out["step"] = int(bars[-1])
    out["frac"] = out["step"] / 55.0
else:
    out["step"] = None
    out["frac"] = None
losses = []
for s, j in steps:
    try:
        d = json.loads(j)
        losses.append({"step": int(s), "loss": d.get("loss"), "epoch": d.get("epoch")})
    except Exception:
        pass
out["n_loss_logs"] = len(losses)
if losses:
    out["first_loss"] = losses[0]["loss"]
    out["last_loss"] = losses[-1]["loss"]
    out["last_loss_step"] = losses[-1]["step"]
if Path("/root/logs/h5b_pipeline.stdout").is_file():
    pt = Path("/root/logs/h5b_pipeline.stdout").read_text(errors="replace")
    out["pipe_waiting"] = "waiting for" in pt and not out["pipe_done"]
print(json.dumps(out, indent=2))
PY
EOS
  # keep a short tail for humans
  "${SSH[@]}" 'tail -c 1200 /root/logs/h5b_train.nohup | tr "\r" "\n" | tail -8' \
    2>/dev/null >"$OUT/h5b_train_tail.txt" || true
}

log "polling mine-sim-1 for H5b n80 → $OUT (stop ${HARVEST_STOP_UTC})"

while true; do
  now=$(date -u +%s)
  if (( now >= deadline )); then
    log "deadline reached; stop (got_result=$got_result got_triage=$got_triage)"
    exit 0
  fi

  _scrape_train_progress

  if "${SSH[@]}" 'test -f /root/affine_data/h5b_sim_progress.json' 2>/dev/null; then
    "${SCP[@]}" root@69.63.236.160:/root/affine_data/h5b_sim_progress.json \
      "$OUT/h5b_sim_progress.json" 2>/dev/null || true
    if (( got_progress == 0 )); then
      got_progress=1
      log "progress file appeared"
    fi
  fi

  # Scrape any salvage metas that appeared.
  for f in h5b_adapter_salvage.json h5b_merged_salvage.json h5b_identity.json \
           h5b_merge_meta.json; do
    if "${SSH[@]}" "test -f /root/affine_data/$f" 2>/dev/null; then
      "${SCP[@]}" "root@69.63.236.160:/root/affine_data/$f" "$OUT/$f" \
        2>/dev/null || true
    fi
  done
  # mid-ckpt salvage metas (glob via ssh ls)
  while IFS= read -r remote; do
    [[ -n "$remote" ]] || continue
    base=$(basename "$remote")
    "${SCP[@]}" "root@69.63.236.160:$remote" "$OUT/$base" 2>/dev/null || true
  done < <("${SSH[@]}" 'ls /root/affine_data/h5b_mid_*_salvage.json 2>/dev/null' || true)

  # Pipeline abort (identity refuse / merge fail / no n80 budget / n80×3 fail).
  # Without this, harvest spins until HARVEST_STOP and the next pass cannot
  # pivot under the deadman.
  if (( got_triage == 0 )) \
    && "${SSH[@]}" 'test -f /root/logs/h5b_pipeline.aborted' 2>/dev/null; then
    "${SCP[@]}" root@69.63.236.160:/root/logs/h5b_pipeline.aborted \
      "$OUT/h5b_pipeline.aborted" 2>/dev/null || true
    abort_txt=$(cat "$OUT/h5b_pipeline.aborted" 2>/dev/null || echo aborted)
    # Prefer any partial sim result for forensics, but do not require it.
    if "${SSH[@]}" 'test -f /root/affine_data/h5b_sim_result.json' 2>/dev/null; then
      "${SCP[@]}" root@69.63.236.160:/root/affine_data/h5b_sim_result.json \
        "$OUT/h5b_sim_result.json" 2>/dev/null || true
    fi
    for f in h5b_identity.json h5b_merge_meta.json; do
      if "${SSH[@]}" "test -f /root/affine_data/$f" 2>/dev/null; then
        "${SCP[@]}" "root@69.63.236.160:/root/affine_data/$f" "$OUT/$f" \
          2>/dev/null || true
      fi
    done
    if "${SSH[@]}" 'test -f /root/logs/h5b_sim_retries.log' 2>/dev/null; then
      "${SCP[@]}" root@69.63.236.160:/root/logs/h5b_sim_retries.log \
        "$OUT/h5b_sim_retries.log" 2>/dev/null || true
    fi
    python3 - <<PY
import json
from datetime import datetime, timezone
from pathlib import Path
out = Path("$OUT")
abort = (out / "h5b_pipeline.aborted").read_text(errors="replace").strip()
dec = {
    "utc": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "experiment": "s4-h5b-talentpigs-distill",
    "submit": False,
    "primary": {
        "source": "pipeline_aborted",
        "action": "pipe_aborted",
        "margin": None,
        "reason": abort or "h5b_pipeline.aborted",
    },
    "abort_text": abort,
    "note": (
        "post-train pipeline aborted before a durable n80 verdict; "
        "do not submit; pivot or re-arm under deadman"
    ),
}
(out / "h5b_decision.json").write_text(json.dumps(dec, indent=2) + "\n")
print(json.dumps(dec, indent=2))
PY
    got_triage=1
    got_result=1
    log "pipeline ABORTED → h5b_decision.json ($abort_txt)"
    date -u +%Y-%m-%dT%H:%M:%SZ >"$OUT/host_harvest_h5b.done"
  fi

  # Only harvest a sim result after the pipe marks n80 durable.
  # Pass-83 n80 retries rm the result between attempts; harvesting on the
  # bare JSON alone can triage a doomed attempt mid-retry.
  if (( got_result == 0 )); then
    if "${SSH[@]}" 'test -f /root/logs/h5b_sim_n80.done -o -f /root/logs/h5b_pipeline.done' \
        2>/dev/null \
      && "${SSH[@]}" 'test -f /root/affine_data/h5b_sim_result.json' 2>/dev/null; then
      "${SCP[@]}" root@69.63.236.160:/root/affine_data/h5b_sim_result.json \
        "$OUT/h5b_sim_result.json"
      for f in h5b_sim_result_artifact.json h5b_identity.json h5b_merge_meta.json; do
        if "${SSH[@]}" "test -f /root/affine_data/$f" 2>/dev/null; then
          "${SCP[@]}" "root@69.63.236.160:/root/affine_data/$f" "$OUT/$f" \
            2>/dev/null || true
        fi
      done
      got_result=1
      log "got durable h5b_sim_result.json (n80/pipeline done marker present)"
      date -u +%Y-%m-%dT%H:%M:%SZ >"$OUT/h5b_sim_n80_harvested.stamp"
    fi
  fi

  if (( got_result == 1 && got_triage == 0 )); then
    rm -f "$OUT/triage_in/h1_sim_result.json"
    cp -f "$OUT/h5b_sim_result.json" "$OUT/triage_in/h1_sim_result.json"
    if python3 "$TRIAGE_PY" \
        --results-dir "$OUT/triage_in" \
        --out "$OUT/h5b_decision.json"; then
      got_triage=1
      action=$(python3 -c "import json;print(json.load(open('$OUT/h5b_decision.json'))['primary']['action'])" 2>/dev/null || echo '?')
      margin=$(python3 -c "import json;print(json.load(open('$OUT/h5b_decision.json'))['primary']['margin'])" 2>/dev/null || echo '?')
      log "triage → h5b_decision.json action=$action margin=$margin"
      date -u +%Y-%m-%dT%H:%M:%SZ >"$OUT/host_harvest_h5b.done"
    else
      log "triage failed; will retry"
    fi
  fi

  if (( got_triage == 1 )); then
    if _h5b_push_still_running; then
      if (( push_grace_logged == 0 )); then
        log "decision ready but H5b HF salvage still running; defer exit (deadman 12:00Z)"
        push_grace_logged=1
      fi
      sleep 60
      continue
    fi
    log "done (triage + HF salvage idle); exiting"
    exit 0
  fi

  sleep 45
done

