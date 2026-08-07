# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H13 REFUTED (band); H14–H18 live.**
H1–H13/H5c/H6 **REFUTED**. H14–H18 open. Cap **5/5**. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | $32,905 · ~$1,170 · cap rem ~$2,830 |
| miner | τ10.000 free · 0 submissions |
| H13 | **REFUTED** base×2.047 — pod rm ~$34 |
| H14 | n80 ~55/80 |
| H15 | n80 ~43/80 |
| H16 | n80 retry ~14/80 |
| H17 | merge done; engines wait_ready (t=200 k/c loading) |
| H18 | bootstrap live (Shatoria α0.75) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h14-1 | swift-orbit-cd | 38.255.28.19:20100 | 21:38Z | H14 n80 |
| mine-h15-1 | cosmic-shark-43 | 152.236.142.232:40309 | 21:42Z | H15 n80 |
| mine-h16-1 | cosmic-eagle-2d | 152.236.142.237:40109 | 21:51Z | H16 n80 retry |
| mine-h17-1 | cosmic-orbit-9b | 38.255.28.21:20099 | 21:56Z | H17 serve→n80 |
| mine-h18-1 | zesty-hawk-bc | 18.116.62.104:20119 | 22:36Z | H18 bootstrap |

known_hosts `/tmp/mine-h{14,15,16,17,18}-1.known_hosts`. **0 free slots.**

## Blocked

No submit until some n80 margin > 0.04. No pandora/golden-crown/kevin/
diane/adambell/plmk@α0.75 / kkk-af@α0.75 merges (band). Tok*/alskdjf/qpoewir
gated; kkkkk/mxvb/Sansaliu 404. H17 is α0.90 hedge on kkk-af after H13 band.

## Next action

**Poll nested `*_decision.json` (H14 nearest ~55/80).** On REFUTE:
`lium rm` that `mine-h*-1` only. H17: confirm n80 starts after wait_ready;
if H17 ADVANCE → tear H18 idle. H18: bootstrap→merge→n80. TRY_ALPHA_095 if
gate-valid and 0.02≤m≤0.04; ADVANCE if m>0.04.
