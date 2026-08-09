# H133 / F38 — Genesis REINFORCE on teacher Λ2 (family screen)

## Family
**F38**: Cross of F8's non-king Genesis init with F37's teacher-Λ2 reward.
F8 Genesis×self-L1 REFUTED (m=−0.0483). F37 Tok×teacher-Λ2 is live (king-init
Λ2-frozen). This family keeps the teacher-Λ2 reward and moves the base off the
king so Λ2 can actually move.

## Claim
Genesis @abe89194 init LoRA trained by REINFORCE with reward =
`Λ2 = lpC(y|z) − lpC(y|∅)` from live teacher beats Tok by screen margin >+0.015.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Method
1. Serve teacher on GPUs 0,1 before train; policy LoRA on GPUs 6,7; Genesis base.
2. Data: prefixes + teacher `y` from `winner_za_high_l1.jsonl` (x only).
3. LoRA r=16/α32 lr=5e-6 G=2 max_new=256 max_steps=200.
4. Reward: teacher force-echo Λ2; advantage = r − mean(r) in group.
5. Merge → n80 vs Tok (king DL parallel during train).

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f38-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural: non-king base (Λ2 free) × online teacher-Λ2 reward. Orthogonal to
F37 (Tok base) and F8 (self-L1 reward). Not past-king FT / not raw past-earner.
