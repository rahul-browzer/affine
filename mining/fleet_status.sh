#!/usr/bin/env bash
# Parallel mine-* status table. Edit PODS when inventory changes.
set -euo pipefail
PODS=(
  "f16|152.236.142.236|40311|/tmp/mine-f16-1.known_hosts|h111"
  "f17|38.255.28.18|20099|/tmp/mine-f17-1.known_hosts|h112"
  "f18|86.38.238.54|40300|/tmp/mine-f18-1.known_hosts|h113"
  "f22|204.9.206.243|40300|/tmp/mine-f22-1.known_hosts|h117"
  "f23|204.9.206.244|40301|/tmp/mine-f23-1.known_hosts|h118"
  "f25|3.135.191.208|20126|/tmp/mine-f25-1.known_hosts|h120"
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
ps -eo args | grep -q '[t]rain_rl_l1\|[t]rain_lora' && stage=train
ps -eo args | grep -q '[m]erge_lora' && stage=merge
ps -eo args | grep -q '[m]erge_recover' && stage=mrecover
ps -eo args | grep -q '[k]ing_recover' && stage=krecover
ps -eo args | grep -q '[r]un_sim_duel' && stage=n80
ps -eo args | grep -q '[b]ootstrap_' && stage=boot
[[ -f /root/affine_data/${HYP}_decision.json ]] && stage=done
echo "${TAG}|${stage}|n80=${n80}|eng=${eng}"
EOS
  ) &
done
wait
printf '%-6s %-8s %-12s %-14s\n' POD STAGE N80 ENGINES
for spec in "${PODS[@]}"; do
  IFS='|' read -r tag _ <<<"$spec"
  line=$(tail -1 "$OUT/$tag.txt" 2>/dev/null || echo "$tag|?|-|-")
  IFS='|' read -r a b c d <<<"$line"
  printf '%-6s %-8s %-12s %-14s\n' "${a:-$tag}" "${b:--}" "${c:--}" "${d:--}"
done
