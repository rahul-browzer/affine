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
| Lium / spend | **~$188,555** · cum mining ~$6,547 · **avail ~$178.6k** |
| miner | τ10.000 free · 0 submissions |
| H51 | **REFUTE** m=+0.00855 · pod rm'd |
| H54 | a2 triple-promptable + freeze.done → n80 armed |
| H55 | **n80 live** ~13/80 (a203) |
| H56 | chall `__triton_launcher` ENOENT → **pass247 prefreeze** |
| H57 | merge OK_NON_IDENTICAL → chall re-serve starting |
| H58 | bootstrap / m7 download |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h54-1 | calm-matrix-9c | 152.236.142.236:40300 | ~16:23Z | H54 freeze.done → n80 |
| mine-h55-1 | lunar-shark-0b | 38.255.28.19:20100 | ~16:36Z | H55 n80 ~13/80 |
| mine-h56-1 | swift-fox-1d | 152.236.142.237:40099 | ~16:38Z | H56 chall prefreeze a1 |
| mine-h57-1 | eager-shark-95 | 38.255.28.18:20100 | ~16:44Z | H57 chall re-serve→n80 |
| mine-h58-1 | eager-matrix-0d | 38.255.28.21:20099 | ~17:22Z | H58 bootstrap→train |

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
King-seed+prefreeze can still ENOENT on w1 (H54 a1) — keep outer×3.

## Next action

1. H55: wait n80 → decision; if m>0.04 prepare submit path, else REFUTE+rm.
2. H54: `h54_chall_freeze_pass246.done` present (a2 w1–w3=200); confirm n80 starts.
3. H56: wait `h56_chall_freeze_pass247.done` → n80 (`relaunch_chall_pass247.sh`
   running; do not `lium rm`).
4. H57: chall health+completions → n80; if `__triton_launcher` ENOENT, copy
   H56 pass247 prefreeze recipe.
5. H58: train→merge→n80. Fill freed slots with open lr **5.25 already live**;
   next free → **5.0 re-check off-limits** — open **5.75** or wait curve.
