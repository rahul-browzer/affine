# H100/F4 pass388 — kill post_train abort-race; arm tok.done watcher

## Problem
- post_train `serve_three` launched king while Tok shard1 incomplete → king dead.
- Range-resume (PID 42075) live on shard1 @ ~54% (expect 35101763136 B).
- post_train king-wait: ~92/120 polls used → ABORT in ~7 min.
- Range ETA ~9–10 min → post_train would write `aborted_engines_unhealthy` first.

## Action
- Killed post_train PID 39016 only (before abort).
- Left Range writer 42075 untouched (HF Range ≫ peer-rsync; LESSONS).
- Armed `watch_tok_done_serve_pass388.sh` PID 50986:
  wait `tok331102.done` (or finalize full incomplete) →
  `king_recover_pass332` (util=0.72) → `relaunch_chall_pass264` →
  clear `h100_n80_retry.aborted` so existing `watch_n80_retry` can run n80.

## Also noted
- F9 “3 train_lora PIDs” = 1 parent + 2 torch children (not corruption); step~26/60.
- F7 b203 n80 live @ chall 4/80; F1 @ 26/80; F6 chall still loading.
