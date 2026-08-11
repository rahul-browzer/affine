# Sourced by R2i…R2p merge_reload before killing chall:8002.
# Pure-saysth (R2q), saysth×awesome (R2s), saysth×Talent (R2t),
# saysth×kevin (R2u), pure-sft3 (R2v), or pure-asdf (R2w) may hold the GPU
# while queue Reason waiters are armed.
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
R2V_DEC=${R2V_DEC:-/root/affine_data/r2v_sft3_decision.json}
R2V_DONE=${R2V_DONE:-/root/logs/r2v_sft3_reload.done}
R2V_PIDF=${R2V_PIDF:-/root/logs/r2v_sft3_reload.pid}
R2W_DEC=${R2W_DEC:-/root/affine_data/r2w_asdf_decision.json}
R2W_DONE=${R2W_DONE:-/root/logs/r2w_asdf_reload.done}
R2W_PIDF=${R2W_PIDF:-/root/logs/r2w_asdf_reload.pid}
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
if [[ -f "$R2V_DEC" ]] && declare -F headroom_ok >/dev/null && headroom_ok "$R2V_DEC"; then
  echo "SKIP_${_TAG}_R2V_CLEARS file=$R2V_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi
if [[ -f "$R2W_DEC" ]] && declare -F headroom_ok >/dev/null && headroom_ok "$R2W_DEC"; then
  echo "SKIP_${_TAG}_R2W_CLEARS file=$R2W_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
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
for _i in $(seq 1 2880); do
  if [[ -f "$R2V_DONE" || -f "$R2V_DEC" ]]; then
    echo "[${_TAG}] R2v terminal; chall lane free at iter=$_i"
    break
  fi
  if [[ -f "$R2V_PIDF" ]]; then
    _ppid=$(cat "$R2V_PIDF" 2>/dev/null || true)
    if [[ -n "${_ppid:-}" ]] && kill -0 "$_ppid" 2>/dev/null; then
      if (( _i % 12 == 0 )); then
        echo "[${_TAG}] wait-r2v iter=$_i $(date -u +%Y-%m-%dT%H:%M:%SZ) pid=$_ppid"
      fi
      sleep 10
      continue
    fi
  fi
  echo "[${_TAG}] R2v not holding lane at iter=$_i"
  break
done
# R2w may be alive while still yielding to R2l (wait-claimant). Only block
# siblings once R2w has stamped that it owns chall (see launch_r2w).
R2W_HOLDING=${R2W_HOLDING:-/root/logs/r2w_asdf_holding.stamp}
for _i in $(seq 1 2880); do
  if [[ -f "$R2W_DONE" || -f "$R2W_DEC" ]]; then
    echo "[${_TAG}] R2w terminal; chall lane free at iter=$_i"
    break
  fi
  if [[ -f "$R2W_HOLDING" ]] && [[ -f "$R2W_PIDF" ]]; then
    _ppid=$(cat "$R2W_PIDF" 2>/dev/null || true)
    if [[ -n "${_ppid:-}" ]] && kill -0 "$_ppid" 2>/dev/null; then
      if (( _i % 12 == 0 )); then
        echo "[${_TAG}] wait-r2w iter=$_i $(date -u +%Y-%m-%dT%H:%M:%SZ) pid=$_ppid holding"
      fi
      sleep 10
      continue
    fi
  fi
  echo "[${_TAG}] R2w not holding lane at iter=$_i"
  break
done
# R2o Talent×zeus: only block siblings once holding stamp is set (post lane-wait).
R2O_DEC=${R2O_DEC:-/root/affine_data/r2o_alpha_decision.json}
R2O_DONE=${R2O_DONE:-/root/logs/r2o_merge_reload.done}
R2O_PIDF=${R2O_PIDF:-/root/logs/r2o_merge_reload.pid}
R2O_HOLDING=${R2O_HOLDING:-/root/logs/r2o_talent_zeus_holding.stamp}
if [[ -f "$R2O_DEC" ]] && declare -F headroom_ok >/dev/null && headroom_ok "$R2O_DEC"; then
  echo "SKIP_${_TAG}_R2O_CLEARS file=$R2O_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi
