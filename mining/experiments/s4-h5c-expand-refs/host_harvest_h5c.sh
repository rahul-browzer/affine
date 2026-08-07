#!/usr/bin/env bash
# Host-side poller for H5c train→merge→n80 → triage → h5c_decision.json.
# Scrapes progress continuously; waits on HF salvage before exit.
set -euo pipefail

SSH=(ssh -i "$HOME/.ssh/id_ed25519"
     -o UserKnownHostsFile=/tmp/mine-h5c-1.known_hosts
     -o StrictHostKeyChecking=accept-new
     -o ConnectTimeout=15 -p 40298 root@152.236.142.234)
SCP=(scp -i "$HOME/.ssh/id_ed25519"
     -o UserKnownHostsFile=/tmp/mine-h5c-1.known_hosts
     -o StrictHostKeyChecking=accept-new
     -P 40298)
OUT=/home/const/subnet120/mining/experiments/s4-h5c-expand-refs/results
TRIAGE_PY=/home/const/subnet120/mining/experiments/s4-h1-sft/triage_sim.py
mkdir -p "$OUT" "$OUT/triage_in"
log() { echo "[h5c-harvest] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

HARVEST_STOP_UTC=${HARVEST_STOP_UTC:-2026-08-07T18:45:00Z}
deadline=$(date -u -d "$HARVEST_STOP_UTC" +%s 2>/dev/null || date -u -d '2026-08-07 18:45:00' +%s)
got_result=0
got_triage=0
got_progress=0
push_grace_logged=0

_h5c_push_still_running() {
  "${SSH[@]}" 'bash -s' <<'EOS' 2>/dev/null
set -e
for pidf in /root/logs/h5c_push_merged.pid /root/logs/h5c_push_adapter.pid; do
  if [[ -f "$pidf" ]]; then
    pid=$(cat "$pidf" 2>/dev/null || true)
    if [[ -n "${pid:-}" ]] && kill -0 "$pid" 2>/dev/null; then
      exit 0
    fi
  fi
done
if pgrep -af "push_merged.py|salvage_adapter.py" 2>/dev/null \
  | grep -qE "h5c|5czsc2fc98-h5c"; then
  exit 0
fi
if pgrep -f "s4-h5c-expand-refs/mid_ckpt_salvage.sh" >/dev/null 2>&1 \
  && [[ ! -f /root/h5c/train/train.done ]]; then
  exit 0
fi
exit 1
EOS
}

_scrape_train_progress() {
  "${SSH[@]}" 'bash -s' <<'EOS' 2>/dev/null >"$OUT/h5c_train_progress.json" || true
python3 - <<'PY'
import json, re, datetime
from pathlib import Path

def _is(p: str) -> bool:
    return Path(p).is_file()

logp = Path("/root/logs/h5c_train.nohup")
pipe_log = Path("/root/logs/h5c_pipeline.nohup")
train_done = _is("/root/h5c/train/train.done")
merge_done = _is("/root/logs/h5c_merge.done")
chall_serve_done = _is("/root/logs/h5c_chall_serve.done")
sim_n80_done = _is("/root/logs/h5c_sim_n80.done")
pipe_done = _is("/root/logs/h5c_pipeline.done")
pipe_aborted = _is("/root/logs/h5c_pipeline.aborted")
prewarm_done = _is("/root/logs/h5c_prewarm.done")

last_pipe = ""
if pipe_log.is_file():
    lines = [
        ln for ln in pipe_log.read_text(errors="replace").splitlines() if ln.strip()
    ]
    last_pipe = lines[-1] if lines else ""

if pipe_aborted:
    stage = "aborted"
elif pipe_done or sim_n80_done:
    stage = "n80_done"
elif chall_serve_done or "launch n80" in last_pipe or "n80 attempt" in last_pipe:
    stage = "n80"
elif "CHALL_SERVE_DONE" in last_pipe or "chall-only" in last_pipe:
    stage = "serve"
elif merge_done or "OK_NON_IDENTICAL" in last_pipe or "merge LoRA" in last_pipe:
    stage = "merge_identity"
elif train_done or "train.done present" in last_pipe or "GPU settle" in last_pipe:
    stage = "post_train"
elif "waiting for" in last_pipe:
    stage = "waiting_train"
else:
    stage = "unknown"

out = {
    "utc": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "experiment": "s4-h5c-expand-refs",
    "stage": stage,
    "train_done": train_done,
    "prewarm_done": prewarm_done,
    "adapter_present": _is("/root/h5c/train/adapter/adapter_config.json"),
    "ckpt_dirs": sorted(
        p.name for p in Path("/root/h5c/train/checkpoints").glob("checkpoint-*")
    ) if Path("/root/h5c/train/checkpoints").is_dir() else [],
    "merge_done": merge_done,
    "chall_serve_done": chall_serve_done,
    "sim_n80_done": sim_n80_done,
    "pipe_waiting": stage == "waiting_train",
    "pipe_done": pipe_done,
    "pipe_aborted": pipe_aborted,
    "last_pipe_line": last_pipe[-240:] if last_pipe else "",
    "mid_salvaged": [],
    "identical_to_king": None,
    "sim_progress": None,
}
seen = Path("/root/h5c/mid_ckpt_salvaged.txt")
if seen.is_file():
    out["mid_salvaged"] = [ln.strip() for ln in seen.read_text().splitlines() if ln.strip()]
ident = Path("/root/affine_data/h5c_identity.json")
if ident.is_file():
    try:
        out["identical_to_king"] = json.loads(ident.read_text()).get("identical_to_king")
    except Exception:
        pass
prog = Path("/root/affine_data/h5c_sim_progress.json")
if prog.is_file():
    try:
        out["sim_progress"] = json.loads(prog.read_text())
    except Exception:
        pass
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
bars = re.findall(r"\|\s*(\d+)/99\s*", text)
steps = re.findall(r'step=(\d+)\s+(\{[^}]+\})', text)
out["total"] = 99
if bars:
    out["step"] = int(bars[-1])
    out["frac"] = out["step"] / 99.0
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
print(json.dumps(out, indent=2))
PY
EOS
  "${SSH[@]}" 'tail -c 1200 /root/logs/h5c_train.nohup | tr "\r" "\n" | tail -8' \
    2>/dev/null >"$OUT/h5c_train_tail.txt" || true
  "${SSH[@]}" 'tail -c 800 /root/logs/h5c_prewarm.nohup | tr "\r" "\n" | tail -6' \
    2>/dev/null >"$OUT/h5c_prewarm_tail.txt" || true
}

log "polling mine-h5c-1 for H5c n80 → $OUT (stop ${HARVEST_STOP_UTC})"

while true; do
  now=$(date -u +%s)
  if (( now >= deadline )); then
    log "deadline reached; stop (got_result=$got_result got_triage=$got_triage)"
    exit 0
  fi

  _scrape_train_progress

  if "${SSH[@]}" 'test -f /root/affine_data/h5c_sim_progress.json' 2>/dev/null; then
    "${SCP[@]}" root@152.236.142.234:/root/affine_data/h5c_sim_progress.json \
      "$OUT/h5c_sim_progress.json" 2>/dev/null || true
    if (( got_progress == 0 )); then
      got_progress=1
      log "progress file appeared"
    fi
  fi

  for f in h5c_adapter_salvage.json h5c_merged_salvage.json h5c_identity.json \
           h5c_merge_meta.json; do
    if "${SSH[@]}" "test -f /root/affine_data/$f" 2>/dev/null; then
      "${SCP[@]}" "root@152.236.142.234:/root/affine_data/$f" "$OUT/$f" \
        2>/dev/null || true
    fi
  done
  while IFS= read -r remote; do
    [[ -n "$remote" ]] || continue
    base=$(basename "$remote")
    "${SCP[@]}" "root@152.236.142.234:$remote" "$OUT/$base" 2>/dev/null || true
  done < <("${SSH[@]}" 'ls /root/affine_data/h5c_mid_*_salvage.json 2>/dev/null' || true)

  if (( got_triage == 0 )) \
    && "${SSH[@]}" 'test -f /root/logs/h5c_pipeline.aborted' 2>/dev/null; then
    "${SCP[@]}" root@152.236.142.234:/root/logs/h5c_pipeline.aborted \
      "$OUT/h5c_pipeline.aborted" 2>/dev/null || true
    abort_txt=$(cat "$OUT/h5c_pipeline.aborted" 2>/dev/null || echo aborted)
    if "${SSH[@]}" 'test -f /root/affine_data/h5c_sim_result.json' 2>/dev/null; then
      "${SCP[@]}" root@152.236.142.234:/root/affine_data/h5c_sim_result.json \
        "$OUT/h5c_sim_result.json" 2>/dev/null || true
    fi
    for f in h5c_identity.json h5c_merge_meta.json; do
      if "${SSH[@]}" "test -f /root/affine_data/$f" 2>/dev/null; then
        "${SCP[@]}" "root@152.236.142.234:/root/affine_data/$f" "$OUT/$f" \
          2>/dev/null || true
      fi
    done
    if "${SSH[@]}" 'test -f /root/logs/h5c_sim_retries.log' 2>/dev/null; then
      "${SCP[@]}" root@152.236.142.234:/root/logs/h5c_sim_retries.log \
        "$OUT/h5c_sim_retries.log" 2>/dev/null || true
    fi
    python3 - <<PY
import json
from datetime import datetime, timezone
from pathlib import Path
out = Path("$OUT")
abort = (out / "h5c_pipeline.aborted").read_text(errors="replace").strip()
dec = {
    "utc": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "experiment": "s4-h5c-expand-refs",
    "submit": False,
    "primary": {
        "source": "pipeline_aborted",
        "action": "pipe_aborted",
        "margin": None,
        "reason": abort or "h5c_pipeline.aborted",
    },
    "abort_text": abort,
    "note": (
        "post-train pipeline aborted before a durable n80 verdict; "
        "do not submit; pivot or re-arm under deadman"
    ),
}
(out / "h5c_decision.json").write_text(json.dumps(dec, indent=2) + "\n")
print(json.dumps(dec, indent=2))
PY
    got_triage=1
    got_result=1
    log "pipeline ABORTED → h5c_decision.json ($abort_txt)"
    date -u +%Y-%m-%dT%H:%M:%SZ >"$OUT/host_harvest_h5c.done"
  fi

  if (( got_result == 0 )); then
    if "${SSH[@]}" 'test -f /root/logs/h5c_sim_n80.done -o -f /root/logs/h5c_pipeline.done' \
        2>/dev/null \
      && "${SSH[@]}" 'test -f /root/affine_data/h5c_sim_result.json' 2>/dev/null; then
      "${SCP[@]}" root@152.236.142.234:/root/affine_data/h5c_sim_result.json \
        "$OUT/h5c_sim_result.json"
      for f in h5c_sim_result_artifact.json h5c_identity.json h5c_merge_meta.json; do
        if "${SSH[@]}" "test -f /root/affine_data/$f" 2>/dev/null; then
          "${SCP[@]}" "root@152.236.142.234:/root/affine_data/$f" "$OUT/$f" \
            2>/dev/null || true
        fi
      done
      got_result=1
      log "got durable h5c_sim_result.json (n80/pipeline done marker present)"
      date -u +%Y-%m-%dT%H:%M:%SZ >"$OUT/h5c_sim_n80_harvested.stamp"
    fi
  fi

  if (( got_result == 1 && got_triage == 0 )); then
    rm -f "$OUT/triage_in/h1_sim_result.json"
    cp -f "$OUT/h5c_sim_result.json" "$OUT/triage_in/h1_sim_result.json"
    if python3 "$TRIAGE_PY" \
        --results-dir "$OUT/triage_in" \
        --out "$OUT/h5c_decision.json"; then
      got_triage=1
      action=$(python3 -c "import json;print(json.load(open('$OUT/h5c_decision.json'))['primary']['action'])" 2>/dev/null || echo '?')
      margin=$(python3 -c "import json;print(json.load(open('$OUT/h5c_decision.json'))['primary']['margin'])" 2>/dev/null || echo '?')
      log "triage → h5c_decision.json action=$action margin=$margin"
      date -u +%Y-%m-%dT%H:%M:%SZ >"$OUT/host_harvest_h5c.done"
    else
      log "triage failed; will retry"
    fi
  fi

  if (( got_triage == 1 )); then
    if _h5c_push_still_running; then
      if (( push_grace_logged == 0 )); then
        log "decision ready but H5c HF salvage still running; defer exit (deadman 19:00Z)"
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
