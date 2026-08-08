# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H61/H63–H66 live (5/5).** No submit.
Best family still **H42 lr5e-6 m=+0.01613** (<0.04).
**H67 scaffolded** (r=19) · **H68 scaffolded** (lr=4.95e-6) — rent on free slots.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$187,873** · cum mining ~$7,770 · **avail ~$177.9k** |
| miner | τ10.000 free · 0 submissions |
| H61 | n80 **b203** @ **10**/80 |
| H63 | n80 a203 @ **44**/80 |
| H64 | n80 a203 @ **~38**/80 |
| H65 | merge_lora shard 1/2 writing → chall→n80 |
| H66 | train loading weights → merge→n80 |
| H67 | **ready** `s4-h67-…-r19` — not rented |
| H68 | **ready** `s4-h68-…-lr495e6` — not rented |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h61-1 | golden-matrix-4b | 38.255.28.18:20100 | ~18:47Z | n80 b203 10/80 |
| mine-h63-1 | noble-eagle-3f | 38.255.28.19:20100 | ~19:28Z | n80 44/80 |
| mine-h64-1 | gentle-wolf-eb | 38.255.28.21:20099 | ~19:28Z | n80 ~38/80 |
| mine-h65-1 | calm-wolf-24 | 152.236.142.237:40099 | ~20:11Z | merge→n80 |
| mine-h66-1 | swift-eagle-f0 | 152.236.142.232:40300 | ~20:26Z | train→n80 |

known_hosts `/tmp/mine-h{61,63,64,65,66}-1.known_hosts`.
**Free slots: 0.** Burn ~$152/h mining.

## Blocked

No submit until n80 margin > 0.04. Dead: plmk / α-merges / TP×ks /
m7×ks/union / **lr≤2.5e-6∨=4e-6∨=5.1e-6∨=5.25e-6∨=5.3e-6∨=5.5e-6∨=5.75e-6∨=6e-6∨=7.5e-6∨=8e-6∨≥3e-5** /
ep≥2 / r≤8∨=**20**∨=24∨≥32 / α≤8∨=16∨≥64 / clip≥0.08 / **H42@5e-6**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
Reject COUNT≠8 or $/h<$20. Prefer UUID ≥$28/h. **p253/p260/p264 diverse-freeze OK**.
Clone scripts: replace **full EXP dirname** before `hN` sed.
**Bare mid-n80 → fire recover264 immediately**; arm preempt at rent.

## Next action

1. H61/H63/H64: wait n80 → `decision.json`; REFUTE/teardown if m≤0.04.
2. On first free slot → **rent H67 r=19** (`upload_and_launch.sh`); patch
   SOFT/DEADMAN to TTL−1h; UUID≥$28/h; COUNT=8; confirm preempt264 pid.
3. On next free → **rent H68 lr=4.95e-6** (same rent hygiene).
4. H65: wait merge→chall→n80. H66: wait train→merge→n80.
