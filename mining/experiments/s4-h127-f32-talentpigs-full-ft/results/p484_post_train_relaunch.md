# p484 — F32 post_train relaunch

## Incident
Train finished 2026-08-09T06:16:27Z (loss 0.4873, 60 steps, thought_ok=477).
`post_train_pipeline.sh` then aborted: `line 90: syntax error near unexpected token ')'`
(rc=2). Cause: script was edited at ~05:42Z while the waiter loop was live
(bash source-offset). GPUs all idle; engines never served.

## Action
- Cleared `h127_pipeline.aborted`; relaunched post_train @06:21:09Z.
- finalize → OK_NON_IDENTICAL; merged `/tmp/h127_merged`; HF push
  `unconst/Affine-5czsc2fc98-h127-talentfullft` backgrounded.
- `serve_three` started (teacher first).
- n80 watcher had ABORT@360; outer `watch_n80_retry` reset poll 0/360.
- Preemptively killed+relaunched F33/F34/F35 post_train waiters (same landmine).

## Next
Wait engines promptable → n80 screen vs Tok; decide at +0.015 bar.
