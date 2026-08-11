# Sourced by R2i…R2p merge_reload before killing chall:8002.
# Pure-saysth (R2q), saysth×awesome (R2s), saysth×Talent (R2t), or
# saysth×kevin (R2u) may hold the GPU while queue Reason waiters are armed.
R2Q_DEC=${R2Q_DEC:-/root/affine_data/r2q_saysth_decision.json}
R2Q_DONE=${R2Q_DONE:-/root/logs/r2q_saysth_reload.done}
R2Q_PIDF=${R2Q_PIDF:-/root/logs/r2q_saysth_reload.pid}
R2S_DEC=${R2S_DEC:-/root/affine_data/r2s_alpha_decision.json}
R2S_DONE=${R2S_DONE:-/root/logs/r2s_merge_reload.done}
R2S_PIDF=${R2S_PIDF:-/root/logs/r2s_merge_reload.pid}
R2T_DEC=${R2T_DEC:-/root/affine_data/r2t_alpha_decision.json}
R2T_DONE=${R2T_DONE:-/root/logs/r2t_merge_reload.done}
R2T_PIDF=${R2T_PIDF:-/root/logs/r2t_merge_reload.pid}
R2U_DEC=${R2U_DEC:-/root/affine_data/r2u_alpha_decision.json}
R2U_DONE=${R2U_DONE:-/root/logs/r2u_merge_reload.done}
R2U_PIDF=${R2U_PIDF:-/root/logs/r2u_merge_reload.pid}
_TAG=${_WAIT_R2Q_TAG:-merge}
if [[ -f "$R2Q_DEC" ]] && declare -F headroom_ok >/dev/null && headroom_ok "$R2Q_DEC"; then
  echo "SKIP_${_TAG}_R2Q_CLEARS file=$R2Q_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi
if [[ -f "$R2S_DEC" ]] && declare -F headroom_ok >/dev/null && headroom_ok "$R2S_DEC"; then
  echo "SKIP_${_TAG}_R2S_CLEARS file=$R2S_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi
if [[ -f "$R2T_DEC" ]] && declare -F headroom_ok >/dev/null && headroom_ok "$R2T_DEC"; then
  echo "SKIP_${_TAG}_R2T_CLEARS file=$R2T_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi
if [[ -f "$R2U_DEC" ]] && declare -F headroom_ok >/dev/null && headroom_ok "$R2U_DEC"; then
  echo "SKIP_${_TAG}_R2U_CLEARS file=$R2U_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi
for _i in $(seq 1 2880); do
  if [[ -f "$R2Q_DONE" || -f "$R2Q_DEC" ]]; then
    echo "[${_TAG}] R2q terminal; chall lane free at iter=$_i"
    break
  fi
  if [[ -f "$R2Q_PIDF" ]]; then
    _ppid=$(cat "$R2Q_PIDF" 2>/dev/null || true)
    if [[ -n "${_ppid:-}" ]] && kill -0 "$_ppid" 2>/dev/null; then
      if (( _i % 12 == 0 )); then
        echo "[${_TAG}] wait-r2q iter=$_i $(date -u +%Y-%m-%dT%H:%M:%SZ) pid=$_ppid"
      fi
      sleep 10
      continue
    fi
  fi
  echo "[${_TAG}] R2q not holding lane at iter=$_i"
  break
done
for _i in $(seq 1 2880); do
  if [[ -f "$R2S_DONE" || -f "$R2S_DEC" ]]; then
    echo "[${_TAG}] R2s terminal; chall lane free at iter=$_i"
    break
  fi
  if [[ -f "$R2S_PIDF" ]]; then
    _ppid=$(cat "$R2S_PIDF" 2>/dev/null || true)
    if [[ -n "${_ppid:-}" ]] && kill -0 "$_ppid" 2>/dev/null; then
      if (( _i % 12 == 0 )); then
        echo "[${_TAG}] wait-r2s iter=$_i $(date -u +%Y-%m-%dT%H:%M:%SZ) pid=$_ppid"
      fi
      sleep 10
      continue
    fi
  fi
  echo "[${_TAG}] R2s not holding lane at iter=$_i"
  break
done
for _i in $(seq 1 2880); do
  if [[ -f "$R2T_DONE" || -f "$R2T_DEC" ]]; then
    echo "[${_TAG}] R2t terminal; chall lane free at iter=$_i"
    break
  fi
  if [[ -f "$R2T_PIDF" ]]; then
    _ppid=$(cat "$R2T_PIDF" 2>/dev/null || true)
    if [[ -n "${_ppid:-}" ]] && kill -0 "$_ppid" 2>/dev/null; then
      if (( _i % 12 == 0 )); then
        echo "[${_TAG}] wait-r2t iter=$_i $(date -u +%Y-%m-%dT%H:%M:%SZ) pid=$_ppid"
      fi
      sleep 10
      continue
    fi
  fi
  echo "[${_TAG}] R2t not holding lane at iter=$_i"
  break
done
for _i in $(seq 1 2880); do
  if [[ -f "$R2U_DONE" || -f "$R2U_DEC" ]]; then
    echo "[${_TAG}] R2u terminal; chall lane free at iter=$_i"
    break
  fi
  if [[ -f "$R2U_PIDF" ]]; then
    _ppid=$(cat "$R2U_PIDF" 2>/dev/null || true)
    if [[ -n "${_ppid:-}" ]] && kill -0 "$_ppid" 2>/dev/null; then
      if (( _i % 12 == 0 )); then
        echo "[${_TAG}] wait-r2u iter=$_i $(date -u +%Y-%m-%dT%H:%M:%SZ) pid=$_ppid"
      fi
      sleep 10
      continue
    fi
  fi
  echo "[${_TAG}] R2u not holding lane at iter=$_i"
  break
done
unset _i _ppid _TAG
