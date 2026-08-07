# s4-h20-tp-leary-a90 — H20

**Hypothesis:** H15 TalentPigs×leary α0.75 INVALID base×2.107 even though
parent chal-00315 was healthy base×≈1.017. α=0.90 (10% leary) is the band
hedge (same pattern as H16/H17/H19).

**B parent:** `leary-criste/affine-5g4yy75zuz-test` @
`1e6d6d02ebe771b767c5d2bfaf3c0a1538605fc3` (exact chal-00315 rev).

## Prediction (pre-register BEFORE rent)

- α=0.90 (`out = 0.90·TalentPigs + 0.10·leary`)
- n80: base×≤1.25 and paired margin ≥ **+0.04** vs live TalentPigs
- If gate-valid and 0.02≤m≤0.04 → TRY_ALPHA_095
- If INVALID band or m<0.02 → refute; abandon leary merges

## Method

1. Rent `mine-h20-1` 8×H200 `--ttl 8h` after H15 rm.
2. bootstrap → merge → serve_three → n80; nested decision writer.

## Decision rule

- margin > 0.04 + gates OK → Stage 5 prep.
- else refute; tear `mine-h20-1` only. No submit.
