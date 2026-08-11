# p2042 — R2au pure-sft4 armed (wait R2at)

UTC: 2026-08-11T15:04Z

## Confirmed
- `weight_version_key=3`, live `k_sigma=2.0`
- mine-crown-1 only mine-* · $52.25/h · bal ~$121742
- R2aq pure-now n80 ~16–17/80 (pid122306) · engines 200/200/200
- sft4 prefetch DONE (`syntaxsorcerer1/…-sft4@df83346c…`)

## Armed
- Pre-staged `/root/r2_out/sft4_chall` (preprocessor from processor_config)
- `launch_r2au_sft4_reload_sim` waits R2at terminal → pure sft4 n80
- `watch_r2au_stage5_push` armed (no auto-submit)
- `wait_r2q_before_chall_kill.inc.sh` +R2AT +R2AU holding gates

## Decision rule (pre-registered)
Submit only if local headroom_vs_3se ≥ 1.5 on a fresh n80 slice.
