# p2035 — R2ap n80 live + R2ar iynocr2p armed

UTC: 2026-08-11T14:21Z

## Confirmed
- `weight_version_key=3`, live `k_sigma=2.0`
- mine-crown-1 only mine-* pod · $52.25/h · bal ~$121824
- R2ap pure h44: engines 200/200/200; n80 gathering (~7/80) pid 110708
- Board current_eval = chal-00485 h44 (same parent as R2ap)

## Armed (CPU / waiters)
- Prefetch `darius3th/Affine-5gcl5uxakb-iynocr2p@fe080f2b…` (chal-00490) — weights_ok
- Chain prefetch `Shatoria/Affine-5ghntktyzq-hope11@1be4ac10…` (chal-00491) after iynocr2p DONE
- `watch_chal00490_reason` + `watch_chal00491_reason`
- `launch_r2ar_iynocr2p_reload_sim` waits R2aq terminal → pure iynocr2p n80
- `watch_r2ar_stage5_push` armed (no auto-submit)
- `wait_r2q_before_chall_kill.inc.sh` gained R2ar holding gate

## Decision rule (pre-registered)
Submit only if local headroom_vs_3se ≥ 1.5 on a fresh n80 slice.
