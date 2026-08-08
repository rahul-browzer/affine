# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H98/F1 | high | REINFORCE self-L1lift → m>+0.015 | **open** (bootstrap) |
| 2 | H97/F3 | high | r=256 breaks LoRA ceiling → m>+0.015 | **open** (bootstrap) |
| 3 | H93 | med | Tok-init r15 → m>0.04 | **open** (n80 ~65/80) |
| 4 | H91 | med | Tok-init r12 → m>0.04 | **open** (n80 ~54/80) |
| 5 | H94 | med | Tok-init r11 → m>0.04 | **open** (n80 ~46/80) |
| 6 | H95 | med | Tok-init r10 → m>0.04 | **open** (chall serve) |
| 7 | H96 | med | Tok-init r9 → m>0.04 | **open** (train) |
| — | H92…H1 | — | winner-zA / α / merges | **refuted** (see below) |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H98 / F1 — Direct RL on self-L1lift — open
- **Claim:** CE-on-harvested-z is the dead basin; REINFORCE with reward=
  `clip(lpθ(y|z)−lpθ(y|∅),±0.1)` on thought tokens can move S.
- **Status:** BOOTSTRAP on mine-f1-1. Screen bar +0.015 → CONFIRM k=4.
- `experiments/s4-h98-f1-rl-l1/`.

### H97 / F3 — LoRA r=256 ceiling break — open
- **Claim:** r≈18 cannot move Λ2; r=256/α512 Tok-init × winner-zA can (family F3).
- **Status:** BOOTSTRAP on mine-f3-1. Screen bar +0.015 → CONFIRM k=4.
- `experiments/s4-h97-f3-r256/`.

### H91 / H93 / H94 — Tok-init r12/r15/r11 — open (draining)
- Winner-zA cells; retire on resolve; **do not** launch more r-neighbours.
- n80 ~54/65/46 of 80. mid304 armed.

### H95 / H96 — Tok-init r10/r9 — open (draining)
- H95: chall re-serve after SKIP_MERGE. H96: train. Retire-on-resolve.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Seed family queue (not yet rented)

| F | family | next |
|---|---|---|
| F2 | Target Λ2 not clip-L1 | scaffold+rent on next free slot / after H93 rm |
| F4 | Non-king base model | after F2 or parallel if slot free |
| F5 | Correctness-grounded z | needs verified trajectories first |
| F6 | Thought format/length axis | later |

## Refuted (keep)

### H92 — Tok-init × winner-zA @ r=13
- m=+0.000618 z=0.087 vs Tok. **r=13 dead.**

### H90 / H88 / H89 / H87 / H86 / H85
- r14 −0.0085; r30 +0.0014; r31 −0.0072; r29 +0.0051; r28 −0.0003; r27 −0.0082.

### H83 / H84 / H82 / H81 / H80 / H79 / H77 / H76 / H78
- r25…r17 / m7×r17–21 all dead vs Tok (best H81 +0.0088 <0.015).

### H75…H1
- See archive + LESSONS. Dead: α-merge / plmk / leary / TP×ks / m7×ks /
  m7×union / lr micro / ep≥2 / **winner-zA as a family (mean −0.004)** /
  r≤8∨=13∨=14∨=16–24∨≥32-as-cell / α≤8∨=16∨≥64 / clip≥0.08 / king-self.
  **F3 r=256 and F1 RL are new family screens, not neighbour cells.**
