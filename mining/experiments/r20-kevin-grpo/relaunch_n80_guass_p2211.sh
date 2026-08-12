#!/usr/bin/env bash
# Host copy of on-pod relaunch (p2211): n80 kevin-merged vs live guass king.
# On pod: /root/mining_src/r20-kevin-grpo/relaunch_n80_guass_p2211.sh
# Watch: tail -f /root/logs/r20_n80_guass_p2211.nohup
# Result: /root/affine_data/r3_sim_result.json + r20_decision.json
set -euo pipefail
echo "run on mine-r4-fullft-1, not this host" >&2
exit 1
