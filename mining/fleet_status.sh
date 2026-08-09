#!/usr/bin/env bash
# Parallel mine-* status table. Edit PODS when inventory changes.
set -euo pipefail
PODS=(
  "f31|38.255.28.21|20099|/tmp/mine-f31-1.known_hosts|h126"
  "f22|204.9.206.243|40300|/tmp/mine-f22-1.known_hosts|h117"
  "f23|204.9.206.244|40301|/tmp/mine-f23-1.known_hosts|h118"
  "f32|38.255.28.22|20099|/tmp/mine-f32-1.known_hosts|h127"
  "f26|152.236.142.235|40300|/tmp/mine-f26-1.known_hosts|h121"
  "f27|152.236.142.237|40299|/tmp/mine-f27-1.known_hosts|h122"
  "f28|152.236.142.232|40300|/tmp/mine-f28-1.known_hosts|h123"
  "f29|152.236.142.234|40300|/tmp/mine-f29-1.known_hosts|h124"
  "f30|152.236.142.236|40300|/tmp/mine-f30-1.known_hosts|h125"
)
OUT=$(mktemp -d /tmp/fleet_status.XXXXXX)
trap 'rm -rf "$OUT"' EXIT

for spec in "${PODS[@]}"; do
  IFS='|' read -r tag host port kh hyp <<<"$spec"
  (
    ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile="$kh" \
        -o ConnectTimeout=8 -o BatchMode=yes -o LogLevel=ERROR \
        -i "${HOME}/.ssh/id_ed25519" "root@${host}" -p "$port" \
        "TAG=$tag HYP=$hyp bash -s" <<'EOS' >"$OUT/$tag.txt" 2>&1 \
        || echo "$tag|SSH_FAIL|-|-" >"$OUT/$tag.txt"
n80="-"
if [[ -f /root/affine_data/${HYP}_sim_progress.json ]]; then
  n80=$(python3 -c "import json;d=json.load(open('/root/affine_data/'+'$HYP'+'_sim_progress.json'));print(f\"{d.get('challenger','?')}/{d.get('challenger_total','?')}\")" 2>/dev/null || echo "?")
fi
eng=""
for p in 8000 8001 8002; do
  c=$(curl -s -o /dev/null -w "%{http_code}" --max-time 1 "http://127.0.0.1:$p/v1/models" 2>/dev/null || echo x)
  eng+="$c"
done
stage="idle"
ps -eo args | grep -q '[t]rain_rl_l1\|[t]rain_lora\|[t]rain_full' && stage=train
ps -eo args | grep -q '[m]erge_lora\|[f]inalize_full' && stage=merge
ps -eo args | grep -q '[m]erge_recover' && stage=mrecover
ps -eo args | grep -q '[k]ing_recover' && stage=krecover
ps -eo args | grep -q '[r]un_sim_duel' && stage=n80
ps -eo args | grep -q '[b]ootstrap_\|[p]ip install\|[h]uggingface-cli\|[h]f download' && stage=boot
[[ -f /root/affine_data/${HYP}_decision.json ]] && stage=done
# extra progress hints
extra=""
if [[ -f /root/affine_data/${HYP}_decision.json ]]; then
  extra=$(python3 -c "import json;d=json.load(open('/root/affine_data/'+'$HYP'+'_decision.json'));print(d.get('verdict','?'), 'm='+str(d.get('margin',d.get('mean_margin','?')))[:12])" 2>/dev/null || echo dec)
fi
ts=""
if [[ -f /root/ckpts/${HYP}/trainer_state.json ]]; then
  ts=$(python3 -c "import json;d=json.load(open('/root/ckpts/'+'$HYP'+'/trainer_state.json'));print(f\"step={d.get('global_step','?')}/{d.get('max_steps',d.get('num_train_epochs','?'))} loss={d.get('log_history',[{}])[-1].get('loss','?')}\")" 2>/dev/null || echo "")
fi
# common alt paths
for p in /root/affine_data/${HYP}/trainer_state.json /root/train/${HYP}/trainer_state.json /root/out/${HYP}/trainer_state.json; do
  if [[ -z "$ts" && -f "$p" ]]; then
    ts=$(python3 -c "import json;d=json.load(open('$p'));print(f\"step={d.get('global_step','?')}\")" 2>/dev/null || echo "")
  fi
done
dl=""
if [[ -d /root/models ]]; then
  dl=$(du -sh /root/models 2>/dev/null | awk '{print $1}' || true)
fi
echo "${TAG}|${stage}|n80=${n80}|eng=${eng}|${extra}|${ts}|dl=${dl}"
EOS
  ) &
done
wait
printf '%-6s %-8s %-12s %-14s %s\n' POD STAGE N80 ENGINES EXTRA
for spec in "${PODS[@]}"; do
  IFS='|' read -r tag _ <<<"$spec"
  line=$(tail -1 "$OUT/$tag.txt" 2>/dev/null || echo "$tag|?|-|-")
  echo "$line"
done
