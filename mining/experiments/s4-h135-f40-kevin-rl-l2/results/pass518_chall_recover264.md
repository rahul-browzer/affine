# p518 — F40 chall recover264 + DEADMAN patch

## Finding
Merge DONE 09:53Z (`weight_identical=false`, train 189 steps mean_r_last20≈−0.042).
Chall re-serve used bare `/root/.triton/cache/chall` → Triton ENOENT
`NODUTTS4DLPAU2XH…/__triton_launcher.so` → EngineDead; `:8002=000`.
`DEADMAN_UTC` default still `2026-08-09T06:36:00Z` (stale; would abort n80).

## Action
1. Patched `post_train_pipeline.sh`: SOFT=`19:12Z` DEADMAN=`19:42Z` (TTL−1h/−30m vs remove≈20:12Z).
2. Cleared `h135_n80_retry.aborted` / pipeline abort.
3. Fired `relaunch_chall_pass264.sh` (pid37912) — king-seed isolated TCACHE, util=0.72.
4. Left teacher:8000 + Tok king:8001 up.

## Next
Await recover264 DONE → n80 d203 → decision vs Tok.
