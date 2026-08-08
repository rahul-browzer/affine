# H81 pass319 — merge DONE → recover264 → n80 LIVE

UTC: 2026-08-08T14:09–14:21Z · pod mine-h81-1 (golden-orbit-da)

## What happened
1. Merge finished 14:09:48Z — 66G, visual restored, preprocessor present,
   weight-identical=false vs tok_init and Tok331102 king.
2. post_train served chall on **bare** `TRITON_CACHE_DIR=/root/.triton/cache/chall`
   util=0.72 (pid=16622 @14:10:23Z).
3. preempt264 (rearmed p318) saw bare TCACHE @14:14:48Z → recover264
   (killed post_train + stale retry; chall-only relaunch).
4. recover264 attempt1: isolated TCACHE
   `/root/.triton/isolated/h81_chall_p260_a1_1786198529_20166`, health=200
   @14:18:32Z → diverse writable warmups → freeze n_so=22 mode=555 →
   triple-promptable @14:20:03Z → rearmed form+watch_n80.
5. n80 attempt1/3 started @14:20:25Z block_hash=**a203**…
   `run_sim_duel.py` pid=22899 · engines 200/200/200 · king util still 0.80.
6. Pass armed **mid304** (pid=23355) — recover264 does not rearm it.

## HF salvage (not a submission)
- `unconst/Affine-5czsc2fc98-h81-merged` meta written
  `/root/affine_data/h81_merged_salvage.json`
- adapter → `unconst/Affine-5czsc2fc98-h81-lora`

## Next
- Wait n80 → `h81_decision.json`. Watch king util=0.80 first-turn OOM
  (H80 p315 → util=0.72). mid304 armed for mid-n80 bare.
