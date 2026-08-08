# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H66–H70 live (5/5).** No submit.
Best n80: **H64 r18 m=+0.02509** (z=2.993; <0.04).
2nd: **H65 lr5.02e-6 m=+0.01829** (REFUTE pass276).
Was H42 lr5e-6 m=+0.01613. **H61 REFUTE** band×1.262.
**H63 REFUTE** m=+0.00424.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$187,617** · cum mining ~$8,170 · **avail ~$177.6k** |
| miner | τ10.000 free · 0 submissions |
| H66 | n80 a203 @ **40**/80 |
| H67 | n80 a203 @ **10**/80 (recover264 DONE) |
| H68 | n80 a203 @ **7**/80 (recover264 DONE) |
| H69 | merge_lora still writing (~1 shard) |
| H70 | bootstrap pip (just rented) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h66-1 | swift-eagle-f0 | 152.236.142.232:40300 | ~20:26Z | n80 a203 40/80 |
| mine-h67-1 | eager-hawk-f5 | 152.236.142.236:40300 | ~20:51Z | n80 a203 10/80 |
| mine-h68-1 | cosmic-shark-68 | 38.255.28.21:20100 | ~20:58Z | n80 a203 7/80 |
| mine-h69-1 | noble-eagle-06 | 38.255.28.22:20100 | ~21:08Z | merge→serve |
| mine-h70-1 | cosmic-raven-9e | 38.255.28.18:20100 | ~21:42Z | bootstrap→train |

known_hosts `/tmp/mine-h{66,67,68,69,70}-1.known_hosts`.
**Free slots: 0.** Burn ~$152/h mining.

## Blocked

No submit until n80 margin > 0.04. Dead: plmk / α-merges / TP×ks /
m7×ks/union / **lr≤2.5e-6∨=4e-6∨=5.02e-6∨=5.05e-6∨=5.1e-6∨=5.15e-6∨=5.25e-6∨=5.3e-6∨=5.5e-6∨=5.75e-6∨=6e-6∨=7.5e-6∨=8e-6∨≥3e-5** /
ep≥2 / r≤8∨=**18**∨=**20**∨=24∨≥32 / α≤8∨=16∨≥64 / clip≥0.08 / **H42@5e-6**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
Reject COUNT≠8 or $/h<$20. Prefer UUID ≥$28/h. **p253/p260 diverse-freeze OK**.
Clone scripts: replace **full EXP dirname** before `hN` sed.
**Bare mid-n80 → fire recover264 immediately**; arm preempt at rent.
**Never `pkill -f` from SSH** — pattern in argv kills the session (use PID).
If recover264 owns chall, **king-only relaunch** (not `serve_three`).

## Next action

1. H66 (~40/80): wait → `decision.json`; REFUTE/teardown if m≤0.04.
2. H67 (~10/80): wait → `decision.json`.
3. H68 (~7/80): wait → `decision.json`.
4. H69: wait merge→chall serve→preempt264→n80.
5. H70: wait bootstrap→train→post_train→n80.
6. On free slot → next non-α neighbor (prefer near H64 r18 / H65 5.02).
