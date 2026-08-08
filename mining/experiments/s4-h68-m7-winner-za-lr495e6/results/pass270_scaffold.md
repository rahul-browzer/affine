# Pass 270 — H68 scaffold (lr=4.95e-6), not rented

- Cloned `s4-h65-m7-winner-za-lr502e6` → `s4-h68-m7-winner-za-lr495e6`
  (full EXP dirname before hN sed).
- Axis: **lr=4.95e-6** r16/α32 (H42@5e-6 best · H53@4e-6 dead · H65@5.02 open).
- `upload_and_launch.sh` arms preempt264 at upload.
- SOFT/DEADMAN `:-` still H65-era (19:15Z/19:45Z) — **must patch
  to ≥TTL−1h at rent**.
- Queue: rent **H67 r=19 first**, then H68 on next free slot.
- Caps full (5/5). Do not rent until a `mine-*` slot frees.
  Prefer UUID ≥$28/h, COUNT=8.
