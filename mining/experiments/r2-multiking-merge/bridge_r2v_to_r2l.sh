#!/usr/bin/env bash
# After pure-sft3 local n80 (R2v) writes r2v_sft3_decision.json, unblock or
# retire Talent×sft3 (R2l) without waiting for board chal-00450 gzip:
#   hr ≥ 1.5 → Stage-5 prefer pure sft3; kill R2l premerge + SKIP (no blend)
#   0 < hr < 1.5 → write local-proxy chal00450_reason stamp so R2l CPU-merges now
#   hr ≤ 0 → KEEP board wait (R2q lesson: local− can disagree with board+)
# Never touches teacher/king/chall engines. No submit.
set -euo pipefail
LOG=/root/logs/bridge_r2v_to_r2l.log
DONE=/root/logs/bridge_r2v_to_r2l.done
PIDF=/root/logs/bridge_r2v_to_r2l.pid
DEC=${DEC:-/root/affine_data/r2v_sft3_decision.json}
REASON_JSON=${REASON_JSON:-/root/affine_data/chal00450_reason.json}
REASON_DONE=${REASON_DONE:-/root/logs/watch_chal00450_reason.done}
R2L_SKIP=${R2L_SKIP:-/root/logs/r2l_premerge.skip}
R2L_PREMERGE_PIDF=${R2L_PREMERGE_PIDF:-/root/logs/r2l_premerge.pid}
STAGE5=${STAGE5:-/root/affine_data/r2v_stage5_ready.json}
SFT3_REPO=${SFT3_REPO:-syntaxsorcerer1/Affine-5gbhwtw4zo-sft3}
SFT3_REV=${SFT3_REV:-381dbc8245e29bccbf39de78fdbc20acbfadec8d}
KING_REPO=${KING_REPO:-Tok331102/affine-5EqYW8McUc-af10}
KING_REV=${KING_REV:-eb8bf9a356a254f71faaa439e8abc3cfba572c53}
HEADROOM_BAR=${HEADROOM_BAR:-1.5}
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[bridge-r2v-r2l] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[bridge-r2v-r2l] already done: $(cat "$DONE")"
  exit 0
fi

echo "[bridge-r2v-r2l] waiting for $DEC"
for i in $(seq 1 2880); do
  if [[ -f "$DEC" ]]; then
    echo "[bridge-r2v-r2l] decision present at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(python3 -c "import json;from pathlib import Path;p=Path('/root/affine_data/r2v_sft3_reason_progress.json');
print(p.read_text().strip() if p.is_file() else 'no-progress')" 2>/dev/null || echo none)
    echo "[bridge-r2v-r2l] wait-dec iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "TIMEOUT $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 2
  fi
  sleep 10
done

# Board stamp already won the race — do not overwrite with local proxy.
if [[ -f "$REASON_JSON" && -f "$REASON_DONE" ]]; then
  echo "OK_BOARD_FIRST $(date -u +%Y-%m-%dT%H:%M:%SZ) $(head -1 "$REASON_DONE")" | tee "$DONE"
  exit 0
fi

export DEC REASON_JSON REASON_DONE R2L_SKIP R2L_PREMERGE_PIDF STAGE5 \
  SFT3_REPO SFT3_REV KING_REPO KING_REV HEADROOM_BAR
python3 - <<'PY'
import json, os, signal, time
from pathlib import Path

dec = json.loads(Path(os.environ["DEC"]).read_text())
hr = dec.get("headroom_vs_3se")
margin = dec.get("margin")
se = dec.get("se")
bar = float(os.environ["HEADROOM_BAR"])
utc = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
hr_f = float(hr) if hr is not None else None

def kill_r2l_premerge():
    pf = Path(os.environ["R2L_PREMERGE_PIDF"])
    if not pf.is_file():
        return None
    try:
        pid = int(pf.read_text().strip())
    except ValueError:
        return None
    try:
        os.kill(pid, 0)
    except OSError:
        return None
    os.kill(pid, signal.SIGTERM)
    time.sleep(1)
    try:
        os.kill(pid, 0)
        os.kill(pid, signal.SIGKILL)
    except OSError:
        pass
    return pid

