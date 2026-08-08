# Pass 307 — Tok processor sidecar fix (H79)

## Symptom
Chall serve of `/root/h79/merged` died before GPU alloc:
`OSError: Can't load image processor … missing preprocessor_config.json`.

## Root cause
Tok331102 ships `processor_config.json` (nested `image_processor`) and **no**
`preprocessor_config.json`. `merge_lora.py` only restored the latter name.
Visual restore was fine (333 keys); config wrapper restored; only the
preprocessor sidecar was missing.

## Fix
1. On pod: copy `processor_config.json`; derive flat
   `preprocessor_config.json` from `image_processor`.
2. Patch `experiments/s4-h1-sft/merge_lora.py` for future Tok-init merges.
3. H80 (merge already in-flight): sidecar + force-apply same files before
   chall-only re-serve (`h80_tok_processor_fix_pass307`).
4. Relaunch H79 chall via `relaunch_chall_pass264` (killed stuck
   `restart_for_h2`/`post_train`; recover rearms form+n80).

## Evidence
Post-fix chall log: `Resolved architecture: Qwen3_5MoeForConditionalGeneration`
+ `Qwen2VLImageProcessor` (no OSError). GPUs 4,5 loading under isolated TCACHE.
