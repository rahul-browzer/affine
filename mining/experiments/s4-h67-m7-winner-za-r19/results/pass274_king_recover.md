# H67 pass274 — king EngineCore cancelled → relaunch

## Failure
- Merge OK non-identical @09:14; serve_three launched king pid=13625 @09:15:03.
- King died @09:18:50: `RuntimeError: cancelled` in shm_broadcast during
  kv_cache init; APIServer `Engine core initialization failed`.
- GPUs 2–3 free; post_train stuck in teacher/king health wait (`sleep 15`).

## Action (do **not** `pkill -f` — argv self-match kills SSH)
- Wipe `/root/.triton/cache/king`; settle 25s.
- `nohup bash /root/logs/h67_king_recover_pass274.sh` → `serve_three`
  KING=TalentPigs@dbfbb3e2 CHALL=/root/h67/merged.
- king pid=17834 @09:23:36; chall pid=18017 @09:23:51 (bare cache/chall —
  preempt264 armed).
- @09:25: :8001/:8002 still 000; GPU2/3 loading (~36/28 GiB).

## Next
Wait :8001/:8002=200; post_train should exit wait → chall-only restart /
preempt264 → n80. If king dies again, same wipe+serve_three (PID-only kills).
