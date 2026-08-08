# H64 pass265 — p264 bare-TCACHE preempt fired

UTC: 2026-08-08T07:56:29Z · pod gentle-wolf-eb

## Sequence
1. merge.done + OK_NON_IDENTICAL @ 07:51:36Z
2. chall-only re-serve started @ 07:52:09Z with
   `TRITON_CACHE_DIR=/root/.triton/cache/chall` (bare) gpus=4,5 util=0.72
3. chall engine init ~138s; preempt saw health@8002
4. **preempt264 fired** @ 07:56:29Z:
   `chall up TCACHE=/root/.triton/cache/chall` → `BARE/non-isolated — launch recover264`
   recover pid=16643
5. recover killed leftover post_train/wait/n80-watch (917,940,2460,13007,13278),
   wiped caches, seeded king→isolated TCACHE WRITABLE, relaunched chall
   `TCACHE=/root/.triton/isolated/h64_chall_p260_a1_…` chall_pid=16784
6. recover script ends by rearming `watch_form_decision` + `watch_n80_retry`

## Status at write
- recover attempt 1/3 waiting health=200 (diverse-warm → freeze → n80)
- HF push background: `unconst/Affine-5czsc2fc98-h64-{lora,merged}`

## Decision
Preempt path validated on H64. Next: wait freeze.done + n80 a203 start;
do not `lium rm`.
