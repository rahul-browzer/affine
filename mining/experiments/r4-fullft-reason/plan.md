# R4 — full-FT on Reason (Tok-init)

## Axis
Structurally distinct from R2 board-copies and R3 LoRA-GRPO.
Full-parameter SFT / FT on high-Reason winner thoughts (`winner_za_high_l1`)
so `z_A` raises teacher `lpC(y_C|z) − lpC(y_C|∅)`.

## Pod
`mine-r4-fullft-1` · 8×B300 preferred (@~$64/h) · TTL 24h
Rent via `wait_rent_b300.sh` (host poller). Cap 25 `mine-*`.

## Method
1. Rent 8×B300 (B200 only if B300 stock=0; replace when B300 appears).
2. Bootstrap: reuse `s4-h121-f26-full-ft` train_full + B300 flash patch +
   Tok af10 init + teacher for post-train n80.
3. Train full-FT → finalize non-identical → serve chall → n80 vs Tok.
4. Decision: submit only if margin ≥ **1.5 × (k_sigma·SE)** (live k=2.0).

## Decision rule (pre-register)
- hr < 0.5× → REFUTE; tear or retarget hyperparams
- 0.5× ≤ hr < 1.5× → WEAK_SKIP
- hr ≥ 1.5× fresh slice → Stage 5
