# H135 / F40 — kevin954 REINFORCE on teacher Λ2 (family screen)

## Family
**F40**: Past-earner kevin954-init LoRA trained by REINFORCE with reward =
teacher `Λ2 = lpC(y|z) − lpC(y|∅)`. F9 kevin×high-Λ2 SFT refuted (m=−0.014);
F30 kevin full-FT SFT refuted (m=−0.019); F37 is the same reward on Tok.
This is the F37 method on a different earner base — not past-king FT/raw.

## Claim
kevin954 @6a5815fa init LoRA + online teacher-Λ2 reward beats Tok by screen
margin >+0.015. Kevin earned reign-2; teacher feedback can move Λ2 where
CE imitation on kevin could not.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Method
1. Serve teacher on GPUs 0,1 before train; policy LoRA on GPUs 6,7.
2. Train base = kevin954/Affine-5dfqbbh8ev-sft @6a5815fa; n80 king = Tok.
3. Data: prefixes + teacher `y` from `winner_za_high_l1.jsonl` (x only).
4. LoRA r=16/α32 lr=5e-6 G=2 max_new=256 max_steps=200.
5. Reward: teacher force-echo Λ2; advantage = r − mean(r) in group.
6. Merge → n80 vs Tok.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f40-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural: F37 reward × kevin earner base. Isolates whether F9/F30 failed
because of CE imitation (not the kevin base). Orthogonal to Tok/Genesis RL
screens and to the closed past-king FT/raw class.
