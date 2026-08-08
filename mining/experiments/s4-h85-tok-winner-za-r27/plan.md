# H85 — Tok-init × winner-zA @ LoRA r=27

## Claim
Tok-init (Tok331102@eb8bf9a) × winner-zA shaping at LoRA r=27/α32 lr=5e-6
clears live king Tok331102 → paired n80 margin > 0.04.

## Why
H80 Tok-init@r17 REFUTE (m=−0.000821). Tok-init r17/r18 dead; m7 ranks 16–21/24
dead. Open axis still Tok-init at untested ranks. r=27 ≥3 from shortlist/live
neighbors, not in dead set {≤8,16–21,24,≥32}∪{Tok-init r17,r18}.

## Decision rule
- REFUTE if margin ≤ 0 or gate fail
- SHORTLIST if 0.015 < m ≤ 0.04 (replicate)
- SUBMIT-ready if m > 0.04 and gates pass
