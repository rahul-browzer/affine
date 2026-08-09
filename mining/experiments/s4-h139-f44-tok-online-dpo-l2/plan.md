# H139 / F44 — Tok online DPO on teacher-Λ2 (family screen)

## Family
**F44**: Online preference optimization. Sample G=2 thoughts from the live
Tok-init LoRA policy, label with teacher Λ2, DPO (β=0.1) vs frozen base
(adapters off). Needs live teacher at train — unlike F43 offline duel prefs.
Not REINFORCE (F37) and not BoN-CE (F42): BT preference on an on-policy pair.

## Claim
Preference updates on self-sampled teacher-Λ2 gaps move mean Λ2 (hence paired
margin vs Tok) where unidirectional CE/PG on the same reward may stall.
Screen margin >+0.015.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Method
1. Serve teacher on GPUs 0,1; policy LoRA on GPUs 6,7.
2. Data: prefixes + teacher `y` from `winner_za_high_l1.jsonl` (x only).
3. LoRA r=16/α32 lr=5e-6 β=0.1 G=2 max_new=256 max_steps=150 min_gap=0.005.
4. Per step: sample 2 z, score teacher Λ2, DPO on (chosen,rejected) if gap≥min.
5. Merge → n80 vs Tok.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f44-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Loss class: online BT/DPO vs offline DPO (F43), REINFORCE (F37), BoN-CE (F42).
On-policy preference pairs with live teacher labels — independent of whether
offline duel prefs or PG land.
