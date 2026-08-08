# H97 / F3 result — REFUTE (r=256 LoRA ceiling)

UTC: 2026-08-08T20:49:35Z
Pod: mine-f3-1 (noble-raven-ff)
Slice: block_hash a203…0001 · n=80 · king Tok331102@eb8bf9a

| metric | value |
|---|---|
| margin | **-0.015058** |
| z | -1.84 |
| SE | 0.008177 |
| S_c / S_k | 0.03247 / 0.04512 |
| r_c | 0.725 |
| valid_c / valid_k | True / True |
| mean_λ2_c / λ2_k | -0.00013 / +0.00120 |
| gate_pass_c | 0.791 |
| bank_c | 0.520 |
| baseline_abs_c / k | 0.141 / 0.158 (band OK) |

**Decision:** REFUTE_H97 / F3. m=-0.0151 ≤ 0.
r=256/α512 Tok-init LoRA did **not** move Λ2 (chall λ2≈0, still below king).
LoRA-rank ceiling-break family closed. Pod torn down pass 374.
