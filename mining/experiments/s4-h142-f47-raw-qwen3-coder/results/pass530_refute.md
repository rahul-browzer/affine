# H142/F47 n80 REFUTE — pass 530

UTC: 2026-08-09T11:24:33Z
Pod: mine-f47-1 (golden-matrix-bb) — torn down after decision.
Slice: block_hash=`f203…006` n=80 vs Tok331102@eb8bf9a.

| side | valid | S / mean_mix | λ2 | r | baseline_abs | bank | gate_pass |
|---|---|---|---|---|---|---|---|
| king | true | 0.03591 | −0.00141 | 0.653 | 0.13433 | 0.438 | 0.771 |
| chall (raw Qwen3-Coder) | **false** | (0.02689) | −0.00456 | 0.788 | **0.30137** | 0.456 | 0.729 |

- `baseline_band_exceeded=true`; base_x = 0.30137/0.13433 = **2.244×** ≫ 1.25
- margin=0 / z=0 (invalid chall); decision `REFUTE_H142`
- Even ungated mean_mix would lose (0.027 < 0.036); λ2 also worse
- Mechanism: non-Albedo base → empty-baseline sabotage-shaped prior; band gate kills before ranking
- Artifacts: `h142_sim_result.json`, `h142_decision.json`