for _i in $(seq 1 2880); do
  if [[ -f "$R2O_DONE" || -f "$R2O_DEC" ]]; then
    echo "[${_TAG}] R2o terminal; chall lane free at iter=$_i"
    break
  fi
  if [[ -f "$R2O_HOLDING" ]] && [[ -f "$R2O_PIDF" ]]; then
    _ppid=$(cat "$R2O_PIDF" 2>/dev/null || true)
    if [[ -n "${_ppid:-}" ]] && kill -0 "$_ppid" 2>/dev/null; then
      if (( _i % 12 == 0 )); then
        echo "[${_TAG}] wait-r2o iter=$_i $(date -u +%Y-%m-%dT%H:%M:%SZ) pid=$_ppid holding"
      fi
      sleep 10
      continue
    fi
  fi
  echo "[${_TAG}] R2o not holding lane at iter=$_i"
  break
done

# R2aa Talent×sbs: only block siblings once holding stamp is set.
R2AA_DEC=${R2AA_DEC:-/root/affine_data/r2aa_alpha_decision.json}
R2AA_DONE=${R2AA_DONE:-/root/logs/r2aa_merge_reload.done}
R2AA_PIDF=${R2AA_PIDF:-/root/logs/r2aa_merge_reload.pid}
R2AA_HOLDING=${R2AA_HOLDING:-/root/logs/r2aa_talent_sbs_holding.stamp}
if [[ -f "$R2AA_DEC" ]] && declare -F headroom_ok >/dev/null && headroom_ok "$R2AA_DEC"; then
  echo "SKIP_${_TAG}_R2AA_CLEARS file=$R2AA_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi
for _i in $(seq 1 2880); do
  if [[ -f "$R2AA_DONE" || -f "$R2AA_DEC" ]]; then
    echo "[${_TAG}] R2aa terminal; chall lane free at iter=$_i"
    break
  fi
  if [[ -f "$R2AA_HOLDING" ]] && [[ -f "$R2AA_PIDF" ]]; then
    _ppid=$(cat "$R2AA_PIDF" 2>/dev/null || true)
    if [[ -n "${_ppid:-}" ]] && kill -0 "$_ppid" 2>/dev/null; then
      if (( _i % 12 == 0 )); then
        echo "[${_TAG}] wait-r2aa iter=$_i $(date -u +%Y-%m-%dT%H:%M:%SZ) pid=$_ppid holding"
      fi
      sleep 10
      continue
    fi
  fi
  echo "[${_TAG}] R2aa not holding lane at iter=$_i"
  break
done
# R2ab Talent×sky
R2AB_DEC=${R2AB_DEC:-/root/affine_data/r2ab_alpha_decision.json}
R2AB_DONE=${R2AB_DONE:-/root/logs/r2ab_merge_reload.done}
R2AB_PIDF=${R2AB_PIDF:-/root/logs/r2ab_merge_reload.pid}
R2AB_HOLDING=${R2AB_HOLDING:-/root/logs/r2ab_talent_sky_holding.stamp}
if [[ -f "$R2AB_DEC" ]] && declare -F headroom_ok >/dev/null && headroom_ok "$R2AB_DEC"; then
  echo "SKIP_${_TAG}_R2AB_CLEARS file=$R2AB_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi
for _i in $(seq 1 2880); do
  if [[ -f "$R2AB_DONE" || -f "$R2AB_DEC" ]]; then
    echo "[${_TAG}] R2ab terminal; chall lane free at iter=$_i"
    break
  fi
  if [[ -f "$R2AB_HOLDING" ]] && [[ -f "$R2AB_PIDF" ]]; then
    _ppid=$(cat "$R2AB_PIDF" 2>/dev/null || true)
    if [[ -n "${_ppid:-}" ]] && kill -0 "$_ppid" 2>/dev/null; then
      if (( _i % 12 == 0 )); then
        echo "[${_TAG}] wait-r2ab iter=$_i $(date -u +%Y-%m-%dT%H:%M:%SZ) pid=$_ppid holding"
      fi
      sleep 10
      continue
    fi
  fi
  echo "[${_TAG}] R2ab not holding lane at iter=$_i"
  break
done
# R2ac Talent×google
R2AC_DEC=${R2AC_DEC:-/root/affine_data/r2ac_alpha_decision.json}
R2AC_DONE=${R2AC_DONE:-/root/logs/r2ac_merge_reload.done}
R2AC_PIDF=${R2AC_PIDF:-/root/logs/r2ac_merge_reload.pid}
R2AC_HOLDING=${R2AC_HOLDING:-/root/logs/r2ac_talent_google_holding.stamp}
if [[ -f "$R2AC_DEC" ]] && declare -F headroom_ok >/dev/null && headroom_ok "$R2AC_DEC"; then
  echo "SKIP_${_TAG}_R2AC_CLEARS file=$R2AC_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi
