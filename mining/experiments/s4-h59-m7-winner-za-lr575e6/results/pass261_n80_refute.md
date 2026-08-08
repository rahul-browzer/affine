# H59 pass261 — n80 REFUTE (lr=5.75e-6, band)

## Verdict
- n=80 paired; chall INVALID (`baseline_band_exceeded`)
- base× **1.273** (king baseline 0.1309 → chall 0.1666) > 1.25
- margin forced **0**; valid_c=false; r_c=0.547; S_k=0.04284
- decision `REFUTE_H59`

## Conclusion
**lr=5.75e-6 dead (band).** Same failure mode as H55@5.5e-6 (×1.256).
High-lr side of the H42 peak is band-sensitive; do not probe ≥5.5 again.
Tear `mine-h59-1` (lunar-comet-0f, spent ~$33).
