# H133/F38 pass501 — Genesis×teacher-Λ2 REINFORCE screen rented

## Facts
- Free slots idle; n80 still running (F32~55 F36~30); F37 RL step≥65.
  Past-king FT / raw past-earner CLOSED. Orthogonal family **F38**:
  Genesis-init LoRA REINFORCE with reward = teacher Λ2 (live GLM :8000).
  Cross of F8 (Genesis×self-L1, REFUTE −0.048) × F37 (Tok×teacher-Λ2, live).
- Train base: genesis @ `abe89194…`. King for n80: Tok331102. Data: 406
  winner_za_high_l1 prefixes.
- Rent: catalog `151d4b6c…` → live `golden-eagle-8b` /
  `dfc1d98b…` **mine-f38-1** 8×H200 @$23.20/h `--ttl 12h`
  (remove_at ≈2026-08-09T19:51Z). COUNT=8 verified on SSH.
- SSH `152.236.142.235:40300` kh `/tmp/mine-f38-1.known_hosts`.
- Stack upload + bootstrap pid=883; form + retry(d203first) + preempt armed.
- HF `unconst/Affine-5czsc2fc98-h133-{lora,merged}` created.
- soft=18:51:54Z (TTL−1h); deadman=19:21:54Z. EXP=`s4-h133-f38-genesis-rl-l2`.

## Fleet at rent
- F32 n80 ~55/80; F36 n80 ~30/80; F37 RL train; F38 bootstrap/pip.
- Burn ~$112.1/h (4 mine-*) ≪ $833/h. Lium ~$179,339 post-rent.
