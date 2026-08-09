# p481 — F31 chall death = missing tokenizer in finalize

**Symptom:** recover480 a1/a2 chall died before health. Log:
`Failed to apply Qwen3VLProcessor on data=...` / `Worker proc VllmWorker-0 died`.

**Root cause:** `/tmp/h126_merged` had weights+visual+preprocessor but **no**
`tokenizer.json` / `tokenizer_config.json` / `vocab.json` / `merges.txt`.

**Fix:** `cp -L` tokenizer+vocab+merges+chat_template from Bittob base
`…/snapshots/0c04fe92…` into `/tmp/h126_merged`; wrote `processor_config.json`
from preprocessor. Killed a3 (launched pre-copy) + recover480; rearmed
`relaunch_chall_pass264.sh` as recover481.

**Also:** backfilled vocab/merges/processor on F30; processor on F29.
