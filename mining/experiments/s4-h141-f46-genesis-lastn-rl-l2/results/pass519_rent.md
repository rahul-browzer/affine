# H141/F46 pass519 — Genesis last-N full-rank REINFORCE rented

## Context
- Fleet F38–F45 healthy (F38 n80 ~6/80; F43 n80 ~23/80; F40 recover264;
  F39/F41/F42/F44 train; F45 teacher+king loading). Free slot → orthogonal **F46**.
- F46 = Genesis × last-N=8 full-rank + lm_head REINFORCE on teacher-Λ2
  (cross F38 LoRA-Genesis × F45 Tok-lastN). n80 king = Tok331102.

## Rent
- Catalog `4e66b752…` / lunar-shark-33 → live `swift-comet-18` /
  `e685a1d1…` **mine-f46-1** 8×H200 @$23.20/h `--ttl 12h`
  (remove_at ≈2026-08-09T22:02:13Z). **COUNT=8** verified via SSH.
- SSH `152.236.142.241:40061` kh `/tmp/mine-f46.kh`.
- Stack upload + bootstrap pid=889; form + retry(d203first) + preempt armed.
- HF `unconst/Affine-5czsc2fc98-h141-{lora,merged}` created.
- soft=21:02:13Z deadman=21:32:13Z. EXP=`s4-h141-f46-genesis-lastn-rl-l2`.
- Data: `winner_za_high_l1.jsonl` n=406 (H27).

## Fleet at rent
- Burn ~$246.6/h (9 mine-*) ≪ $833/h.