for _i in $(seq 1 2880); do
  if [[ -f "$R2AC_DONE" || -f "$R2AC_DEC" ]]; then
    echo "[${_TAG}] R2ac terminal; chall lane free at iter=$_i"
    break
  fi
  if [[ -f "$R2AC_HOLDING" ]] && [[ -f "$R2AC_PIDF" ]]; then
    _ppid=$(cat "$R2AC_PIDF" 2>/dev/null || true)
    if [[ -n "${_ppid:-}" ]] && kill -0 "$_ppid" 2>/dev/null; then
      if (( _i % 12 == 0 )); then
        echo "[${_TAG}] wait-r2ac iter=$_i $(date -u +%Y-%m-%dT%H:%M:%SZ) pid=$_ppid holding"
      fi
      sleep 10
      continue
    fi
  fi
  echo "[${_TAG}] R2ac not holding lane at iter=$_i"
  break
done

# R2ad Talent×pig
R2AD_DEC=${R2AD_DEC:-/root/affine_data/r2ad_alpha_decision.json}
R2AD_DONE=${R2AD_DONE:-/root/logs/r2ad_merge_reload.done}
R2AD_PIDF=${R2AD_PIDF:-/root/logs/r2ad_merge_reload.pid}
R2AD_HOLDING=${R2AD_HOLDING:-/root/logs/r2ad_talent_pig_holding.stamp}
if [[ -f "$R2AD_DEC" ]] && declare -F headroom_ok >/dev/null && headroom_ok "$R2AD_DEC"; then
  echo "SKIP_${_TAG}_R2AD_CLEARS file=$R2AD_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi
for _i in $(seq 1 2880); do
  if [[ -f "$R2AD_DONE" || -f "$R2AD_DEC" ]]; then
    echo "[${_TAG}] R2ad terminal; chall lane free at iter=$_i"
    break
  fi
  if [[ -f "$R2AD_HOLDING" ]] && [[ -f "$R2AD_PIDF" ]]; then
    _ppid=$(cat "$R2AD_PIDF" 2>/dev/null || true)
    if [[ -n "${_ppid:-}" ]] && kill -0 "$_ppid" 2>/dev/null; then
      if (( _i % 12 == 0 )); then
        echo "[${_TAG}] wait-r2ad iter=$_i $(date -u +%Y-%m-%dT%H:%M:%SZ) pid=$_ppid holding"
      fi
      sleep 10
      continue
    fi
  fi
  echo "[${_TAG}] R2ad not holding lane at iter=$_i"
  break
done

# R2r Talent×whoami (live chal-00458) — holding stamp only; Reason waiters must not block
R2R_DEC=${R2R_DEC:-/root/affine_data/r2r_alpha_decision.json}
R2R_DONE=${R2R_DONE:-/root/logs/r2r_merge_reload.done}
R2R_PIDF=${R2R_PIDF:-/root/logs/r2r_merge_reload.pid}
R2R_HOLDING=${R2R_HOLDING:-/root/logs/r2r_talent_whoami_holding.stamp}
if [[ -f "$R2R_DEC" ]] && declare -F headroom_ok >/dev/null && headroom_ok "$R2R_DEC"; then
  echo "SKIP_${_TAG}_R2R_CLEARS file=$R2R_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi
for _i in $(seq 1 2880); do
  if [[ -f "$R2R_DONE" || -f "$R2R_DEC" ]]; then
    echo "[${_TAG}] R2r terminal; chall lane free at iter=$_i"
    break
  fi
  if [[ -f "$R2R_HOLDING" ]] && [[ -f "$R2R_PIDF" ]]; then
    _ppid=$(cat "$R2R_PIDF" 2>/dev/null || true)
    if [[ -n "${_ppid:-}" ]] && kill -0 "$_ppid" 2>/dev/null; then
      if (( _i % 12 == 0 )); then
        echo "[${_TAG}] wait-r2r iter=$_i $(date -u +%Y-%m-%dT%H:%M:%SZ) pid=$_ppid holding"
      fi
      sleep 10
      continue
    fi
  fi
  echo "[${_TAG}] R2r not holding lane at iter=$_i"
  break
done

