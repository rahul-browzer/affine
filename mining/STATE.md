# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H14/H15 REFUTED (band); H16–H20 live.**
H1–H15/H5c/H6 **REFUTED**. H16–H20 open. Cap **5/5**. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | see contract.submission (was 8767079) |
| Lium / spend | $32,840 · ~$1,285 · cap rem ~$2,715 |
| miner | τ10.000 free · 0 submissions |
| H14/H15 | REFUTED band; pods rm |
| H16 | n80 **52/80** |
| H17 | n80 **38/80** |
| H18 | re-bootstrapped on real 8×H200 (dud rm) |
| H19 | bootstrap (teacher dl) |
| H20 | bootstrap (teacher dl) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h16-1 | cosmic-eagle-2d | 152.236.142.237:40109 | 21:51Z | H16 n80 |
| mine-h17-1 | cosmic-orbit-9b | 38.255.28.21:20099 | 21:56Z | H17 n80 |
| mine-h18-1 | golden-comet-e1 | 152.236.142.232:40307 | 22:57Z | H18 bootstrap |
| mine-h19-1 | eager-eagle-c6 | 152.236.142.234:40297 | 22:50Z | H19 bootstrap |
| mine-h20-1 | swift-lion-ac | 38.255.28.22:20100 | 22:53Z | H20 bootstrap |

known_hosts `/tmp/mine-h{16,17,18,19,20}-1.known_hosts`. **0 free slots.**

## Blocked

No submit until some n80 margin > 0.04. Prior H18 pod zesty-hawk-bc
@$5.66 claimed 8×H200 but exposed **2** GPUs — rm + re-rent @$28/h.
α0.90 hedges H16/H17/H19/H20; H18 α0.75 weak-B continues on good iron.

## Next action

**Poll nested `*_decision.json` (H16 nearest ~52/80).** On REFUTE:
`lium rm` that `mine-h*-1` only. H18: confirm merge→serve (8 GPUs)→n80.
H19/H20: bootstrap→merge→n80. TRY_ALPHA_095 if gate-valid and
0.02≤m≤0.04; ADVANCE if m>0.04. If α0.90 also bands → stop α-sweeps.
