# H129/F34 pass469 — diane613 full-FT screen rented

## Facts
- Free slot (11→10); F26–F33 mid-train/boot; F22 everest done, Tok king DL
  still growing (~13G+incompletes), engines idle until bootstrap finishes king.
- Next structural family **F34**: diane613-init dense full-FT × high-Λ2 z_A
  (no LoRA). Orthogonal to F13 (diane-LoRA m=−0.07293), F21 (raw diane
  m=−0.07226), live F26–F33 FT bases.
- Train base: `diane613/Affine-5CQLBK7Mmw1vsk7eQcBok9Qn44JNU5YVrfNmZpJHPxLV271B`
  @ `ad0f3f116e44…`. King: Tok `…-af10` @ `eb8bf9a…`.
- Rent: catalog `5aed9800-…` → live `brave-eagle-b1` /
  `1569cca6-…` **mine-f34-1** @$31.92/h `--ttl 12h`
  (remove_at ≈2026-08-09T17:10Z). COUNT=8 verified on SSH stdout.
- SSH `38.255.28.18:20099` kh `/tmp/mine-f34-1.known_hosts`.
- Stack upload + bootstrap pid=903; form + retry(**d203first**) armed.
- HF push target `unconst/Affine-5czsc2fc98-h129-dianefullft` created.

## Fleet at rent
- F22 king DL; F26–F33 train; F34 pip/bootstrap.
- Burn ~$318.9/h (10 mine-*) ≪ $833/h. Lium ~$180,601.
