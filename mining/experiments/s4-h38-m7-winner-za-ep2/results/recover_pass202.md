# H38 king recover — pass 202

**Symptom:** Prewarm king died at EngineCore init
(`RuntimeError: Engine core initialization failed`). Teacher `:8000` stayed
up. Merge finished `22:23:13Z` (non-identical); post_train then started a
fresh king via `serve_three` (pid 11167, shared `TRITON_CACHE_DIR=…/king`)
at `22:23:29Z` while k still 000.

**Action:** `relaunch_king_pass202.sh` — wipe `king`/`king_*` caches **first**
→ sleep 5s → unique `king_p202_*` → launch on GPUs 2,3. Reaped prior :8001;
launched pid **11728** @ `22:24:22Z` TCACHE=`king_p202_1786141452_11597`.

**Status @ pass end:** king loading (APIServer init); merge.done; post_train
waiting t+k=200 then chall-only re-serve → n80. Do not `lium rm`.
