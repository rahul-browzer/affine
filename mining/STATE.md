# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H60–H64 live (5/5).** No submit.
Best family still **H42 lr5e-6 m=+0.01613** (<0.04).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$188,004** · cum mining ~$7,575 · **avail ~$178.0k** |
| miner | τ10.000 free · 0 submissions |
| H60 | n80 a203 @ **~60**/80 |
| H61 | n80 **b203 attempt 2/3** @ **~12**/80 (a203 teacher-400; bare TCACHE) |
| H62 | n80 a203 @ **~27**/80 |
| H63 | merge writing shard2 (slow); preempt264 waiting |
| H64 | **p264 preempt FIRED** → recover isolated TCACHE attempt1 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h60-1 | swift-eagle-4e | 38.255.28.22:20100 | ~18:27Z | n80 ~60/80 |
| mine-h61-1 | golden-matrix-4b | 38.255.28.18:20100 | ~18:47Z | n80 b203 ~12/80 bare |
| mine-h62-1 | golden-matrix-66 | 152.236.142.236:40310 | ~19:01Z | n80 ~27/80 |
| mine-h63-1 | noble-eagle-3f | 38.255.28.19:20100 | ~19:28Z | merge + preempt wait |
| mine-h64-1 | gentle-wolf-eb | 38.255.28.21:20099 | ~19:28Z | recover264 → freeze → n80 |

known_hosts `/tmp/mine-h{60,61,62,63,64}-1.known_hosts`.
**Free slots: 0.** Burn ~$156/h mining.

## Blocked

No submit until n80 margin > 0.04. Dead: plmk / α-merges / TP×ks /
m7×ks/union / **lr≤2.5e-6∨=4e-6∨=5.1e-6∨=5.25e-6∨=5.5e-6∨=5.75e-6∨=6e-6∨=7.5e-6∨=8e-6∨≥3e-5** /
ep≥2 / r≤8∨=24∨≥32 / α≤8∨=16∨≥64 / clip≥0.08 / **H42@5e-6**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
Reject COUNT≠8 or $/h<$20. Prefer UUID ≥$28/h. **p253/p260/p264 diverse-freeze OK**.
Clone scripts: replace **full EXP dirname** before `hN` sed (p262: lr53e6≠r20).

## Next action

1. H64: wait recover freeze.done → n80 a203 (`*_chall_recover_pass264.nohup`,
   `*_chall_freeze_pass264.done`). Confirm watchers rearmed.
2. H63: confirm preempt fires on bare chall (same path as H64 p265).
3. H60/H61/H62: wait `decision.json`; REFUTE/teardown if m≤0.04.
   H61 bare + attempt2 — if FALSE_PROBE, p260 recover (do not `lium rm`).
4. Free slot → denser neighbour of best open; UUID≥$28/h; COUNT=8;
   patch SOFT/DEADMAN to TTL−1h at rent.
