# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.
Pre-p440 refuted prose: `archive/HYPOTHESES-pre-p440.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H122/F27 | high | Genesis full-FT → m>+0.015 | **open** (**n80 running**) |
| 2 | H123/F28 | high | Tok full-FT × teacher_refs → m>+0.015 | **open** (king332 recover) |
| 3 | H121/F26 | high | Tok full-FT (not LoRA) → m>+0.015 | **open** (chall264 recover) |
| 4 | H124/F29 | high | golden full-FT → m>+0.015 | **open** (serve) |
| 5 | H125/F30 | high | kevin full-FT → m>+0.015 | **open** (serve) |
| 6 | H126/F31 | high | Bittob full-FT → m>+0.015 | **open** (serve→n80) |
| 7 | H127/F32 | high | TalentPigs full-FT → m>+0.015 | **open** (ckpt-60 save) |
| 8 | H128/F33 | high | pandora full-FT → m>+0.015 | **open** (train p474) |
| 9 | H129/F34 | high | diane full-FT → m>+0.015 | **open** (train p474) |
| 10 | H130/F35 | high | everest full-FT → m>+0.015 | **open** (train p474) |
| 11 | H117/F22 | high | raw everest12 (no LoRA) → m>+0.015 | **open** (Tok ~92%) |
| — | H118/F23 | — | raw Bittob (no LoRA) → m>+0.015 | **refuted** m=−0.08436 |
| — | H120/F25 | — | raw golden-crown (no LoRA) → m>+0.015 | **refuted** m=−0.06343 |
| — | H112/F17 | — | raw genesis (no LoRA) → m>+0.015 | **refuted** m=−0.05489 |
| — | H113/F18 | — | raw TalentPigs (no LoRA) → m>+0.015 | **refuted** m=−0.03010 |
| — | H111/F16 | — | af-k1 × high-Λ2 → m>+0.015 | **refuted** m=−0.07623 |
| — | H119/F24 | — | raw af-k1 (no LoRA) → m>+0.015 | **refuted** m=−0.08673 |
| — | H116/F21 | — | raw diane613 (no LoRA) → m>+0.015 | **refuted** m=−0.07226 |
| — | H115/F20 | — | raw pandora (no LoRA) → m>+0.015 | **refuted** m=−0.02975 |
| — | H114/F19 | — | raw kevin954 (no LoRA) → m>+0.015 | **refuted** m=−0.00611 |
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

### H122/F27 — Genesis full-FT (no LoRA)
- Dense FT genesis@abe89194 × 1059 high-Λ2 z_A lr=1e-6 → m>+0.015 vs Tok.
- mine-f27-1 **n80 running** d203 (p475). `s4-h122-f27-genesis-full-ft/`.

### H123/F28 — Tok full-FT × teacher_refs z_C
- Dense FT Tok × 791 teacher_refs_shortz lr=1e-6 → m>+0.015 vs Tok.
- mine-f28-1 king EngineDead@~1/80 → king332 recover (p475). `s4-h123-f28-teacher-refs-ft/`.

### H121/F26 — Tok full-FT (no LoRA)
- Dense FT Tok@eb8bf9a × 1059 high-Λ2 z_A lr=1e-6 → m>+0.015.
- mine-f26-1 bare-TCACHE ENOENT → chall264 (p475). `s4-h121-f26-full-ft/`.

### H124/F29 — golden-crown full-FT × high-Λ2 z_A
- Dense FT golden@ee37f4f0 × 1059 high-Λ2 z_A lr=1e-6 → m>+0.015 vs Tok.
- mine-f29-1 /tmp finalize+serve (pod MERGED was /root; fixed p474). `s4-h124-f29-golden-full-ft/`.

### H125/F30 — kevin954 full-FT × high-Λ2 z_A
- Dense FT kevin@3fb79cfb × 1059 high-Λ2 z_A lr=1e-6 → m>+0.015 vs Tok.
- mine-f30-1 /tmp finalize+serve (p474). `s4-h125-f30-kevin-full-ft/`.

### H126/F31 — Bittob11040 full-FT × high-Λ2 z_A
- Dense FT Bittob@0c04fe92 × 1059 high-Λ2 z_A lr=1e-6 → m>+0.015 vs Tok.
- mine-f31-1 finalize+/tmp serve launched (p475). `s4-h126-f31-bittob-full-ft/`.

### H127/F32 — TalentPigs full-FT × high-Λ2 z_A
- Dense FT TalentPigs@dbfbb3e2 × 1059 high-Λ2 z_A lr=1e-6 → m>+0.015 vs Tok.
- mine-f32-1 ckpt-60 present; train/save→post_train /tmp. `s4-h127-f32-talentpigs-full-ft/`.

### H128/F33 — pandora-box full-FT × high-Λ2 z_A
- Dense FT pandora@5218b138 × 1059 high-Λ2 z_A lr=1e-6 → m>+0.015 vs Tok.
- mine-f33-1 train relaunched after tf33→tf32 (p474). `s4-h128-f33-pandora-full-ft/`.

### H129/F34 — diane613 full-FT × high-Λ2 z_A
- Dense FT diane@ad0f3f11 × 1059 high-Λ2 z_A lr=1e-6 → m>+0.015 vs Tok.
- mine-f34-1 train relaunched after tf34→tf32 (p474). `s4-h129-f34-diane-full-ft/`.

### H130/F35 — everest12 full-FT × high-Λ2 z_A
- Dense FT everest@a5ac5311 × 1059 high-Λ2 z_A lr=1e-6 → m>+0.015 vs Tok.
- mine-f35-1 train relaunched after tf35→tf32 (p474). `s4-h130-f35-everest-full-ft/`.

### H117/F22 — raw everest12 (no LoRA)
- Unmodified everest12 @a5ac5311 vs Tok → m>+0.015. Tok Range ~92%. `s4-h117-f22-raw-everest12/`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. `experiments/s2-clip-l1-rank/`.

## Seed family queue
| F | family | next |
|---|---|---|
| F5 | Correctness-grounded z | needs verified traj |
| F22/F26–F35 | screens | **live** (11 pods) |
| — | earner×high-Λ2 LoRA | **CLOSED** F9–F16 all ≤0 |
| — | raw past-earner/genesis | **CLOSED** kevin/pandora/diane/af-k1/TalentPigs/genesis/golden/**Bittob** (everest open) |

## Refuted (keep) — detail `archive/HYPOTHESES-pre-p440.md`

- **H118/F23** raw Bittob m=−0.08436 · **H120/F25** raw golden m=−0.06343
- **H112/F17** raw genesis m=−0.05489 · **H113/F18** raw TalentPigs m=−0.03010
- **H111/F16** af-k1×Λ2 m=−0.07623 · **H119/F24** raw af-k1 m=−0.08673
- **H116/F21** raw diane m=−0.07226 · **H115/F20** raw pandora m=−0.02975
- **H114/F19** raw kevin m=−0.00611 · **H108–H110/F13–F15** earner×Λ2
- **H105/F10** TalentPigs-LoRA · **H106–H107/F11–F12** · **H104/F9**
- **H100/F4** · **H102/F7** · **H103/F8** · **H101/F6** · **H98/F1** · **H97/F3**
- Screens live: **F22,F26–F35**. Next free slot: af-k1 dense-FT or **F5**.
