# s4-h2-merge — result (α=0.5)

## Verdict (α=0.5 kevin×pandora)

**H2 α=0.5 does not beat kevin.** Paired margin **−0.00996** (z=−1.30).
Both sides gate-valid; H4 envelope OK. Per `plan.md`: try **α=0.65** next;
refute H2 for these parents only if α=0.65 also has margin < 0.02.

| metric | king (kevin) | challenger (h2-kp50) |
|---|---|---|
| S | 0.028880 | **0.018924** |
| valid | true | true |
| gate_pass_rate | 0.928 | 0.872 |
| bank_frac | 0.581 | 0.588 |
| calib_ratio r | 0.789 | **0.822** (H4 OK) |
| baseline_abs | 0.1425 | 0.1194 |
| base× (chal/king) | — | **0.837** (≪1.25; H4 OK) |
| mean_λ2 | +0.00359 | **−0.00166** |

| duel | value |
|---|---|
| margin | **−0.009955** |
| se | 0.007665 |
| z | −1.299 |
| n_paired | 80 |
| challenger_wins | false |
| elapsed_s | 2510 |

Raw: `results/h2_kp50_sim_result.json` (+ artifact sidecar).

## Interpretation

Gates/H4 are fine — failure is ranking, not hygiene. Challenger mean_λ2
went negative while kevin stayed slightly positive; mix S dropped ~0.010.
Equal-weight merge diluted teacher-aligned thoughts rather than combining
strengths. α=0.65 (more kevin) is the pre-registered second recipe.

## Decision (applied)

- [x] α=0.5 margin < 0.02 → **do not submit**; launch α=0.65
- [ ] α=0.65 pending (`/root/merges/h2-kp65`, then re-serve + sim)
- Submit gate (>0.04) not approached

## Next

1. Finish α=0.65 merge on `mine-sim-1`
2. `MERGE=/root/merges/h2-kp65` → `restart_for_h2.sh` → `run_sim_duel.py`
3. If margin still < 0.02 → refute H2 for kevin×pandora; pivot to H1 SFT
