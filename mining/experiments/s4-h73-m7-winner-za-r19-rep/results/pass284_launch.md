# Pass 284 — H73 launch (H67@r19 replicate vs Tok)

- H67 m=+0.01835 shortlist → replicate same cell vs Tok (not blacklist r=19).
- Cloned `s4-h72-…-r18-rep` → `s4-h73-m7-winner-za-r19-rep`.
  Axis: LoRA **r=19**/α32 @ lr=5e-6.
- Pod: **mine-h73-1** / eager-matrix-9a / id `a4de7300-…52e2`
  8×H200 @$31.92/h · COUNT=8 · ttl12h · remove_at ~22:21Z
  SSH `38.255.28.19:20100` · known_hosts `/tmp/mine-h73-1.known_hosts`
- SOFT=21:21Z DEADMAN=21:51Z. bootstrap pid918 · preempt pid921.
- HF: `unconst/Affine-5czsc2fc98-h73-{lora,merged}`
