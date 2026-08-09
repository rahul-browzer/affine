# H136 / F41 — TalentPigs REINFORCE on teacher Λ2 (family screen)

## Family
**F41**: Reign-3 earner TalentPigs-init LoRA trained by REINFORCE with reward =
teacher `Λ2 = lpC(y|z) − lpC(y|∅)`. F10 TalentPigs×high-Λ2 SFT, F18 raw, and
F32 full-FT all refuted (≤0). F37/F40 are the same reward on Tok/kevin —
this isolates the currently-earning reign-3 base under online teacher Λ2.

## Claim
TalentPigs/affine-5ekxlcg3fx-abc @dbfbb3e2 init LoRA + online teacher-Λ2
reward beats Tok by screen margin >+0.015. TalentPigs still earns in the
reign set; teacher feedback can move Λ2 where CE/FT imitation could not.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Method
1. Serve teacher on GPUs 0,1 before train; policy LoRA on GPUs 6,7.
2. Train base = TalentPigs/affine-5ekxlcg3fx-abc @dbfbb3e2; n80 king = Tok.
3. Data: prefixes + teacher `y` from `winner_za_high_l1.jsonl` (x only).
4. LoRA r=16/α32 lr=5e-6 G=2 max_new=256 max_steps=200.
5. Reward: teacher force-echo Λ2; advantage = r − mean(r) in group.
6. Merge → n80 vs Tok.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f41-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural: F37 reward × currently-earning TalentPigs base. Isolates whether
F10/F18/F32 failed because of CE/FT imitation (not the TalentPigs base).
Orthogonal to Tok/Genesis/kevin RL screens and to the closed past-king FT/raw class.
