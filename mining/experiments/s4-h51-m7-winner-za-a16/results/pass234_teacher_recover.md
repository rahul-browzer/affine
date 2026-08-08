# Pass 234 — H51 teacher recover

**Cause:** teacher :8000 hung (`__triton_launcher.so` ImportError @03:15Z) then
`shm_broadcast` loop. King :8001 OK. Merge DONE + OK_NON_IDENTICAL @03:24Z.
Same `serve_three` false-alive as H50.

**Action:** `relaunch_teacher_pass234.sh` HYPO=h51 — same reap/wipe/settle/TCACHE.

**Result:** DONE_LAUNCH 03:30:15Z pid=14397; t=200 @~03:36Z; post_train resumed
→ chall `/root/h51/merged` :8002 @03:36:19Z (c loading). Adapter α=16 r16 lr=1e-5
verified. Next: chall promptable → n80 → decision.
