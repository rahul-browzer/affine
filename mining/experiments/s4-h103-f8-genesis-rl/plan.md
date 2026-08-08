# H103 / F8 — Genesis-init REINFORCE on self-L1lift (family screen)

## Family
**F8**: F1's RL recipe (REINFORCE on clip self-L1lift) on **Genesis** init.
F1 is Tok-init RL (Λ2 frozen by king-base); F4 is Genesis×SFT. F8 crosses
both axes — non-king base (Λ2 can move) + direct L1lift shaping (not CE).

## Claim
Genesis @abe89194 init LoRA REINFORCE with reward=`clip(self L1lift,±0.1)`
on 406 winner-zA prefixes → screen margin >+0.015 vs Tok331102.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Method
Same as H98/F1 (`train_rl_l1.py`) but `--base` = Genesis. Merge → n80 vs Tok.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f8-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before sweep.
- m>0.04 + gates → Stage 5 shortlist.
