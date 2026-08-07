# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H12 REFUTED; H13–H16 n80; H17 teacher DL.**
H1–H12/H5c/H6 **REFUTED**. H13–H17 open. Cap **5/5**. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | $32,960 · ~$1,070 · cap rem ~$2,930 |
| miner | τ10.000 free · 0 submissions |
| H13 | n80 ~50/80 |
| H14 | n80 ~16/80 |
| H15 | n80 ~12/80 |
| H16 | n80 live (ALL_READY 14:21Z; t/k/c=200) |
| H17 | parents done; teacher GLM DL |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h13-1 | zesty-orbit-df | 38.255.28.22:20099 | 21:32Z | H13 n80 |
| mine-h14-1 | swift-orbit-cd | 38.255.28.19:20100 | 21:38Z | H14 n80 |
| mine-h15-1 | cosmic-shark-43 | 152.236.142.232:40309 | 21:42Z | H15 n80 |
| mine-h16-1 | cosmic-eagle-2d | 152.236.142.237:40109 | 21:51Z | H16 n80 |
| mine-h17-1 | cosmic-orbit-9b | 38.255.28.21:20099 | 21:56Z | H17 teacher DL→merge |

known_hosts `/tmp/mine-h{13,14,15,16,17}-1.known_hosts`. **0 free slots.**

## Blocked

No submit until some n80 margin > 0.04. No pandora/golden-crown/kevin/
diane/adambell/plmk@α0.75 merges (band). Tok*/alskdjf/qpoewir gated;
kkkkk/mxvb/Sansaliu 404. Next accessible weak B: Shatoria test3 (+0.0017).

## Next action

**Poll nested `*_decision.json` (H13 first — nearest finish).** On REFUTE:
`lium rm` that `mine-h*-1` only. If H13 ADVANCE → tear H17. If H13
band-INVALID → keep H17. Free slot → Shatoria α0.75. TRY_ALPHA_095 if
gate-valid and 0.02≤m≤0.04; ADVANCE if m>0.04.
