# pass 417 — F4 kill stale longwait c203 → d203first live

## Finding
- Reconcile: 6 mine-* match inventory. King still Tok af10 S=0.04456.
- F4 live sim was **c203** (pid 105733) under stale `retry_h100_n80_longwait.sh`
  (pid 98361), not under armed `retry_h100_n80_d203first.sh` watcher.
- longwait attempt2 already died teacher **400**; attempt3/3 c203 just started
  (~00:11Z). d203first watcher idle because a sim was already running.
- Killed sim+longwait by PID. Watcher launched d203first @00:13:42Z →
  **n80 attempt 1/6 block_hash=d203** (pid 106729) engines 200/200/200.

## Fleet at cut
| pod | status |
|---|---|
| F4 | n80 **d203** just launched |
| F7 | n80 e203 ~47–48/80 |
| F9 | n80 d203 ~20–22/80 |
| F10 | train live (no ckpt yet; GPU6 util~57%) |
| F11 | train live (no ckpt yet; GPU7 util~51%); king DL af10 done |
| F12 | golden-crown HF DL mid |

## Local hygiene
- Patched `retry_h100_n80_longwait.sh` + `retry_h100_n80.sh` hashes → d/e/f/g/b,
  MAX=6 (no a203/c203). Pod already on d203first; local fix for next SCP.