# R2ae pure sth (board chal-00455 hr≈0.79×) — holding stamp only; often SKIP_GATED
R2AE_DEC=${R2AE_DEC:-/root/affine_data/r2ae_sth_decision.json}
R2AE_DONE=${R2AE_DONE:-/root/logs/r2ae_sth_reload.done}
R2AE_SKIP=${R2AE_SKIP:-/root/logs/r2ae_sth_reload.skip}
R2AE_PIDF=${R2AE_PIDF:-/root/logs/r2ae_sth_reload.pid}
R2AE_HOLDING=${R2AE_HOLDING:-/root/logs/r2ae_sth_holding.stamp}
if [[ -f "$R2AE_DEC" ]] && declare -F headroom_ok >/dev/null && headroom_ok "$R2AE_DEC"; then
  echo "SKIP_${_TAG}_R2AE_CLEARS file=$R2AE_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi
for _i in $(seq 1 2880); do
  if [[ -f "$R2AE_DONE" || -f "$R2AE_DEC" || -f "$R2AE_SKIP" ]]; then
    echo "[${_TAG}] R2ae terminal; chall lane free at iter=$_i"
    break
  fi
  if [[ -f "$R2AE_HOLDING" ]] && [[ -f "$R2AE_PIDF" ]]; then
    _ppid=$(cat "$R2AE_PIDF" 2>/dev/null || true)
    if [[ -n "${_ppid:-}" ]] && kill -0 "$_ppid" 2>/dev/null; then
      if (( _i % 12 == 0 )); then
        echo "[${_TAG}] wait-r2ae iter=$_i $(date -u +%Y-%m-%dT%H:%M:%SZ) pid=$_ppid holding"
      fi
      sleep 10
      continue
    fi
  fi
  echo "[${_TAG}] R2ae not holding lane at iter=$_i"
  break
done

# R2af pure awesome-v8 (live chal-00462) — holding stamp only
R2AF_DEC=${R2AF_DEC:-/root/affine_data/r2af_awesome_v8_decision.json}
R2AF_DONE=${R2AF_DONE:-/root/logs/r2af_awesome_v8_reload.done}
R2AF_PIDF=${R2AF_PIDF:-/root/logs/r2af_awesome_v8_reload.pid}
R2AF_HOLDING=${R2AF_HOLDING:-/root/logs/r2af_awesome_v8_holding.stamp}
if [[ -f "$R2AF_DEC" ]] && declare -F headroom_ok >/dev/null && headroom_ok "$R2AF_DEC"; then
  echo "SKIP_${_TAG}_R2AF_CLEARS file=$R2AF_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi
for _i in $(seq 1 2880); do
  if [[ -f "$R2AF_DONE" || -f "$R2AF_DEC" ]]; then
    echo "[${_TAG}] R2af terminal; chall lane free at iter=$_i"
    break
  fi
  if [[ -f "$R2AF_HOLDING" ]] && [[ -f "$R2AF_PIDF" ]]; then
    _ppid=$(cat "$R2AF_PIDF" 2>/dev/null || true)
    if [[ -n "${_ppid:-}" ]] && kill -0 "$_ppid" 2>/dev/null; then
      if (( _i % 12 == 0 )); then
        echo "[${_TAG}] wait-r2af iter=$_i $(date -u +%Y-%m-%dT%H:%M:%SZ) pid=$_ppid holding"
      fi
      sleep 10
      continue
    fi
  fi
  echo "[${_TAG}] R2af not holding lane at iter=$_i"
  break
done

# R2ag pure tpc9 (live chal-00463) — holding stamp only
R2AG_DEC=${R2AG_DEC:-/root/affine_data/r2ag_tpc9_decision.json}
R2AG_DONE=${R2AG_DONE:-/root/logs/r2ag_tpc9_reload.done}
R2AG_PIDF=${R2AG_PIDF:-/root/logs/r2ag_tpc9_reload.pid}
R2AG_HOLDING=${R2AG_HOLDING:-/root/logs/r2ag_tpc9_holding.stamp}
if [[ -f "$R2AG_DEC" ]] && declare -F headroom_ok >/dev/null && headroom_ok "$R2AG_DEC"; then
  echo "SKIP_${_TAG}_R2AG_CLEARS file=$R2AG_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi
