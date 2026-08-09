# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.
Pre-p440 refuted prose: `archive/HYPOTHESES-pre-p440.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H112/F17 | high | raw genesis (no LoRA) → m>+0.015 | **open** (n80 ~1/80) |
| 2 | H113/F18 | high | raw TalentPigs (no LoRA) → m>+0.015 | **open** (king only) |
| 3 | H114/F19 | high | raw kevin954 (no LoRA) → m>+0.015 | **open** (n80 ~37/80) |
| 4 | H115/F20 | high | raw pandora (no LoRA) → m>+0.015 | **open** (n80 ~19/80) |
| 5 | H116/F21 | high | raw diane613 (no LoRA) → m>+0.015 | **open** (k/c down) |
| 6 | H117/F22 | high | raw everest12 (no LoRA) → m>+0.015 | **open** (bootstrap B300) |
| 7 | H118/F23 | high | raw Bittob (no LoRA) → m>+0.015 | **open** (bootstrap B300) |
| 8 | H119/F24 | high | raw af-k1 (no LoRA) → m>+0.015 | **open** (boot) |
| 9 | H108/F13 | high | diane613 × high-Λ2 → m>+0.015 | **open** (n80 ~53) |
| 10 | H109/F14 | high | Bittob11040 × high-Λ2 → m>+0.015 | **open** (n80 ~62) |
| 11 | H110/F15 | high | everest12 × high-Λ2 → m>+0.015 | **open** (n80 ~61) |
| 12 | H111/F16 | high | af-k1 × high-Λ2 → m>+0.015 | **open** (tchr000) |
| — | H105/F10 | — | TalentPigs × high-Λ2 → m>+0.015 | **refuted** m=−0.03095 |
| — | H106/F11 | — | pandora × high-Λ2 → m>+0.015 | **refuted** m=−0.03414 |
| — | H107/F12 | — | golden-crown × high-Λ2 → m>+0.015 | **refuted** m=−0.05941 |
| — | H104/F9 | — | kevin954 × high-Λ2 → m>+0.015 | **refuted** m=−0.01417 |
| — | H100/F4 | — | Genesis-init × high-Λ2 → m>+0.015 | **refuted** m=−0.05488 |
| — | H102/F7 | — | Genesis × teacher z_C → m>+0.015 | **refuted** m=−0.05194 |
| — | H103/F8 | — | Genesis-init × REINFORCE-L1 → m>+0.015 | **refuted** m=−0.04829 |
| — | H101/F6 | — | ultrashort≤80 format → m>+0.015 | **refuted** m=−0.00453 |
| — | H98/F1 | — | Tok REINFORCE self-L1lift → m>+0.015 | **refuted** m=+0.00229 |
| — | H97/F3 | — | r=256 breaks LoRA ceiling | **refuted** m=−0.01506 |
| — | H96 | — | Tok-init r9 → m>0.04 | **refuted** m=+0.00913 |
| — | H99/F2 | — | high-Λ2 z_A SFT → m>+0.015 | **refuted** m=−0.00199 |
| — | H95…H1 | — | winner-zA / α / merges | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

## Open

### H112/F17 — raw genesis (no LoRA)
- Unmodified genesis @abe89194 vs Tok → m>+0.015. p450: n80 relaunched post king449; ~1/80. `s4-h112-f17-raw-genesis/`.

### H113/F18 — raw TalentPigs (no LoRA)
- Unmodified TalentPigs @dbfbb3e2 vs Tok → m>+0.015 (≠F10 LoRA). King :8001 only. `s4-h113-f18-raw-talentpigs/`.

### H114/F19 — raw kevin954 (no LoRA)
- Unmodified kevin954 @3fb79cfb vs Tok → m>+0.015 (≠F9 LoRA). n80 ~37/80. `s4-h114-f19-raw-kevin/`.

### H115/F20 — raw pandora (no LoRA)
- Unmodified pandora @5218b138 vs Tok → m>+0.015 (≠F11 LoRA). n80 ~19/80. `s4-h115-f20-raw-pandora/`.

### H116/F21 — raw diane613 (no LoRA)
- Unmodified diane613 @ad0f3f11 vs Tok → m>+0.015 (≠F13 LoRA). p450: health 200/000/000 — king+chall down. `s4-h116-f21-raw-diane/`.

### H117/F22 — raw everest12 (no LoRA)
- Unmodified everest12 @a5ac5311 vs Tok → m>+0.015 (≠F15 LoRA). Bootstrap on B300. `s4-h117-f22-raw-everest12/`.

### H118/F23 — raw Bittob11040 (no LoRA)
- Unmodified Bittob @0c04fe92 vs Tok → m>+0.015 (≠F14 LoRA). Bootstrap on B300. `s4-h118-f23-raw-bittob/`.

### H119/F24 — raw af-k1 (no LoRA)
- Unmodified af-k1 @ff6eb4bc vs Tok → m>+0.015 (≠F16 LoRA). p451: mine-f24-1 boot. `s4-h119-f24-raw-af-k1/`.

### H105/F10 — TalentPigs × high-Λ2 — REFUTED
- TalentPigs + high-Λ2 → m=**−0.03095** z=−3.20 mean_λ2_c=−0.0176 (p450). Tear mine-f10-1. `s4-h105-f10-talentpigs-base/`.

### H106/F11 — pandora × high-Λ2 — REFUTED
- pandora @5218b138 + high-Λ2 → m=**−0.03414** z=−5.06 S_c=0.0049≪S_k (p448). Tear mine-f11-1. `s4-h106-f11-pandora-base/`.

### H108/F13 — diane613 × high-Λ2
- diane613 @ad0f3f11 + high-Λ2 → m>+0.015. n80 ~53. `s4-h108-f13-diane613/`.

### H109/F14 — Bittob × high-Λ2
- Bittob11040 @0c04fe92 + high-Λ2 → m>+0.015. n80 ~62. `s4-h109-f14-bittob/`.

### H110/F15 — everest12 × high-Λ2
- everest12 @a5ac5311 + high-Λ2 → m>+0.015. n80 ~61. `s4-h110-f15-everest12/`.

### H111/F16 — af-k1 × high-Λ2
- af-k1 @ff6eb4bc + high-Λ2 → m>+0.015. post_train; teacher :8000=000. `s4-h111-f16-af-k1/`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. `experiments/s2-clip-l1-rank/`.

## Seed family queue
| F | family | next |
|---|---|---|
| F5 | Correctness-grounded z | needs verified traj |
| F17–F24 | raw no-LoRA screens | **screening** (F24 rented p451) |
| F25 | next structural family | rent when slot/burn allows |
| — | earner×high-Λ2 LoRA | F9–F12 dead; F13–F16 still open |

## Refuted (keep) — detail `archive/HYPOTHESES-pre-p440.md`

- **H105/F10** TalentPigs×Λ2 m=−0.03095 · **H106/F11** pandora m=−0.034 · **H107/F12** golden m=−0.059 · **H104/F9** kevin m=−0.014
- **H100/F4** Genesis×Λ2 m=−0.05489 · **H102/F7** teacher-zC m=−0.05194
- **H103/F8** Genesis-RL m=−0.04829 · **H101/F6** ultrashort m=−0.00453
- **H98/F1** Tok-RL m=+0.00229 · **H97/F3** r256 m=−0.01506
- **H96** winner-zA r9 m=+0.00913 · **H99/F2** remix m=−0.00199
- **H95…H1** α/plmk/TP/m7/winner-zA (−0.004)/F1–F4/F6–F12 dead
- Screens live: **F13–F24**.
