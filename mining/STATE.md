# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H54–H58 live (5/5).** No submit.
Best family still **H42 lr5e-6 m=+0.01613** (<0.04).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$188,536** · cum mining ~$6,566 · **avail ~$178.5k** |
| miner | τ10.000 free · 0 submissions |
| H54 | king :8001 died @ n80 start → **p248 relaunch** king_pid=26558 |
| H55 | king die @ chall 16/80 ConnectError → **p248 king recover** (orphans cleared) |
| H56 | chall prefreeze a1 waiting health (p247) |
| H57 | t/k=200; chall restart_for_h2 loading |
| H58 | train lr5.1e-6 + teacher/king.done |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h54-1 | calm-matrix-9c | 152.236.142.236:40300 | ~16:23Z | king recover→n80 retry |
| mine-h55-1 | lunar-shark-0b | 38.255.28.19:20100 | ~16:36Z | king recover→n80 retry |
| mine-h56-1 | swift-fox-1d | 152.236.142.237:40099 | ~16:38Z | H56 chall prefreeze a1 |
| mine-h57-1 | eager-shark-95 | 38.255.28.18:20100 | ~16:44Z | H57 chall loading→n80 |
| mine-h58-1 | eager-matrix-0d | 38.255.28.21:20099 | ~17:22Z | H58 train |

known_hosts `/tmp/mine-h{54,55,56,57,58}-1.known_hosts`.
**Free slots: 0.** Burn ~$152/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36 /
**H28@lr≥3e-5** / **H28@epochs≥2** / **H28@r≥32** / **H42@lr=5e-6** /
**H43@α≥64** / **H40@ep≥2** / **H44@clipL1≥0.08** / **H47@α≤8** /
**H46@lr≤2.5e-6** / **H48@lr≤1e-6** / **H45@r≤8** / **H49@α=4** /
**H50@lr=7.5e-6** / **H52@lr=6e-6** / **H53@lr=4e-6** / **H51@α=16**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
King-seed+prefreeze can still ENOENT on w1 — keep outer×3.
Reap orphans via **ppid=1 VLLM::Worker**, not only nvidia-smi PIDs.

## Next action

1. H55: wait `:8001` promptable (recover248b) → n80 retry; decision if done.
2. H54: confirm king health (pid 26558 loading?) → n80 retry; if stuck
   relaunch again with ppid1 Worker kill patch.
3. H56: wait `h56_chall_freeze_pass247.done` → n80.
4. H57: chall completions×2 → n80; ENOENT → H56 p247 prefreeze recipe.
5. H58: train→merge→n80. Next free slot → **lr=5.75e-6** (5.0 off-limits).
