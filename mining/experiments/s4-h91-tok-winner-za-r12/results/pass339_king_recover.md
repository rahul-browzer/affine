# H91 pass339 — king-only recover during merge

**UTC:** 2026-08-08T17:06Z
**Pod:** mine-h91-1 (brave-shark-d2)

## Symptom
- `:8001=000` while merge_lora on GPUs 6,7; teacher `:8000=200`.
- `vllm_king.log` @16:56:12Z: Triton `ImportError` bare
  `/root/.triton/cache/king/FHFMBKEV…/__triton_launcher.so` ENOENT → EngineDead.
- APIServer pid=7530 hung (shm_broadcast timeouts); GPUs 2,3 still ~37 GiB.

## Action
1. Uploaded `king_recover_pass339.sh` (isolated TCACHE + util=0.72; health+/v1/models
   only — no completions probe per H85).
2. Launched pid=13483 → reap GPUs 2,3 → TCACHE
   `/root/.triton/isolated/h91_king_p339_1786208779_13483` → vllm pid=13758 @17:06:45Z.
3. Rearmed `watch_preempt_bare_tcache_pass264` (was poll~204/240; H69) → pid=13566.

## Left alone
- `post_train_pipeline` pid=4954, `merge_lora` pid=12354 (GPUs 6,7).
- Teacher on 0,1. Chall not up yet (GPUs 4,5 free).

## Next
- Await `h91_king_recover_pass339.done` + merge.done → chall serve → preempt/mid304 → n80.
