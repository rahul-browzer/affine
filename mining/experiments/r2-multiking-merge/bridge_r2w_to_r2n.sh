#!/usr/bin/env bash
# After pure-asdf local n80 (R2w) writes r2w_asdf_decision.json, unblock or
# retire Talent×asdf (R2n) without waiting for board chal-00451 gzip:
#   hr ≥ 1.5 → Stage-5 prefer pure asdf; kill R2n premerge + SKIP (no blend)
#   0 < hr < 1.5 → write local-proxy chal00451_reason stamp so R2n CPU-merges now
#   hr ≤ 0 → KEEP board wait (R2q lesson: local− can disagree with board+)
# Never touches teacher/king/chall engines. No submit.
set -euo pipefail
LOG=/root/logs/bridge_r2w_to_r2n.log
DONE=/root/logs/bridge_r2w_to_r2n.done
PIDF=/root/logs/bridge_r2w_to_r2n.pid
DEC=${DEC:-/root/affine_data/r2w_asdf_decision.json}
REASON_JSON=${REASON_JSON:-/root/affine_data/chal00451_reason.json}
REASON_DONE=${REASON_DONE:-/root/logs/watch_chal00451_reason.done}
R2N_SKIP=${R2N_SKIP:-/root/logs/r2n_premerge.skip}
R2N_PREMERGE_PIDF=${R2N_PREMERGE_PIDF:-/root/logs/r2n_premerge.pid}
STAGE5=${STAGE5:-/root/affine_data/r2w_stage5_ready.json}
ASDF_REPO=${ASDF_REPO:-adsbasd31badsf/affine-5ec3jw68ha-asdf}
ASDF_REV=${ASDF_REV:-c23098154fd717e64f577cd863f0e1ba8e96ee84}
KING_REPO=${KING_REPO:-Tok331102/affine-5EqYW8McUc-af10}
KING_REV=${KING_REV:-eb8bf9a356a254f71faaa439e8abc3cfba572c53}
HEADROOM_BAR=${HEADROOM_BAR:-1.5}
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[bridge-r2w-r2n] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[bridge-r2w-r2n] already done: $(cat "$DONE")"
  exit 0
fi

echo "[bridge-r2w-r2n] waiting for $DEC"
for i in $(seq 1 2880); do
  if [[ -f "$DEC" ]]; then
    echo "[bridge-r2w-r2n] decision present at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(python3 -c "import json;from pathlib import Path;p=Path('/root/affine_data/r2w_asdf_reason_progress.json');
print(p.read_text().strip() if p.is_file() else 'no-progress')" 2>/dev/null || echo none)
    echo "[bridge-r2w-r2n] wait-dec iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "TIMEOUT $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 2
  fi
  sleep 10
done

if [[ -f "$REASON_JSON" && -f "$REASON_DONE" ]]; then
  echo "OK_BOARD_FIRST $(date -u +%Y-%m-%dT%H:%M:%SZ) $(head -1 "$REASON_DONE")" | tee "$DONE"
  exit 0
fi

export DEC REASON_JSON REASON_DONE R2N_SKIP R2N_PREMERGE_PIDF STAGE5 \
  ASDF_REPO ASDF_REV KING_REPO KING_REV HEADROOM_BAR
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

def kill_r2n_premerge():
    pf = Path(os.environ["R2N_PREMERGE_PIDF"])
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
        "source": "r2w_local_n80",
        "hyp": "R2w",
        "headroom_vs_3se": hr_f,
        "margin": margin,
        "se": se,
        "threshold_3se": dec.get("threshold_3se"),
        "challenger_repo": os.environ["ASDF_REPO"],
        "challenger_revision": os.environ["ASDF_REV"],
        "king_repo": os.environ["KING_REPO"],
        "king_revision": os.environ["KING_REV"],
        "action": "STAGE5_SUBMIT_PURE_ASDF",
        "note": "local n80 cleared 1.5× bar; skip Talent×asdf blend",
        "sim_decision": str(Path(os.environ["DEC"])),
    }, indent=2) + "\n")
    killed = kill_r2n_premerge()
    skip = Path(os.environ["R2N_SKIP"])
    skip.write_text(
        f"SKIP {utc} R2w hr={hr_f:.4f}≥{bar} — prefer pure asdf Stage-5 "
        f"(killed_premerge={killed})\n"
    )
    Path("/root/logs/bridge_r2w_to_r2n.done").write_text(
        f"OK_STAGE5 {utc} hr={hr_f} margin={margin} killed={killed}\n"
    )
    print(f"[bridge-r2w-r2n] STAGE5 hr={hr_f} skip R2n killed={killed}", flush=True)
    raise SystemExit(0)

if hr_f is not None and hr_f > 0.0:
    three_se = dec.get("threshold_3se")
    if three_se is None and se is not None:
        three_se = 3.0 * float(se)
    proxy = {
        "challenge_id": "chal-00451",
        "king_repo": os.environ["KING_REPO"],
        "king_revision": os.environ["KING_REV"],
        "challenger_repo": os.environ["ASDF_REPO"],
        "challenger_revision": os.environ["ASDF_REV"],
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
        "source_url": "local://r2w_asdf_decision.json",
        "signal": "POS_BELOW_3SE_LOCAL_PROXY",
        "proxy_note": (
            "Local pure-asdf n80 Reason+ used to unblock Talent×asdf premerge "
            "before board gzip; board watcher may overwrite later."
        ),
    }
    Path(os.environ["REASON_JSON"]).write_text(json.dumps(proxy, indent=2) + "\n")
    Path(os.environ["REASON_DONE"]).write_text(
        f"OK {utc} hr={hr_f} margin={margin} n={dec.get('n_paired_turns')} "
        f"repo={os.environ['ASDF_REPO']} source=r2w_local_proxy\n"
    )
    Path("/root/logs/bridge_r2w_to_r2n.done").write_text(
        f"OK_PROXY_REASON_PLUS {utc} hr={hr_f} margin={margin}\n"
    )
    print(f"[bridge-r2w-r2n] wrote local-proxy Reason+ hr={hr_f}", flush=True)
    raise SystemExit(0)

Path("/root/logs/bridge_r2w_to_r2n.done").write_text(
    f"OK_KEEP_BOARD_WAIT {utc} hr={hr_f} margin={margin} "
    f"(local− does not retire R2n; R2q precedent)\n"
)
print(f"[bridge-r2w-r2n] KEEP_BOARD_WAIT hr={hr_f}", flush=True)
PY

echo "[bridge-r2w-r2n] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ) $(cat "$DONE")"
