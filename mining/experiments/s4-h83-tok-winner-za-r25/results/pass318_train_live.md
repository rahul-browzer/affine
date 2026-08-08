# Pass 318 — H83 Tok-init dl → train LIVE

## Observed
- Last shard incomplete grew ~31G→~35G then completed @~14:05:39Z.
- `tok_init.done` + `tok331102.done` present; snapshot has both
  `model-00001/00002.safetensors` (~66G hub cache).
- Bootstrap: `TRAIN_LAUNCHED pid=4970` @14:05:39Z; `BOOTSTRAP_DONE`
  train=4970 post=4978.
- Train: Tok-init × winner-zA @ **r=25**/α32 lr=5e-6 thought-only on GPUs 6,7;
  fit-filter kept 205/406; step ~3/26 by 14:08Z.

## Side work same pass
- H81 preempt had TIMED OUT @14:00Z (merge still writing shard2 ~19G tmp) →
  rearmed pid=16119.
- H82 preempt @228/240 → killed pid=926, rearmed pid=14640 (reset 40m budget).
- merge_lora still live on both (h81:12688, h82:12838); patched merge derives
  preprocessor + visual restore (no separate fix_tok needed).

## Next
Train → merge → chall → n80 vs Tok331102. Do not tear down.
