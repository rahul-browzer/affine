#!/usr/bin/env bash
# From validator host: upload sim stack + arm prewarm + post-train pipe on mine-h5c-1.
# Read-only copies of affine/; never modifies the validator tree.
set -euo pipefail

ROOT=/home/const/subnet120
DST_HOST=${DST_HOST:-152.236.142.234}
DST_PORT=${DST_PORT:-40298}
KNOWN=/tmp/mine-h5c-1.known_hosts
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-h5c-stack.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h1-sft" \
         "$STAGE/s4-h5c-expand-refs" "$STAGE/data"

cp -a "$ROOT/affine/affine.toml" "$STAGE/affine_pkg/"
cp -a "$ROOT/affine/affine/." "$STAGE/affine_pkg/affine/"
cp -a "$ROOT/affine/evalsrv/." "$STAGE/affine_pkg/evalsrv/"
cp -a "$ROOT/mining/experiments/s3-duel-sim/"*.sh "$STAGE/s3-duel-sim/"
cp -a "$ROOT/mining/experiments/s3-duel-sim/"*.py "$STAGE/s3-duel-sim/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/s4-h2-merge/restart_for_h2.sh" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/run_sim_duel.py" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h1-sft/merge_lora.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1-sft/salvage_adapter.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1-sft/push_merged.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1-sft/triage_sim.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h5c-expand-refs/post_train_pipeline.sh" "$STAGE/s4-h5c-expand-refs/"
cp -a "$ROOT/mining/experiments/s4-h5c-expand-refs/prewarm_engines.sh" "$STAGE/s4-h5c-expand-refs/"
cp -a "$ROOT/mining/experiments/s4-h5c-expand-refs/mid_ckpt_salvage.sh" "$STAGE/s4-h5c-expand-refs/"
if [[ -f "$ROOT/mining/experiments/s1-replay-chal00224/chal-00224.json.gz" ]]; then
  cp -a "$ROOT/mining/experiments/s1-replay-chal00224/chal-00224.json.gz" "$STAGE/data/"
fi

TAR=/tmp/mine-h5c-simstack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/h5c'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-h5c-simstack.tar.gz"
"${SSH[@]}" 'set -e
  tar -C /root/mining_src -xzf /tmp/mine-h5c-simstack.tar.gz
  if [[ -f /root/mining_src/data/chal-00224.json.gz ]]; then
    mv -f /root/mining_src/data/chal-00224.json.gz /root/affine_data/
    rmdir /root/mining_src/data 2>/dev/null || true
  fi
  chmod +x /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/*.sh \
           /root/mining_src/s4-h5c-expand-refs/*.sh
  test -f /root/mining_src/affine_pkg/affine/score.py
  test -f /root/mining_src/s3-duel-sim/serve_three.sh
  test -f /root/mining_src/s4-h2-merge/run_sim_duel.py
  test -f /root/mining_src/s4-h1-sft/merge_lora.py
  test -x /root/mining_src/s4-h5c-expand-refs/post_train_pipeline.sh
  test -x /root/mining_src/s4-h5c-expand-refs/prewarm_engines.sh
  echo SIMSTACK_UPLOAD_OK
  ls -la /root/mining_src/'

# Create private HF salvage repos (host-side; token from mining/.env).
# shellcheck disable=SC1091
set -a
source "$ROOT/mining/.env"
set +a
export HF_TOKEN
python3 - <<'PY'
import os
from huggingface_hub import HfApi
api = HfApi(token=os.environ["HF_TOKEN"])
for repo in (
    "unconst/Affine-5czsc2fc98-h5c-lora",
    "unconst/Affine-5czsc2fc98-h5c-merged",
):
    try:
        api.create_repo(repo, private=True, exist_ok=True, repo_type="model")
        print("HF_OK", repo)
    except Exception as e:
        print("HF_ERR", repo, type(e).__name__, e)
PY

# Arm via pod-local script (inline pgrep of script paths self-matches ssh -c).
"${SSH[@]}" 'bash /root/mining_src/s4-h5c-expand-refs/arm_on_pod.sh'

rm -f "$TAR"
echo "[upload_and_arm] done"
