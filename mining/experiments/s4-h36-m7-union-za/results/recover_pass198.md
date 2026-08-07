# H36 bootstrap recover — pass 198

**Symptom:** train alive on GPUs 6–7, but no `teacher.done` /
`talentpigs.done` / `corpus.done`, no `post_train` / `prewarm`.

**Root cause:** `start_h36.sh` unterminated string in `note` JSON →
SyntaxError after `nohup train`; bootstrap `set -e` aborted before
extra_dl / prewarm / post_train.

**Action:** Fixed quote in `start_h36.sh`; wrote
`h36_train_launched.json`; launched `h36_extra_dl_pass198.sh` (teacher
download started), prewarm waiter, and `post_train_pipeline.sh`.
