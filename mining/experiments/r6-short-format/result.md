# R6 short-z — result

**REFUTED** pass 2143 · 2026-08-12T00:24:59Z · pod `mine-r4-fullft-1`

| metric | value |
|---|---|
| margin | −0.000618 |
| SE | 0.008822 |
| z | −0.070 |
| k_sigma | 2.0 |
| headroom vs 2·SE | −0.035× |
| n_paired | 77/80 |
| chall mean Reason | −0.00235 |
| king mean Reason | −0.00353 |
| chall mean_len_z | 337 |
| king mean_len_z | 499 |

Tok-init thought-only LoRA on short≤180 natural z (n=121 train keep after mask) does not beat live king under Reason v3. Stage-5 SKIP.

Artifacts: `artifacts/r6_refute_p2143.json`, `h101_decision_p2143.json`, `h101_sim_result_p2143.json`.

Follow-up: **R6b** long-z (z>180) armed same pod p2143.
