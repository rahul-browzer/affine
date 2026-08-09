# H135/F40 — kevin954 REINFORCE teacher-Λ2 — REFUTED (pass 533)

## Screen (n80, block_hash c203…003)

| metric | value |
|---|---|
| margin | **−0.02343** |
| z | −1.905 |
| SE | 0.01230 |
| S_c / S_k | −0.00018 / 0.02334 |
| λ2_c / λ2_k | −0.02110 / −0.00949 |
| r_c | 0.886 |
| base_x | 1.002 |
| gates | valid_c=true, pass_rate=0.846, bank=0.526 |

## Decision

`REFUTE_H135` — margin below zero; Λ2 collapsed vs king (same mechanism as earner RL class).
Not a confirm candidate. Pod `mine-f40-1` torn down same pass.

## Ops note (p533)

Live retry was misnamed `*_d203first` but hashes were a/b/c203 with MAX=3 (on last attempt @70/80).
Armed `retry_h135_n80_d203first_p533.sh` (real d203-first, MAX=5, nested FP guard) + patched
`relaunch_chall_pass264.sh` before screen finished; attempt 3 completed cleanly.
