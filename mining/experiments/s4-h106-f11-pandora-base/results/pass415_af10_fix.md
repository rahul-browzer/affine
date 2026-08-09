# H106/F11 pass415 — king repo typo af11→af10

## Bug
Pass414 cloned F11 scripts with `Tok331102/affine-5EqYW8McUc-af11`
(404 / repo missing). Live king is `…-af10` @ `eb8bf9a…`. Would have
failed king DL / served wrong path after train.

## Fix
- Host + pod on-disk scripts: all `af11` → `af10` (bootstrap, retry*,
  prewarm, post_train, king_recover*).
- Running bootstrap already had af11 in memory; after pandora.done +
  train launch, killed bad extra_dl and relaunched
  `launch_extra_dl_p415.sh` (teacher + Tok af10).
- Prewarm waiter (pid 2835) left intact — will fire on done markers.
- Train pid=2828 live on pandora @5218b138 (unaffected).

## Lesson
Never name a fix script `*af11*` if a kill-loop matches that substring
in `/proc/*/cmdline` — the first fixer suicided.
