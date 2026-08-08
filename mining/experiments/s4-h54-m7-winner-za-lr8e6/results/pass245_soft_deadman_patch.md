# pass245 — SOFT/DEADMAN file-default harden (h54/h55/h56)

## Why
Recovered post_train processes had `SOFT=15:30Z` / `DEADMAN=16:20–16:30Z` in
environ, but on-pod script defaults were still `:-04:30Z` / `:-05:30Z`. A
restart without env export would abort immediately (`<60m to soft`).

## Done
- Pods mine-h54/55/56: patched `post_train_pipeline.sh` defaults →
  SOFT `2026-08-08T15:30:00Z`, DEADMAN h54=`16:20Z` h55/h56=`16:30Z`.
- Local `experiments/s4-h{54,55,56}-*/post_train_pipeline.sh` same.
- h57 already shipped with correct file defaults; post_train pid=2667 uses them
  (no SOFT in environ — defaults bind).

## Poll @ 04:48Z
- H51 n80 b203 king37/chall36; :8000/:8001/:8002 models=200
- H54 merge_lora writing shard 0/2 (~49.7GB .tmp)
- H55 train ~18/26; H56 ~11/26; H57 train launched 04:47Z
