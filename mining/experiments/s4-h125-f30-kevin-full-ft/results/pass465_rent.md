# H125/F30 pass465 — kevin954 full-FT screen rented

## Facts
- Free slots idle; F5 still blocked (no traj). Next structural family **F30**:
  kevin954-init dense full-FT × high-Λ2 z_A (no LoRA). Orthogonal to F26
  (Tok-FT), F27 (Genesis-FT), F28 (teacher-refs), F29 (golden-FT), F9
  (kevin-LoRA m=−0.014), F19 (raw kevin m=−0.006 — least-bad raw).
- Train base: `kevin954/Affine-5dfqbbh8ev-sft` @ `3fb79cfbf3a21c7a2d2cf3ac5161a9a46277c152`.
  King: Tok `…-af10` @ `eb8bf9a…`.
- Rent: catalog `37b3ea5c-…` → live `lunar-wolf-aa` /
  `6103643d-…` **mine-f30-1** @$28.00/h `--ttl 12h`
  (remove_at ≈2026-08-09T16:31Z). COUNT=8 verified on SSH stdout.
- SSH `152.236.142.236:40300` kh `/tmp/mine-f30-1.known_hosts`.
- Stack upload + bootstrap pid=873; form + retry(**d203first**) armed.
- HF push target `unconst/Affine-5czsc2fc98-h125-kevinfullft` created.

## Fleet at rent
- F17 n80~67; F25 n80~58; F23 n80~21; F22 everest ~57G (growing);
  F26 train~30/60; F27~20/60; F28~5/60; F29 train0/60; F30 pip.
- Burn ~$318.7/h (9 mine-*) ≪ $833/h. Lium ~$180,952.

## Next
Await kevin DL→full-FT train→finalize+serve+n80. Screen >+0.015 → CONFIRM k=4.
