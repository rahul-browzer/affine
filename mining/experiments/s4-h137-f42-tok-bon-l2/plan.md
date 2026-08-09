# H137 / F42 — Tok Best-of-N CE on teacher Λ2 (family screen)

## Family
**F42**: Offline-style Best-of-N imitation of high teacher-Λ2 thoughts.
F37 screens the same reward under REINFORCE (advantage×logp). F42 keeps
Tok init + teacher Λ2 scoring but **only CEs the argmax of G=4 samples**.
Not past-king FT/raw; not another CE-on-harvested-z earner cell.

## Claim
Selecting the high-Λ2 mode each step and imitating it moves mean Λ2 (hence
paired margin vs Tok) more than REINFORCE with G=2, where advantages often
vanish when group rewards are close. Screen margin >+0.015.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Method
1. Serve teacher on GPUs 0,1 before train; policy LoRA on GPUs 6,7.
2. Data: prefixes + teacher `y` from `winner_za_high_l1.jsonl` (x only).
3. LoRA r=16/α32 lr=5e-6 G=4 max_new=256 max_steps=150.
4. Per step: sample G=4 z, score teacher Λ2, CE on argmax z only.
5. Merge → n80 vs Tok.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f42-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural loss change vs F37: winner-take-all CE vs mean-baseline PG.
Same reward signal, different update — can move the mean independently of
whether F37 REINFORCE lands.
