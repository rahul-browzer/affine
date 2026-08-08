# H67 pass275 — king Triton ENOENT → king-only relaunch

## Failure (after pass274 recover)
- pass274 relaunch king pid=17834 + chall pid=18017 @09:23.
- King died @09:28:25 during kv_cache init:
  `RuntimeError: .../cache/king/NPCWTIH3…/__triton_launcher….so: No such file`
  (ghost Triton dentry; directory later listed the .so).
- Chall APIServer then shut down; GPUs 2–5 free.
- preempt264 @09:29:54 saw bare `cache/chall` → launched recover264
  (killed post_train pid=2603 + n80-retry).

## Action
- recover264 already running (pid=23469): isolated TCACHE seed from
  (pre-wipe) king cache launcher.so=16; chall pid=23895 @09:30:44.
- **King-only** relaunch (do not `serve_three` — would fight recover264 on 4,5):
  `king_recover_pass275.sh` → wipe `cache/king`+`king_*`, settle 25s,
  vllm king on GPUs 2,3. pid=24416 @09:31:28.
- Never `pkill -f` (LESSONS).

## Status @09:32Z
- :8000=200; :8001/:8002=000 loading (GPU2–5 ~4 MiB).
- Next: wait king+chall health200; recover264 diverse-warm→freeze→rearm
  form+n80. If king dies again on ENOENT, same wipe+king-only script.
