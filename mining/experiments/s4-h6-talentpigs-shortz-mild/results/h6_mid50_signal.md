# H6 mid50 n40 — SIGNAL only (not authoritative)

UTC: 2026-08-07T12:58:13Z · `signal_only: true` · final n80 still load-bearing.

| metric | value |
|---|---|
| decision | **SIGNAL_NEG** |
| margin | **−0.00566** (z=−0.636, SE=0.00890, n_paired=39) |
| S_c / S_k | 0.01834 / 0.02415 |
| chall valid | true · r=0.771 · base×0.960 · bank 0.519 · pass 0.822 |
| mean_Λ2 c/k | −0.00857 / −0.00483 |

Gate released `sim_out` @12:57:56Z; post_train SIGCONT → final merge served on :8002.
No teardown. No α0.85 path (margin < 0.02). Final n80 decides H6.
