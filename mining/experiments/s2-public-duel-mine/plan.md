# s2-public-duel-mine — plan

**Stage:** 2 (cheap hypotheses from public data; no GPU)  
**UTC opened:** 2026-08-06T22:50Z

## Hypothesis under test

Public duel artifacts contain enough signal to (a) settle H3 (Λ2 vs clip-L1
drivers of margin) and (b) rank H1/H2/… by expected α per dollar before any
rental.

## Method

1. Pull `evals/index.jsonl` (38 duels as of this pass).
2. Download a stratified sample of `evals/*.json.gz`:
   - retroactive crowns (kevin, pandora-m4) + near-crown under current knobs
   - best published positive margins that still lost
   - recent losses vs live king kevin
   - gate / baseline failures
3. Recompute each under current knobs via `affine.affine.score` (read-only).
4. Per duel: mean Λ2, mean clip(L1), r, baseline×, bank, paired ΔΛ2 / ΔclipL1.
5. Spearman(d_mix, d_clip_l1) vs Spearman(d_mix, d_Λ2) for H3.

## Pre-registered decision rules

- **H3 supported** if |ρ(d_mix, d_clip_l1)| > |ρ(d_mix, d_Λ2)| on valid duels
  and mean |d_clip_l1| ≥ mean |d_Λ2|.
- **Stage 2 gate met** when `HYPOTHESES.md` has a ranked list with predicted
  ΔS written before any `lium up`.

## Out of scope this pass

No GPU, no pods, no training, no submit.
