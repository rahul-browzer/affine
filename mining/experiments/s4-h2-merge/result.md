# s4-h2-merge — result (H2 kevin×pandora REFUTED)

## Final verdict

**H2 refuted for these parents.** Both pre-registered recipes missed the
0.02 margin bar (submit gate 0.04 never approached). Pivot to **H1**
teacher-ref SFT from kevin init.

| recipe | margin | z | chall S | king S | mean_λ2 chal | r | base× | valid |
|---|---|---|---|---|---|---|---|---|
| α=0.5 | **−0.00996** | −1.30 | 0.0189 | 0.0289 | −0.00166 | 0.822 | 0.837 | both |
| α=0.65 | **+0.00725** | +0.92 | 0.0260 | 0.0187 | +0.00105 | 0.806 | 0.879 | both |

Decision rule (`plan.md`): margin < 0.02 after α∈{0.5, 0.65} → **refute**.

---

## α=0.65 detail (2026-08-07T01:37Z)

| metric | king (kevin) | challenger (h2-kp65) |
|---|---|---|
| S | 0.018725 | **0.025975** |
| valid | true | true |
| gate_pass_rate | 0.947 | 0.878 |
| bank_frac | 0.575 | 0.591 |
| calib_ratio r | 0.833 | **0.806** (H4 OK) |
| baseline_abs | 0.1415 | 0.1245 |
| base× (chal/king) | — | **0.879** (≪1.25; H4 OK) |
| mean_λ2 | −0.00556 | **+0.00105** |

| duel | value |
|---|---|
| margin | **+0.007250** |
| se | 0.007916 |
| z | +0.916 |
| n_paired | 80 |
| challenger_wins | false (need margin>0.02 and >3·SE) |
| elapsed_s | 2515 |
| slice digest | `2eddacc205573601eb03a34bc4820df99e1058e07983859cf1c982166dea3d46` |

Raw: `results/h2_kp65_sim_result.json` (+ `h2_kp65_sim_result_artifact.json`).
Merge meta: `results/h2_kp65_merge_meta.json`.

---

## α=0.5 detail (earlier)

| duel | value |
|---|---|
| margin | **−0.009955** |
| z | −1.299 |
| chall S / king S | 0.0189 / 0.0289 |
| r / base× | 0.822 / 0.837 |

Raw: `results/h2_kp50_sim_result.json`.

---

## Interpretation

- Gates/H4 never the failure mode — ranking was.
- α=0.65 (more kevin) flipped sign vs α=0.5 (+0.007 vs −0.010) and
  restored positive mean_λ2, but effect is still noise-floor scale
  (3·SE≈0.024; δ=0.02). Not a crown path.
- Linear weight-space mix of these two distill kings does not compound
  their S; do not burn a slot on either recipe.
- Keep `mine-sim-1` engines hot for H1 SFT + re-sim (TTL 04:53Z).

## Decision (applied)

- [x] α=0.5 margin < 0.02 → try α=0.65
- [x] α=0.65 margin < 0.02 → **refute H2** for kevin×pandora
- [x] Do **not** submit; do **not** publish merge to HF
- [ ] Next experiment: `experiments/s4-h1-sft/` (teacher-ref SFT)
