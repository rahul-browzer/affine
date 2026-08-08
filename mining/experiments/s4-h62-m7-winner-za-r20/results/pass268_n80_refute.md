# H62 pass268 — n80 REFUTE (r=20 band)

- Pod: mine-h62-1 / golden-matrix-66 · teardown after decision
- Slice: block_hash a203… · n=80 · elapsed ~2554s
- Verdict: chall INVALID — `baseline_band_exceeded`
  - base_x = **1.27298** (band 1.25)
  - chall baseline_abs 0.13972 vs king 0.10976
  - r_c = 0.534 · gate_pass 0.744 · bank 0.618 (gates else OK)
  - mean_mix chall 0.04525 (invalid) · king S 0.03387
  - margin 0 / z 0 / submit=false
- Decision: **REFUTE_H62** — LoRA **r=20 dead** (same band mode as H59@5.75)
- Artifact: `h62_decision.json` + `h62_sim_result.json` (this dir)
