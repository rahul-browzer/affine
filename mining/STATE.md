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
| Lium / spend | **~$188,518** · cum mining ~$6,584 · **avail ~$178.5k** |
| miner | τ10.000 free · 0 submissions |
| H54 | king p248 loading (torch.compile) → n80 wait |
| H55 | king p248 CUDA-graph capture → n80 wait |
| H56 | chall p247 prefreeze warmup after health@poll33 |
| H57 | king Triton ENOENT mid-n80 → **p249 chall-seed prefreeze** |
| H58 | train lr5.1e-6 early (no trainer_state yet) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h54-1 | calm-matrix-9c | 152.236.142.236:40300 | ~16:23Z | king load→n80 |
| mine-h55-1 | lunar-shark-0b | 38.255.28.19:20100 | ~16:36Z | king load→n80 |
| mine-h56-1 | swift-fox-1d | 152.236.142.237:40099 | ~16:38Z | chall prefreeze p247 |
| mine-h57-1 | eager-shark-95 | 38.255.28.18:20100 | ~16:44Z | king prefreeze p249 |
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
King mid-n80 ENOENT → chall-seed+prefreeze (p249), not bare relaunch.

## Next action

1. H57: wait `h57_king_freeze_pass249.done` → n80 a203; w1 fail → outer continues.
2. H55/H54: king health+completions → n80; if first warmup ENOENT upgrade to
   p249 prefreeze (do not bare-relaunch again).
3. H56: wait `h56_chall_freeze_pass247.done` → n80.
4. H58: train→merge→n80. Next free slot → **lr=5.75e-6** (5.0 off-limits).
