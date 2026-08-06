# HYPOTHESES — falsifiable claims

One entry per hypothesis. Keep refuted entries. Rank by expected α per dollar once Stage 2 opens.

## Open (Stage 2 candidates — not yet ranked; need public-duel mining first)

### H0 — scaffolding / no claim yet
- **Claim:** n/a (placeholder while Stage 0–1 finish).
- **Status:** scaffolding only.

### H1 — teacher-ref SFT beats the king (prior art)
- **Claim:** SFT / distill on published `teacher_refs` (z_C, y_C) from duel records raises S enough to clear margin > 0.04 vs current king, because reigns 1–2 look like teacher-distill / SFT lineages (`pandora-box …ckpt300-m4`, `kevin954 …-sft`).
- **Experiment:** Stage 4 local duel sim after Stage 3 gate.
- **Prediction (pre-register before train):** challenger mean S ≥ king S + 0.04 on an 80-turn public-D slice with all gates passing.
- **Verdict:** open.

### H2 — weight-merge of recent kings beats both
- **Claim:** A linear / SLERP merge of `kevin954/…-sft` and `pandora-box/…ckpt300-m4` (or other earning reign members) yields S > max(parents) at near-zero train cost.
- **Experiment:** merge on a `mine-merge-*` pod; score in Stage 3 simulator.
- **Prediction:** merge margin over king > 0.02 (noise floor) on first try; often > 0.04.
- **Verdict:** open.

### H3 — L1lift is the cheap lever once Λ2 is near king
- **Claim:** After thoughts are teacher-like enough for Λ2≈king, most remaining crown margin comes from clipped L1lift (cap ±0.1/turn ⇒ max +0.1 mean contribution).
- **Experiment:** Stage 2 decomposition of published winning/losing pairs: fraction of per-turn rank_term from Λ2 vs clip(L1).
- **Prediction:** among near-king challengers, ΔS correlates more with Δ mean clip(L1) than ΔΛ2.
- **Verdict:** open — settle in Stage 2.

## Refuted

*(none yet)*
