# H123/F28 pass463 — Tok full-FT × teacher_refs screen rented

## Facts
- Free slots idle; F5 still blocked (no traj). Next structural family **F28**:
  Tok-init dense full-FT × `teacher_refs_shortz` (791 frontier z_C). Orthogonal
  to F26 (Tok-FT × winner-z_A) and F7 (Genesis-LoRA × teacher z_C, refuted).
- Train base: Tok331102 `…-af10` @ `eb8bf9a…`. Data:
  `s4-h5c-expand-refs/results/teacher_refs_shortz.jsonl` (791 ok).
- Rent: catalog `e88d6cf0-…` → live `eager-eagle-b1` /
  `6e635ccd-…` **mine-f28-1** @$28.00/h `--ttl 12h`
  (remove_at ≈2026-08-09T16:20Z). COUNT=8 verified on SSH stdout.
- SSH `152.236.142.232:40300` kh `/tmp/mine-f28-1.known_hosts`.
- Stack upload + bootstrap pid=890; form + retry(**d203first**) armed.
- HF push target `unconst/Affine-5czsc2fc98-h123-trefsft` created.

## Fleet at rent
- F17 n80~48; F25 n80~37; F22 everest DL growing; F23 king/chall CUDA graphs;
  F26 Tok-FT train step≥1/60; F27 genesis DL; F28 boot.
- Burn ~$262.7/h (7 mine-*) ≪ $833/h. Lium ~$181,033.

## Next
Await Tok DL→full-FT train→finalize+serve+n80. Screen >+0.015 → CONFIRM k=4.
