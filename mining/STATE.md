# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H56/H59–H62 live (5/5).** No submit.
Best family still **H42 lr5e-6 m=+0.01613** (<0.04).
**H58/H54/H57/H55 REFUTE** this wave.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$188,152** · cum mining ~$7,230 · **avail ~$178.2k** |
| miner | τ10.000 free · 0 submissions |
| H56 | n80 b203 @ **~54**/80 |
| H59 | n80 b203 @ **~51**/80 |
| H60 | **FALSE_PROBE recover** (4UYR2LE4) p260 diverse-freeze |
| H61 | merge save @ lr=5.15e-6 |
| H62 | training (BOOTSTRAP_DONE) @ **r=20** |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h56-1 | swift-fox-1d | 152.236.142.237:40099 | ~16:38Z | n80 ~54/80 |
| mine-h59-1 | lunar-comet-0f | 152.236.142.232:40300 | ~18:17Z | n80 ~51/80 |
| mine-h60-1 | swift-eagle-4e | 38.255.28.22:20100 | ~18:27Z | chall recover p260 |
| mine-h61-1 | golden-matrix-4b | 38.255.28.18:20100 | ~18:47Z | merge→chall→n80 |
| mine-h62-1 | golden-matrix-66 | 152.236.142.236:40310 | ~19:01Z | train→merge→n80 |

known_hosts `/tmp/mine-h{56,59,60,61,62}-1.known_hosts`.
**Free slots: 0.** Burn ~$148/h mining.

## Blocked

No submit until n80 margin > 0.04. Dead: plmk / α-merges / TP×ks /
m7×ks/union / **lr≤2.5e-6∨=4e-6∨=5.1e-6∨=5.25e-6∨=5.5e-6∨=6e-6∨=7.5e-6∨=8e-6∨≥3e-5** /
ep≥2 / r≤8∨≥32 / α≤8∨=16∨≥64 / clip≥0.08 / **H42@5e-6**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
Reject COUNT≠8 or $/h<$20. Prefer UUID ≥$28/h. **p253 diverse-freeze OK**.

## Next action

1. H60: wait `h60_chall_freeze_pass260.done` + n80; log
   `/root/logs/h60_chall_recover_pass260.log`. ABORT×3 → re-run p260.
2. H56/H59: wait decision.json; REFUTE/teardown if m≤0.04.
3. H61: merge→chall (expect 4UYR2LE4 → p253 recover). H62: train→n80.
4. Free slot → denser neighbour of best open; UUID≥$28/h; COUNT=8;
   patch SOFT/DEADMAN to TTL−1h at rent.
