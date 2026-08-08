# H54 pass244 — post_train soft-abort recover

Train finished 04:38Z (`train.done` + adapter). Pipeline had aborted at
04:27Z (`WARN: <60m to soft` — default SOFT was 04:30Z).

Relaunched `post_train_pipeline.sh` @04:43:05Z with
`SOFT=2026-08-08T15:30:00Z` `DEADMAN=16:20:00Z`. Merge on GPUs 6,7 started
04:43:20Z. Teacher+king :8000/:8001 healthy; chall pending merge.
