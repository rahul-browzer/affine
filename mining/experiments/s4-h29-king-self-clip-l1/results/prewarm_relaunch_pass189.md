# H29/H30 prewarm relaunch — pass 189

## Finding

`prewarm_engines.sh` exited at corpus sync with:
`[Errno 2] No such file or directory: turns.jsonl.tmp -> turns.jsonl`
while a parallel `extra_dl`/corpus sync was writing the same path. `set -e`
killed prewarm **before** `serve_three`, so GPUs 0–5 stayed empty despite
`turns.jsonl` (9327 lines) and `teacher.done`/`talentpigs.done` being present.

H29 train was ~40/46 when found; H30 ~22/46. Post-train would have cold-started
engines after merge (~15–20 min delay).

## Fix

1. `experiments/s3-duel-sim/sync_corpus.sh`: flock on
   `$AFFINE_DATA_DIR/.corpus_sync.lock`; on sync failure, adopt existing
   non-empty `turns.jsonl` instead of aborting.
2. SCP'd fix to h29–h32; relaunched `prewarm_engines.sh` on h29+h30.
3. Confirmed teacher `vllm serve` pid up on both (:8000) immediately after.

## Decision

Keep pods. Next pass: wait train.done → merge → n80 with warm teacher/king.
