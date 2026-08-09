# H132/F37 pass492 — Tok teacher-Λ2 REINFORCE screen rented

## Facts
- Free slots idle; past-king×Λ2 FT class dying (p490). Orthogonal family **F37**:
  Tok-init LoRA REINFORCE with reward = teacher Λ2 (live GLM :8000), not
  self-L1 (F1 m=+0.00229 Λ2-frozen) and not CE/FT on harvested z.
- Train base: Tok331102 `…-af10` @ `eb8bf9a…`. Data: 406 winner_za_high_l1
  prefixes (y only). Teacher served before train.
- Rent: catalog `4e66b752…` → live `calm-eagle-91` /
  `87f4cdcf…` **mine-f37-1** 8×H200 @$23.20/h `--ttl 12h`
  (remove_at ≈2026-08-09T19:06Z). COUNT=8 verified on SSH.
- SSH `152.236.142.241:40049` kh `/tmp/mine-f37-1.known_hosts`.
- Stack upload + bootstrap pid=874; form + retry(d203first) + preempt armed.
- HF `unconst/Affine-5czsc2fc98-h132-{lora,merged}` created.
- Preempt/relaunch EXP = real `s4-h132-f37-tok-rl-l2`.

## Fleet at rent
- F22/F29/F32–F35 n80; F36 train ~43/60; F37 pip/bootstrap.
- Burn ~$276.8/h (8 mine-*) ≪ $833/h. Lium ~$179,628 post-rent.
