#!/usr/bin/env bash
# When R2ah local n80 stamps r2ah_awesome_v9_decision.json with headroom ≥ 1.5×(3·SE),
# upload pure awesome-v9 chall dir to unconst/Affine-5czsc2fc98-r2ah-awesome-v9 (public).
# Does NOT register/submit. Never touches teacher/king/chall engines.
set -euo pipefail
LOG=/root/logs/watch_r2ah_stage5_push.log
DONE=/root/logs/watch_r2ah_stage5_push.done
PIDF=/root/logs/watch_r2ah_stage5_push.pid
DEC=${DEC:-/root/affine_data/r2ah_awesome_v9_decision.json}
STAGE5=${STAGE5:-/root/affine_data/r2ah_stage5_ready.json}
CHALL=${CHALL:-/root/r2_out/awesome_v9_chall}
REPO=${REPO:-unconst/Affine-5czsc2fc98-r2ah-awesome-v9}
OUT_META=${OUT_META:-/root/affine_data/r2ah_stage5_hf_push.json}
PURGE_META=${PURGE_META:-/root/affine_data/r2ah_stage5_hf_purge.json}
HEADROOM_BAR=${HEADROOM_BAR:-1.5}
KEEP_REPOS=${KEEP_REPOS:-unconst/Affine-5czsc2fc98-r1lora,unconst/Affine-5czsc2fc98-r2v-sft3,unconst/Affine-5czsc2fc98-r2ah-awesome-v9}
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2ah-stage5-push] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" && -f "$OUT_META" ]]; then
  echo "[r2ah-stage5-push] already done: $(cat "$DONE")"
  exit 0
fi

echo "[r2ah-stage5-push] waiting for $DEC with headroom≥$HEADROOM_BAR"
for i in $(seq 1 2880); do
  if [[ -f "$DEC" ]]; then
    hr=$(python3 - <<PY
import json
from pathlib import Path
d=json.loads(Path("$DEC").read_text())
h=d.get("headroom_vs_3se")
print("" if h is None else h)
PY
)
    if [[ -n "${hr}" ]]; then
      ok=$(python3 -c "print(1 if float('$hr')>=float('$HEADROOM_BAR') else 0)")
      if [[ "$ok" == "1" ]]; then
        python3 - <<PY
import json, time
from pathlib import Path
d=json.loads(Path("$DEC").read_text())
Path("$STAGE5").write_text(json.dumps({
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hyp": "R2ah",
    "source_decision": "$DEC",
    "chall": "$CHALL",
    "repo": "$REPO",
    "headroom_vs_3se": d.get("headroom_vs_3se"),
    "margin": d.get("margin"),
    "se": d.get("se"),
    "z": d.get("z"),
    "threshold_3se": d.get("threshold_3se"),
    "n_paired_turns": d.get("n_paired_turns"),
    "decision": d.get("decision"),
}, indent=2) + "\n")
PY
        echo "[r2ah-stage5-push] STAGE5 stamped hr=$hr at iter=$i"
        break
      fi
      echo "SKIP_BELOW_BAR hr=$hr $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
      exit 0
    fi
  fi
  if (( i % 12 == 0 )); then
    crumb=$(python3 -c "from pathlib import Path;p=Path('/root/affine_data/r2ah_awesome_v9_reason_progress.json');
print(p.read_text().strip() if p.is_file() else 'no-progress')" 2>/dev/null || echo none)
    echo "[r2ah-stage5-push] wait iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "TIMEOUT $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 2
  fi
  sleep 10
done

set -a
# shellcheck disable=SC1091
source /root/mine.env
set +a
# shellcheck disable=SC1091
source /root/venv/bin/activate
export HF_HOME=${HF_HOME:-/root/hf}

if [[ -f /root/mining_src/r2-multiking-merge/stage5_hf_push.py ]]; then
  python /root/mining_src/r2-multiking-merge/stage5_hf_push.py \
    --chall "$CHALL" --repo "$REPO" --out-meta "$OUT_META" \
    --purge-meta "$PURGE_META" --keep-repos "$KEEP_REPOS"
else
  python - <<PY
import json, os, time
from pathlib import Path
from huggingface_hub import HfApi
api = HfApi(token=os.environ.get("HF_TOKEN"))
repo = "$REPO"
chall = Path("$CHALL")
api.create_repo(repo_id=repo, private=False, exist_ok=True, repo_type="model")
info = api.upload_folder(folder_path=str(chall), repo_id=repo, repo_type="model")
Path("$OUT_META").write_text(json.dumps({
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "repo": repo,
    "chall": str(chall),
    "commit": getattr(info, "commit_url", str(info)),
}, indent=2) + "\n")
print("uploaded", repo)
PY
fi
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO" | tee "$DONE"
