# Pass 228 — H49 teacher freeze → merge → chall → n80

**UTC:** 2026-08-08T02:30–02:40Z

## Actions
1. Launched `freeze_teacher_pass228.sh` on mine-h49-1 (pid check, not argv match).
2. Teacher promptable 02:33Z → freeze
   `TCACHE=/root/.triton/cache/teacher_p227_1786156048_14128` mode **555**.
3. Merge finished 02:31:11Z — OK_NON_IDENTICAL vs m7 + TalentPigs
   (`window_any_diff=true` both). Markers: `/root/logs/h49_merge.done`.
4. Pipeline chall-serve `/root/h49/merged` on GPUs 4,5 → health+completions
   200 @ 02:40:20Z. Froze chall TCACHE `/root/.triton/cache/chall` mode **555**.
5. `watch_n80_retry` deferred post_train n80; `retry_h49_n80` launched
   `run_sim_duel.py` local-h49 **a203** (pid 21842). PIPELINE_DONE.

## Engines @ handoff
| role | port | probe | TCACHE freeze |
|---|---|---|---|
| teacher | 8000 | completions 200 | 555 teacher_p227_* |
| king | 8001 | health 200 | (prewarm) |
| chall | 8002 | completions 200 | 555 chall |

## Next
Poll `/root/affine_data/h49_sim_progress.json` → `h49_decision.json`.
Do not `lium rm` on ConnectError — quarantine+recover.
