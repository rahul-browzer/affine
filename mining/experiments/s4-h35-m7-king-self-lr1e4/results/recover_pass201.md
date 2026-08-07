# H35 king recover — pass 201

**Symptom:** `:8001` never healthy after prewarm. Same Triton
`__triton_launcher.so` race under `/root/.triton/cache/king/...` at
`21:28Z`. Teacher `:8000` stayed up. Merge still writing shard 2 on 6,7.

**Attempt A (`relaunch_king_pass201.sh`):** unique `king_p201_*` cache, but
script did `rm -rf .../king_*` *after* creating TCACHE (then mkdir again —
empty OK) and still hit `__triton_launcher.so` missing inside the new
cache at `22:10:18Z`. Engine dead; GPUs 2,3 free again.

**Attempt B (inline 201b):** wipe caches first → sleep 5s → *then* create
`king_p201b_*` → launch. Launched `22:11:42Z` pid 13595 → **health 200**
+ Application startup complete @ ~22:15Z. Pipeline had already entered
`serve_three` (saw k=000 mid-load), stopped placeholder chall, then
chall-only re-serve. @22:19Z t/k=200, chall loading on 4,5 (~36 GiB).
