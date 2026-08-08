# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H61/H63/H65–H67 live (5/5).** No submit.
Best n80: **H64 r18 m=+0.02509** (z=2.993; <0.04; torn down).
Was H42 lr5e-6 m=+0.01613. **H68 scaffolded** — rent on next free.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$187,799** · cum mining ~$7,840 · **avail ~$177.8k** |
| miner | τ10.000 free · 0 submissions |
| H61 | n80 b203 @ **45**/80 |
| H63 | n80 a203 @ **75**/80 |
| H64 | **REFUTE** m=+0.02509 z=2.993 base×1.248 · rm ~$44 |
| H65 | n80 a203 @ **5**/80 (recover264 freeze OK) |
| H66 | king Triton ENOENT → pass271 relaunch king+merged chall |
| H67 | **rented** eager-hawk-f5 · bootstrap+preempt |
| H68 | **ready** `s4-h68-…-lr495e6` — not rented |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h61-1 | golden-matrix-4b | 38.255.28.18:20100 | ~18:47Z | n80 b203 45/80 |
| mine-h63-1 | noble-eagle-3f | 38.255.28.19:20100 | ~19:28Z | n80 75/80 |
| mine-h65-1 | calm-wolf-24 | 152.236.142.237:40099 | ~20:11Z | n80 5/80 |
| mine-h66-1 | swift-eagle-f0 | 152.236.142.232:40300 | ~20:26Z | merge→n80 |
| mine-h67-1 | eager-hawk-f5 | 152.236.142.236:40300 | ~20:51Z | bootstrap r=19 |

known_hosts `/tmp/mine-h{61,63,65,66,67}-1.known_hosts`.
**Free slots: 0.** Burn ~$148/h mining.

## Blocked

No submit until n80 margin > 0.04. Dead: plmk / α-merges / TP×ks /
m7×ks/union / **lr≤2.5e-6∨=4e-6∨=5.1e-6∨=5.25e-6∨=5.3e-6∨=5.5e-6∨=5.75e-6∨=6e-6∨=7.5e-6∨=8e-6∨≥3e-5** /
ep≥2 / r≤8∨=**18**∨=**20**∨=24∨≥32 / α≤8∨=16∨≥64 / clip≥0.08 / **H42@5e-6**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
Reject COUNT≠8 or $/h<$20. Prefer UUID ≥$28/h. **p253/p260/p264 diverse-freeze OK**.
Clone scripts: replace **full EXP dirname** before `hN` sed.
**Bare mid-n80 → fire recover264 immediately**; arm preempt at rent.

## Next action

1. H63 (~75/80): wait → `decision.json`; REFUTE/teardown if m≤0.04 → rent **H68**.
2. H61/H65: wait n80 → decision. H66: wait chall→n80.
3. H67: wait train→merge→n80 (preempt264 armed; SOFT 19:51Z).
4. On free slot → **rent H68 lr=4.95e-6** (`upload_and_launch.sh`); patch
   SOFT/DEADMAN to TTL−1h; UUID≥$28/h; COUNT=8; confirm preempt264 pid.
