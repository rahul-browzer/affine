# H140/F45 pass514 — Tok last-N full-rank REINFORCE rented

## Context
- Fleet F37–F44 healthy (F37 n80 ~65/80; F38 n80 just launched a203;
  F39–F42 train; F43 merge; F44 Tok DL). Free slots → orthogonal **F45**.
- F45 = Tok last-N=8 full-rank + lm_head REINFORCE on teacher-Λ2
  (SGD lr=1e-6). Not LoRA (F37), not CE dense FT (F26), not BoN/DPO.

## Rent
- Catalog `f092246d…` / cosmic-wolf-e2 → live `lunar-matrix-d4` /
  `e61d3155…` **mine-f45-1** 8×H200 @$31.92/h `--ttl 12h`
  (remove_at ≈2026-08-09T21:35:31Z). **COUNT=8** verified via SSH.
- SSH `38.255.28.21:20099` kh `/tmp/mine-f45-1.known_hosts`.
- Stack upload + bootstrap pid=926; form + retry(d203first) + preempt armed.
- HF `unconst/Affine-5czsc2fc98-h140-{lora,merged}` created.
- soft=20:35:31Z deadman=21:05:31Z. EXP=`s4-h140-f45-tok-lastn-rl-l2`.
- Data: `winner_za_high_l1.jsonl` n=406 (H27).

## Fleet at rent
- Burn ~$246.6/h (9 mine-*) ≪ $833/h.