if hr_f is not None and hr_f >= bar:
    Path(os.environ["STAGE5"]).write_text(json.dumps({
        "utc": utc,
        "source": "r2v_local_n80",
        "hyp": "R2v",
        "headroom_vs_3se": hr_f,
        "margin": margin,
        "se": se,
        "threshold_3se": dec.get("threshold_3se"),
        "challenger_repo": os.environ["SFT3_REPO"],
        "challenger_revision": os.environ["SFT3_REV"],
        "king_repo": os.environ["KING_REPO"],
        "king_revision": os.environ["KING_REV"],
        "action": "STAGE5_SUBMIT_PURE_SFT3",
        "note": "local n80 cleared 1.5× bar; skip Talent×sft3 blend",
        "sim_decision": str(Path(os.environ["DEC"])),
    }, indent=2) + "\n")
    killed = kill_r2l_premerge()
    skip = Path(os.environ["R2L_SKIP"])
    skip.write_text(
        f"SKIP {utc} R2v hr={hr_f:.4f}≥{bar} — prefer pure sft3 Stage-5 "
        f"(killed_premerge={killed})\n"
    )
    Path("/root/logs/bridge_r2v_to_r2l.done").write_text(
        f"OK_STAGE5 {utc} hr={hr_f} margin={margin} killed={killed}\n"
    )
    print(f"[bridge-r2v-r2l] STAGE5 hr={hr_f} skip R2l killed={killed}", flush=True)
    raise SystemExit(0)

if hr_f is not None and hr_f > 0.0:
    three_se = dec.get("threshold_3se")
    if three_se is None and se is not None:
        three_se = 3.0 * float(se)
    proxy = {
        "challenge_id": "chal-00450",
        "king_repo": os.environ["KING_REPO"],
        "king_revision": os.environ["KING_REV"],
        "challenger_repo": os.environ["SFT3_REPO"],
        "challenger_revision": os.environ["SFT3_REV"],
        "published_margin": None,
        "published_z": dec.get("z"),
        "published_formula": "Reason = lpC(y_C|z_A) − lpC(y_C|∅)",
        "challenger_wins": bool(dec.get("challenger_wins")),
        "reason_margin": margin,
        "reason_se": se,
        "reason_z": dec.get("z"),
        "three_se": three_se,
        "headroom_vs_3se": hr_f,
        "n_paired": dec.get("n_paired_turns"),
        "king_match": True,
        "scored_at": utc,
        "source_url": "local://r2v_sft3_decision.json",
        "signal": "POS_BELOW_3SE_LOCAL_PROXY",
        "proxy_note": (
            "Local pure-sft3 n80 Reason+ used to unblock Talent×sft3 premerge "
            "before board gzip; board watcher may overwrite later."
        ),
    }
    Path(os.environ["REASON_JSON"]).write_text(json.dumps(proxy, indent=2) + "\n")
    Path(os.environ["REASON_DONE"]).write_text(
        f"OK {utc} hr={hr_f} margin={margin} n={dec.get('n_paired_turns')} "
        f"repo={os.environ['SFT3_REPO']} source=r2v_local_proxy\n"
    )
    Path("/root/logs/bridge_r2v_to_r2l.done").write_text(
        f"OK_PROXY_REASON_PLUS {utc} hr={hr_f} margin={margin}\n"
    )
    print(f"[bridge-r2v-r2l] wrote local-proxy Reason+ hr={hr_f}", flush=True)
    raise SystemExit(0)

# hr≤0 or missing: keep board wait (do not SKIP R2l).
Path("/root/logs/bridge_r2v_to_r2l.done").write_text(
    f"OK_KEEP_BOARD_WAIT {utc} hr={hr_f} margin={margin} "
    f"(local− does not retire R2l; R2q precedent)\n"
)
print(f"[bridge-r2v-r2l] KEEP_BOARD_WAIT hr={hr_f}", flush=True)
PY

echo "[bridge-r2v-r2l] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ) $(cat "$DONE")"
