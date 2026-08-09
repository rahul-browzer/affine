# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.
Pre-p440 refuted prose: `archive/HYPOTHESES-pre-p440.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H112/F17 | high | raw genesis (no LoRA) → m>+0.015 | **open** (n80 ~25) |
| 2 | H113/F18 | high | raw TalentPigs (no LoRA) → m>+0.015 | **open** (recover454) |
| 3 | H114/F19 | high | raw kevin954 (no LoRA) → m>+0.015 | **open** (n80 ~55) |
| 4 | H115/F20 | high | raw pandora (no LoRA) → m>+0.015 | **open** (n80 ~40) |
| 5 | H116/F21 | high | raw diane613 (no LoRA) → m>+0.015 | **open** (n80 started) |
| 6 | H117/F22 | high | raw everest12 (no LoRA) → m>+0.015 | **open** (bootstrap B300) |
| 7 | H118/F23 | high | raw Bittob (no LoRA) → m>+0.015 | **open** (bootstrap B300) |
| 8 | H119/F24 | high | raw af-k1 (no LoRA) → m>+0.015 | **open** (boot) |
| 9 | H111/F16 | high | af-k1 × high-Λ2 → m>+0.015 | **open** (teacher453) |
| — | H108/F13 | — | diane613 × high-Λ2 → m>+0.015 | **refuted** m=−0.07293 |
| — | H109/F14 | — | Bittob × high-Λ2 → m>+0.015 | **refuted** m=−0.05784 |
| — | H110/F15 | — | everest12 × high-Λ2 → m>+0.015 | **refuted** m=−0.08285 |
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
- Unmodified TalentPigs @dbfbb3e2 vs Tok → m>+0.015 (≠F10 LoRA). p454: teacher+chall shm hang → recover454 loading. `s4-h113-f18-raw-talentpigs/`.

### H114/F19 — raw kevin954 (no LoRA)
- Unmodified kevin954 @3fb79cfb vs Tok → m>+0.015 (≠F9 LoRA). n80 ~37/80. `s4-h114-f19-raw-kevin/`.

### H115/F20 — raw pandora (no LoRA)
- Unmodified pandora @5218b138 vs Tok → m>+0.015 (≠F11 LoRA). n80 ~19/80. `s4-h115-f20-raw-pandora/`.

### H116/F21 — raw diane613 (no LoRA)
- Unmodified diane613 @ad0f3f11 vs Tok → m>+0.015 (≠F13 LoRA). p453: recover452 → engines double-promptable; n80 d203 started 03:03Z. `s4-h116-f21-raw-diane/`.

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

### H108/F13 — diane613 × high-Λ2 — REFUTED
- diane613 @ad0f3f11 + high-Λ2 → m=**−0.07293** z=−6.59 S_c=−0.054≪S_k (p454). Tear mine-f13-1. `s4-h108-f13-diane613/`.

### H109/F14 — Bittob × high-Λ2 — REFUTED
- Bittob@0c04fe92 + high-Λ2 → m=**−0.05784** z=−5.91 S_c=−0.023≪S_k (p452). Tear mine-f14-1. `s4-h109-f14-bittob/`.

### H110/F15 — everest12 × high-Λ2 — REFUTED
- everest12@a5ac5311 + high-Λ2 → m=**−0.08285** z=−9.11 mean_λ2_c=−0.0229 (p452). Tear mine-f15-1. `s4-h110-f15-everest12/`.

### H111/F16 — af-k1 × high-Λ2
- af-k1 @ff6eb4bc + high-Λ2 → m>+0.015. p453: teacher Triton ENOENT mid-n80 → recover453 loading; retry 0/360. `s4-h111-f16-af-k1/`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. `experiments/s2-clip-l1-rank/`.

## Seed family queue
| F | family | next |
|---|---|---|
| F5 | Correctness-grounded z | needs verified traj |
| F17–F24 | raw no-LoRA screens | **screening** |
| F25 | next structural family | rent — 11 free slots |
| — | earner×high-Λ2 LoRA | F9–F15 dead; F16 open |

## Refuted (keep) — detail `archive/HYPOTHESES-pre-p440.md`

- **H108/F13** diane613 m=−0.07293 (p454) · **H109/F14** Bittob m=−0.05784 · **H110/F15** everest m=−0.08285 (p452)
- **H105/F10** TalentPigs m=−0.031 · **H106/F11** pandora m=−0.034 · **H107/F12** golden m=−0.059 · **H104/F9** kevin m=−0.014
- **H100/F4** Genesis×Λ2 m=−0.055 · **H102/F7** teacher-zC m=−0.052 · **H103/F8** Genesis-RL m=−0.048
- **H101/F6** ultrashort m=−0.005 · **H98/F1** Tok-RL m=+0.002 · **H97/F3** r256 m=−0.015
- **H96** winner-zA r9 m=+0.009 · **H99/F2** remix m=−0.002 · **H95…H1** α/winner-zA dead
- Screens live: **F16–F24**.
