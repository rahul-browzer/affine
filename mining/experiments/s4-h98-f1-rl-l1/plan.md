# H98 / F1 — Direct RL on self-L1lift (family screen)

## Family
**F1** (operator 2026-08-08): Direct RL on S (GRPO/REINFORCE). Not a
winner-zA SFT cell. Prior family mean −0.004; Λ2/L1 need shaping, not CE copy.

## Claim
Tok331102-init LoRA trained by **REINFORCE on thought tokens** with reward =
`clip(lpθ(y|z) − lpθ(y|∅), ±0.1)` (self L1lift — the miner term of S*) on the
same 406 winner-zA prefixes beats Tok by screen margin >+0.015. Structurally
leaves CE-on-harvested-z; samples its own z and reinforces high-L1lift ones.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Method
- Data: prefixes + teacher `y` from `winner_za_high_l1.jsonl` (x only; z ignored
  at train — policy samples fresh z).
- LoRA r=16/α32, lr=5e-6, G=2 samples/step, max_new_tokens=256, 1 epoch over
  fit-filtered rows, GPUs 6,7.
- Reward: self-forced L1lift of y under sampled z vs empty thought; clip ±0.1.
- Loss: `-A · Σ log π(z_t)` with A = r − mean(r) over the G samples (REINFORCE
  baseline). No SFT CE term (family purity).
- Merge → n80 vs Tok same stack as H9x.

## Decision rule
- m≤0 or gate fail → REFUTE family cell; tear `mine-f1-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep / teacher-Λ2 reward variant.
- m>0.04 + gates → Stage 5 shortlist.
