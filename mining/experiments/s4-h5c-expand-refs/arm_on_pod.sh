#!/usr/bin/env bash
# Run ON the pod. Starts mid-salvage + prewarm + post-train pipe if not live.
# Avoid embedding these script paths in an ssh -c string (pgrep self-match).
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export HF_TOKEN="${HF_TOKEN:-}"

SRC=/root/mining_src/s4-h5c-expand-refs
mkdir -p /root/logs /root/h5c /root/affine_data

alive() {
  local pat=$1
  # Match real workers only: exclude this arm script and ssh wrappers.
  pgrep -af "$pat" | grep -v arm_on_pod | grep -v 'bash -c' | grep -q .
}

if alive 'mid_ckpt_salvage\.sh'; then
  echo MID_ALREADY
else
  nohup bash "$SRC/mid_ckpt_salvage.sh" >/root/logs/h5c_mid_salvage.nohup 2>&1 &
  echo $! > /root/logs/h5c_mid_salvage.pid
  echo MID_PID=$(cat /root/logs/h5c_mid_salvage.pid)
fi

if [[ -f /root/logs/h5c_prewarm.done ]]; then
  echo PREWARM_DONE
elif alive 'prewarm_engines\.sh'; then
  echo PREWARM_ALREADY
else
  nohup bash "$SRC/prewarm_engines.sh" >/root/logs/h5c_prewarm.launch.nohup 2>&1 &
  echo $! > /root/logs/h5c_prewarm.pid
  echo PREWARM_PID=$(cat /root/logs/h5c_prewarm.pid)
fi

if alive 'post_train_pipeline\.sh'; then
  echo PIPE_ALREADY
else
  nohup bash "$SRC/post_train_pipeline.sh" >/root/logs/h5c_pipeline.launch.nohup 2>&1 &
  echo $! > /root/logs/h5c_pipeline.pid
  echo PIPE_PID=$(cat /root/logs/h5c_pipeline.pid)
fi

if pgrep -f 's4-h1v2-sft/train_lora\.py' >/dev/null 2>&1; then
  echo TRAIN_ALIVE pid=$(cat /root/logs/h5c_train.pid)
else
  echo TRAIN_MISSING
fi

echo "--- pid files ---"
cat /root/logs/h5c_mid_salvage.pid /root/logs/h5c_prewarm.pid /root/logs/h5c_pipeline.pid /root/logs/h5c_train.pid
echo "--- procs ---"
ps -p "$(cat /root/logs/h5c_mid_salvage.pid),$(cat /root/logs/h5c_prewarm.pid),$(cat /root/logs/h5c_pipeline.pid),$(cat /root/logs/h5c_train.pid)" \
  -o pid,etime,cmd 2>/dev/null || true
nvidia-smi --query-gpu=index,memory.used,utilization.gpu --format=csv,noheader
echo ARM_OK
