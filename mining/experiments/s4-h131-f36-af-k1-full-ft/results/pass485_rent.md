# H131/F36 pass485 — af-k1 full-FT screen rented

## Facts
- Free slot (11→12); F22 n80 + F26–F35 mid-flight; next structural family **F36**:
  af-k1-init dense full-FT × high-Λ2 z_A (no LoRA). Orthogonal to F16
  (af-k1-LoRA m=−0.07623), F24 (raw af-k1 m=−0.08673), live F26–F35 FT bases.
- Train base: `af-k1/Affine-5ECeJJpEMjW4pxM9eGyJ5ua3Sebfyr8kcVwLAdaiJLUC8pkW`
  @ `ff6eb4bcff3e7c6b8c0e097bc0cffa4fa2ba8e01`. King Tok `…-af10` @ `eb8bf9a…`.
- Rent: catalog `876b614a…` → live `zesty-orbit-ff` /
  `d668affe…` **mine-f36-1** 8×H200 @$33.81/h `--ttl 12h`
  (remove_at ≈2026-08-09T18:25Z). COUNT=8 verified on SSH.
- SSH `86.38.238.54:40300` kh `/tmp/mine-f36-1.known_hosts`.
- Stack upload + bootstrap pid=874; form + retry(**d203first**) armed.
- HF push target `unconst/Affine-5czsc2fc98-h131-afk1fullft` created.
- Preempt `EXP=` set to real `s4-h131-f36-af-k1-full-ft` (p480 fix baked in clone).

## Fleet at rent
- F22 recover DONE_LAUNCH + n80 rearm; F26–F31 n80; F32 engines loading;
  F33–F35 train; F36 pip/bootstrap.
- Burn ~$392.8/h (12 mine-*) ≪ $833/h. Lium ~$180,008 pre-rent.
