# H57 pass249 — king mid-n80 Triton ENOENT → chall-seed prefreeze

**Symptom (05:32–05:34Z):** n80 attempt1 @ chall 2–4/80; king `:8001`
health=200 but completions hang/000. `vllm_king.log`:
`ImportError: .../cache/king/.../__triton_launcher.so: No such file or directory`
then `shm_broadcast` 60s hang. Teacher+chall stayed 200/promptable.

**Action:** kill stuck `run_sim_duel` + retry; launch
`relaunch_king_pass249.sh` (H56 p247 chall recipe adapted to king):
reap GPUs 2,3 → wipe king caches → outer×3 → seed TCACHE from live
`/root/.triton/cache/chall` → settle45 → PRE-FREEZE before w1 →
warmup×3 → rearm form+watch_n80_retry. Marker:
`/root/logs/h57_king_freeze_pass249.done`. **FALSE_PROBE**, not REFUTE.

**Check next:** freeze.done → n80 a203 retry; if w1 ENOENT keep outer×3.
