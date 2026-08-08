# H102 / F7 — Teacher z_C SFT on Genesis (family screen)

## Family
**F7**: frontier teacher thoughts (`z_C` from published `teacher_refs`), not
harvested challenger `z_A`. King-init plain distill-on-refs is already dead
(H5c/H6; LESSONS). F7 pairs teacher z_C with **Genesis** init so Λ2 can move
(base-model property) — orthogonal to F4 (Genesis × high-Λ2 z_A).

## Claim
`dendriteholdings/albedo-qwen3.6-35b-king-genesis` @ `abe89194…` init,
thought-only LoRA r=16/α32 lr=5e-6 1ep on **791** `teacher_refs_shortz`
(z≤250) → screen margin >+0.015 vs Tok331102.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Method
1. Data: `s4-h5c-expand-refs/results/teacher_refs_shortz.jsonl` (791).
2. Genesis init; train GPUs 6,7; merge → n80 vs Tok (same stack as F4).
3. Pod `mine-f7-1`.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f7-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any shortz/expanded sweep.
- m>0.04 + gates → Stage 5 shortlist.
