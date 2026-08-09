# pass480 — F29/F30/F31 chall recover after dead preempt EXP

## Finding
`watch_preempt_bare_tcache_pass264.sh` on F26–F35 (except F28) had
`EXP=s4-hNNN-f26-af-k1` (copy-paste). Preempt saw bare TCACHE, tried
`chmod` on nonexistent path → chall died Triton ENOENT (`__triton_launcher.so`)
and never recovered. F29 teacher also hung (`shm_broadcast` 60s loops, ~56 GiB).

## Action 2026-08-09T06:03Z
- Fixed local+pod EXP → real dir names (h121–h130 except h123 already ok).
- F29: `relaunch_teacher_pass332` + `relaunch_chall_pass264` (isolated seed king n_so=16).
- F30: `relaunch_chall_pass264` (t+k already 200).
- F31: teacher+chall recover (merge ready; GPUs 0,1,4,5 free).
- Pushed fixed preempt to F26/F27/F32–F35.

## Next
Poll :8000/:8002 PROMPTABLE → n80 watchers already armed (d203first).
