# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H61/H65–H68 live (5/5).** No submit.
Best n80: **H64 r18 m=+0.02509** (z=2.993; <0.04).
Was H42 lr5e-6 m=+0.01613. **H63 REFUTE** m=+0.00424.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$187,780** · cum mining ~$7,890 · **avail ~$177.8k** |
| miner | τ10.000 free · 0 submissions |
| H61 | n80 b203 @ **64**/80 |
| H63 | **REFUTE** m=+0.00424 z=0.556 base×1.214 · rm ~$48 |
| H65 | n80 b203 @ **11**/80 |
| H66 | merge OK; chall re-serve after king recover (t/k=200 c=000) |
| H67 | train r=19 running |
| H68 | **rented** cosmic-shark-68 · bootstrap+preempt |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h61-1 | golden-matrix-4b | 38.255.28.18:20100 | ~18:47Z | n80 b203 64/80 |
| mine-h65-1 | calm-wolf-24 | 152.236.142.237:40099 | ~20:11Z | n80 b203 11/80 |
| mine-h66-1 | swift-eagle-f0 | 152.236.142.232:40300 | ~20:26Z | chall re-serve→n80 |
| mine-h67-1 | eager-hawk-f5 | 152.236.142.236:40300 | ~20:51Z | train r=19 |
| mine-h68-1 | cosmic-shark-68 | 38.255.28.21:20100 | ~20:58Z | bootstrap lr4.95e-6 |

known_hosts `/tmp/mine-h{61,65,66,67,68}-1.known_hosts`.
**Free slots: 0.** Burn ~$148/h mining.

## Blocked

No submit until n80 margin > 0.04. Dead: plmk / α-merges / TP×ks /
m7×ks/union / **lr≤2.5e-6∨=4e-6∨=5.05e-6∨=5.1e-6∨=5.25e-6∨=5.3e-6∨=5.5e-6∨=5.75e-6∨=6e-6∨=7.5e-6∨=8e-6∨≥3e-5** /
ep≥2 / r≤8∨=**18**∨=**20**∨=24∨≥32 / α≤8∨=16∨≥64 / clip≥0.08 / **H42@5e-6**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
Reject COUNT≠8 or $/h<$20. Prefer UUID ≥$28/h. **p253/p260/p264 diverse-freeze OK**.
Clone scripts: replace **full EXP dirname** before `hN` sed.
**Bare mid-n80 → fire recover264 immediately**; arm preempt at rent.

## Next action

1. H61 (~64/80): wait → `decision.json`; REFUTE/teardown if m≤0.04.
2. H65 (~11/80): wait n80 → decision.
3. H66: wait chall :8002=200 → n80 (retry armed); recover264 if bare/ENOENT.
4. H67: wait train→merge→n80 (preempt264 armed; SOFT 19:51Z).
5. H68: wait bootstrap→train (SOFT 19:58Z / DEADMAN 20:28Z).
6. On free slot → scaffold next non-α neighbor (lr or r not in dead set).