for _i in $(seq 1 2880); do
  if [[ -f "$R2AG_DONE" || -f "$R2AG_DEC" ]]; then
    echo "[${_TAG}] R2ag terminal; chall lane free at iter=$_i"
    break
  fi
  if [[ -f "$R2AG_HOLDING" ]] && [[ -f "$R2AG_PIDF" ]]; then
    _ppid=$(cat "$R2AG_PIDF" 2>/dev/null || true)
    if [[ -n "${_ppid:-}" ]] && kill -0 "$_ppid" 2>/dev/null; then
      if (( _i % 12 == 0 )); then
        echo "[${_TAG}] wait-r2ag iter=$_i $(date -u +%Y-%m-%dT%H:%M:%SZ) pid=$_ppid holding"
      fi
      sleep 10
      continue
    fi
  fi
  echo "[${_TAG}] R2ag not holding lane at iter=$_i"
  break
done

# R2ah pure awesome-v9 (live chal-00467) — block while PID alive so Talent×v9
# cannot steal the lane between R2ag exit and R2ah claim.
R2AH_DEC=${R2AH_DEC:-/root/affine_data/r2ah_awesome_v9_decision.json}
R2AH_DONE=${R2AH_DONE:-/root/logs/r2ah_awesome_v9_reload.done}
R2AH_PIDF=${R2AH_PIDF:-/root/logs/r2ah_awesome_v9_reload.pid}
R2AH_HOLDING=${R2AH_HOLDING:-/root/logs/r2ah_awesome_v9_holding.stamp}
if [[ -f "$R2AH_DEC" ]] && declare -F headroom_ok >/dev/null && headroom_ok "$R2AH_DEC"; then
  echo "SKIP_${_TAG}_R2AH_CLEARS file=$R2AH_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi
for _i in $(seq 1 2880); do
  if [[ -f "$R2AH_DONE" || -f "$R2AH_DEC" ]]; then
    echo "[${_TAG}] R2ah terminal; chall lane free at iter=$_i"
    break
  fi
  if [[ -f "$R2AH_PIDF" ]]; then
    _ppid=$(cat "$R2AH_PIDF" 2>/dev/null || true)
    if [[ -n "${_ppid:-}" ]] && kill -0 "$_ppid" 2>/dev/null; then
      if (( _i % 12 == 0 )); then
        hold="holding"
        [[ -f "$R2AH_HOLDING" ]] || hold="armed"
        echo "[${_TAG}] wait-r2ah iter=$_i $(date -u +%Y-%m-%dT%H:%M:%SZ) pid=$_ppid $hold"
      fi
      sleep 10
      continue
    fi
  fi
  echo "[${_TAG}] R2ah not holding lane at iter=$_i"
  break
done

# R2ai pure sbs-v0 (live chal-00468) — block while PID alive so Talent×sbs
# cannot steal the lane between R2ah exit and R2ai claim.
R2AI_DEC=${R2AI_DEC:-/root/affine_data/r2ai_sbs_decision.json}
R2AI_DONE=${R2AI_DONE:-/root/logs/r2ai_sbs_reload.done}
R2AI_PIDF=${R2AI_PIDF:-/root/logs/r2ai_sbs_reload.pid}
R2AI_HOLDING=${R2AI_HOLDING:-/root/logs/r2ai_sbs_holding.stamp}
if [[ -f "$R2AI_DEC" ]] && declare -F headroom_ok >/dev/null && headroom_ok "$R2AI_DEC"; then
  echo "SKIP_${_TAG}_R2AI_CLEARS file=$R2AI_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi
for _i in $(seq 1 2880); do
  if [[ -f "$R2AI_DONE" || -f "$R2AI_DEC" ]]; then
    echo "[${_TAG}] R2ai terminal; chall lane free at iter=$_i"
    break
  fi
  if [[ -f "$R2AI_PIDF" ]]; then
    _ppid=$(cat "$R2AI_PIDF" 2>/dev/null || true)
    if [[ -n "${_ppid:-}" ]] && kill -0 "$_ppid" 2>/dev/null; then
      if (( _i % 12 == 0 )); then
        hold="holding"
        [[ -f "$R2AI_HOLDING" ]] || hold="armed"
        echo "[${_TAG}] wait-r2ai iter=$_i $(date -u +%Y-%m-%dT%H:%M:%SZ) pid=$_ppid $hold"
      fi
      sleep 10
      continue
    fi
  fi
  echo "[${_TAG}] R2ai not holding lane at iter=$_i"
  break
done

unset _i _ppid _TAG
