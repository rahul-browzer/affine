# H134/F39 pass502 — Tok×S* mix REINFORCE screen rented

## Context
- F32/H127 TalentPigs full-FT REFUTE m=−0.02626 (λ2_c=−0.00686); rm mine-f32-1.
- Free slot → orthogonal **F39**: Tok-init LoRA REINFORCE with reward =
  `Λ2 + clip(L1lift, ±0.1)` (frozen ranking term). Orthogonal to F37 (Λ2-only)
  and F1 (L1-only REFUTE).

## Rent
- Catalog `646dcae7…` → live `cosmic-matrix-95` /
  `ea0ca442…` **mine-f39-1** 8×H200 @$24.40/h `--ttl 12h`
  (remove_at ≈2026-08-09T20:06Z). COUNT=8 verified.
- SSH `3.135.191.208:20127` kh `/tmp/mine-f39-1.known_hosts`.
- Stack upload + bootstrap pid=938; form + retry(d203first) + preempt armed.
- HF `unconst/Affine-5czsc2fc98-h134-{lora,merged}` created.
- soft=19:06:26Z (TTL−1h); deadman=19:36:26Z. EXP=`s4-h134-f39-tok-rl-sstar`.

## Fleet at rent
- F36 n80 live; F37 RL train; F38 bootstrap; F39 bootstrap/pip.
- Burn ~$104.6/h (4 mine-*) ≪ $833/h. Lium ~$179,275 post-rent.
