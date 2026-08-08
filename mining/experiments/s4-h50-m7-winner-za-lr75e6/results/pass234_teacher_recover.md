# Pass 234 — H50 teacher recover

**Cause:** teacher :8000 hung mid-init (Triton `.ttir` FileNotFoundError @03:15Z)
then `shm_broadcast` >5m. King :8001 OK. Merge DONE + OK_NON_IDENTICAL @03:25Z.
`serve_three` saw hung pid → "teacher already running" → post_train wait loop.

**Action:** `relaunch_teacher_pass234.sh` HYPO=h50 — reap GPUs 0,1 → wipe
`teacher*` → settle20 → unique `TCACHE=teacher_p234_*` → vllm serve :8000.
King untouched.

**Result:** DONE_LAUNCH 03:30:15Z pid=14078; t=200 @~03:36Z; post_train resumed
→ `restart_for_h2` serving `/root/h50/merged` :8002 @03:36:36Z (c loading).
Adapter lr=7.5e-6 α32 r16 verified. Next: chall promptable → n80 → decision.
