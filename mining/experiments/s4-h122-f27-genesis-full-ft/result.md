## Progress (p475)
- Engines double-promptable @05:45:49Z; n80 attempt 1/6 block_hash=d203… started (run_sim_duel live).
- Next: poll margin in /root/affine_data/h122_decision.json (screen gate ±0.015).
## p476
- Symptom: n80 FALSE_PROBE ~48s ×3; rejection `unpromptable:…404` on :8002/completions.
- Cause: vLLM served id=/tmp/h122_merged; sim used symlink /root/h122/merged.
- Fix: retry_h122_n80_d203first_p476.sh MERGED=$(readlink -f …); n80 progressed to 2/80.
