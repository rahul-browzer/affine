# Pass 332 — H89 teacher+king recover (chall left alone)

**Cause:** first n80 attempt @16:17Z hit bare Triton ENOENT on both:
- king `:8001` — `cache/king/4UYR2LE4…/__triton_launcher.so` @16:17:30Z
- teacher `:8000` — `cache/teacher/6YKNXZRS…/__triton_launcher.so` @16:17:53Z
Chall `:8002=200` stayed (isolated `h89_chall_p260_a1_*` from recover264 DONE
@16:16:17Z). GPUs 0–3 empty; 4–5 chall ~131 GiB.

**Action (leave chall):**
1. `relaunch_teacher_pass332.sh` pid20695 → DONE_LAUNCH 16:20:58Z pid20891
   TCACHE=`teacher_p332_1786206035_20695` util=0.80
2. `king_recover_pass332.sh` pid20696 → start 16:21:04Z pid20976
   TCACHE=`/root/.triton/isolated/h89_king_p332_1786206038_20696` util=**0.72**
   (awaits KING PROMPTABLE; clears stale sim progress)

**Watchers:** form + `watch_n80_retry` still armed (retry waiting engines).
Arm mid304 when n80 actually starts after both :8000/:8001 promptable.
FALSE_PROBE ≠ REFUTE.
