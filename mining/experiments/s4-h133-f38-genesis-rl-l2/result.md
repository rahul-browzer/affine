# H133 / F38 — Genesis REINFORCE teacher-Λ2 — RESULT

**Verdict: REFUTE** (pass 526)

| field | value |
|---|---|
| pod | mine-f38-1 / golden-eagle-8b |
| slice | a203…0001 · n=80 |
| margin | **−0.05342** |
| se / z | 0.01007 / **−5.30** |
| S_c / S_k | −0.02097 / 0.03264 |
| λ2_c / λ2_k | **−0.01754** / −0.00242 |
| r_c / base_x | 1.030 / 0.907 |
| gates | both valid (pass 0.66/0.80, bank 0.40/0.46) |
| decision | `REFUTE_H133` (write_merge_decision nested) |

Same mechanism as F4/F7/F17 Genesis class: leaving Tok-init collapses Λ2
(λ2_c −0.018 vs king −0.002) → margin −0.053. Gates clear; lose on ranking.
Do not retry Genesis-init RL-Λ2 cells. Pod torn down pass 526; no replace.
Artifacts: `results/h133_decision.json`, `results/h133_sim_result.json`.
