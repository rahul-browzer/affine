# Pass 296 — H78 launch (r21 vs Tok)

- Rank-axis step ≥3 from r18; r=16/19/20 dead; r=21 untested.
- Cloned `s4-h76-…-r18-rep4` → `s4-h78-m7-winner-za-r21-tok`
  (EXP dirname before hN sed; `--lora-r 21`).
- Pod: **mine-h78-1** / eager-comet-a4 / id `5bad30eb-aea7-40f4-9dfc-ac5b5b0c2a9b`
  8×H200 @$31.92/h · COUNT=8 · ttl12h · SSH `38.255.28.22:20100`
  known_hosts `/tmp/mine-h78-1.known_hosts`
- SOFT=22:45Z DEADMAN=23:15Z. bootstrap pid963 · preempt pid966.
- HF: `unconst/Affine-5czsc2fc98-h78-{lora,merged}`
