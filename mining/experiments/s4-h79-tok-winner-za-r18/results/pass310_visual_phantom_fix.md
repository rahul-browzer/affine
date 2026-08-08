# Pass 310 — Tok phantom visual index (H79 + H80)

## Symptom
Chall die before health with:
`ValueError: Following weights were not initialized … visual.*`
(after pass307 preprocessor fix cleared `OSError` on `preprocessor_config`).

## Root cause
Tok331102 packs `model.visual.*` into language shards. CausalLM merge drops
the tensors but **keeps 333 visual keys in `model.safetensors.index.json`**
pointing at shards that contain 0 visual tensors. `merge_lora.py` treated
index presence as restore success and skipped extraction.

## Fix
1. `restore_visual_pass310.py`: extract 333 keys from Tok base →
   `model-visual-restored.safetensors` (852 MiB); rewrite index.
2. Patch `merge_lora.py`: detect phantom index entries (key in index, absent
   from shard file) → extract; refuse unless `visual_resolved == n_vis`.
3. H79/H80: kill dying recover, restore, relaunch `relaunch_chall_pass264`.

## Evidence
Post-fix: `Resolved architecture: Qwen3_5MoeForConditionalGeneration`;
GPUs 4,5 at **36075 MiB** (was 4 MiB then ValueError). No visual ValueError.
