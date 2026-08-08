# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H61–H65 live (5/5).** No submit.
Best family still **H42 lr5e-6 m=+0.01613** (<0.04).
**H60 REFUTE** m=+0.01350 @ lr5.3e-6 (pass267).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$187,947** · cum mining ~$7,650 · **avail ~$177.9k** |
| miner | τ10.000 free · 0 submissions |
| H61 | freeze264 OK · n80 a203 @ **~7**/80 |
| H62 | n80 a203 @ **~59**/80 |
| H63 | freeze264 OK (n_so=22) · n80 rearmed (retry starting) |
| H64 | freeze264 OK · n80 a203 @ **~2**/80 |
| H65 | bootstrap just launched (lr5.02e-6) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h61-1 | golden-matrix-4b | 38.255.28.18:20100 | ~18:47Z | n80 ~7/80 |
| mine-h62-1 | golden-matrix-66 | 152.236.142.236:40310 | ~19:01Z | n80 ~59/80 |
| mine-h63-1 | noble-eagle-3f | 38.255.28.19:20100 | ~19:28Z | n80 rearmed post-freeze |
| mine-h64-1 | gentle-wolf-eb | 38.255.28.21:20099 | ~19:28Z | n80 ~2/80 |
| mine-h65-1 | calm-wolf-24 | 152.236.142.237:40099 | ~20:11Z | bootstrap→train |

known_hosts `/tmp/mine-h{61,62,63,64,65}-1.known_hosts`.
**Free slots: 0.** Burn ~$152/h mining.

## Blocked

No submit until n80 margin > 0.04. Dead: plmk / α-merges / TP×ks /
m7×ks/union / **lr≤2.5e-6∨=4e-6∨=5.1e-6∨=5.25e-6∨=5.3e-6∨=5.5e-6∨=5.75e-6∨=6e-6∨=7.5e-6∨=8e-6∨≥3e-5** /
ep≥2 / r≤8∨=24∨≥32 / α≤8∨=16∨≥64 / clip≥0.08 / **H42@5e-6**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
Reject COUNT≠8 or $/h<$20. Prefer UUID ≥$28/h. **p253/p260/p264 diverse-freeze OK**.
Clone scripts: replace **full EXP dirname** before `hN` sed.
**Bare mid-n80 → fire recover264 immediately**; arm preempt at rent.

## Next action

1. H62: wait `decision.json`; REFUTE/teardown if m≤0.04 → fill slot.
2. H61/H63/H64: wait n80 → decision; teardown on REFUTE.
3. H65: wait train→merge→preempt264→n80.
4. Free slot → denser neighbour of best open (lr≈4.95/5.08 or r=19);
   UUID≥$28/h; COUNT=8; patch SOFT/DEADMAN to TTL−1h; arm preempt264.
