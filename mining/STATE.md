# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H65–H69 live (5/5).** No submit.
Best n80: **H64 r18 m=+0.02509** (z=2.993; <0.04).
Was H42 lr5e-6 m=+0.01613. **H61 REFUTE** band×1.262.
**H63 REFUTE** m=+0.00424.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$187,673** · cum mining ~$8,040 · **avail ~$177.7k** |
| miner | τ10.000 free · 0 submissions |
| H65 | n80 b203 @ **51**/80 |
| H66 | n80 a203 @ **5**/80 (salvage recover264 DONE) |
| H67 | king+chall loading after EngineCore cancel recover |
| H68 | train done · **post_train** / merge |
| H69 | train done step26 · post_train next |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h65-1 | calm-wolf-24 | 152.236.142.237:40099 | ~20:11Z | n80 b203 51/80 |
| mine-h66-1 | swift-eagle-f0 | 152.236.142.232:40300 | ~20:26Z | n80 a203 5/80 |
| mine-h67-1 | eager-hawk-f5 | 152.236.142.236:40300 | ~20:51Z | king/chall load→n80 |
| mine-h68-1 | cosmic-shark-68 | 38.255.28.21:20100 | ~20:58Z | post_train |
| mine-h69-1 | noble-eagle-06 | 38.255.28.22:20100 | ~21:08Z | train done→post |

known_hosts `/tmp/mine-h{65,66,67,68,69}-1.known_hosts`.
**Free slots: 0.** Burn ~$148/h mining.

## Blocked

No submit until n80 margin > 0.04. Dead: plmk / α-merges / TP×ks /
m7×ks/union / **lr≤2.5e-6∨=4e-6∨=5.05e-6∨=5.1e-6∨=5.15e-6∨=5.25e-6∨=5.3e-6∨=5.5e-6∨=5.75e-6∨=6e-6∨=7.5e-6∨=8e-6∨≥3e-5** /
ep≥2 / r≤8∨=**18**∨=**20**∨=24∨≥32 / α≤8∨=16∨≥64 / clip≥0.08 / **H42@5e-6**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
Reject COUNT≠8 or $/h<$20. Prefer UUID ≥$28/h. **p253/p260/p264 diverse-freeze OK**.
Clone scripts: replace **full EXP dirname** before `hN` sed.
**Bare mid-n80 → fire recover264 immediately**; arm preempt at rent.
**Never `pkill -f` from SSH** — pattern in argv kills the session (use PID).

## Next action

1. H65 (~51/80): wait → `decision.json`; REFUTE/teardown if m≤0.04.
2. H66 (~5/80 a203): wait → `decision.json` (salvage freeze OK).
3. H67: wait :8001/:8002=200 → post_train→preempt264→n80; if king dies again
   wipe `cache/king` + `serve_three` (see `pass274_king_recover.md`).
4. H68: wait merge→serve→n80 (preempt264 armed).
5. H69: wait post_train→n80 (preempt264 armed).
6. On free slot → next non-α neighbor (lr/r not in dead set; prefer near H64 r18).
