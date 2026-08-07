# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H12 REFUTED band; H13→n80; H14/H15 merging; H16 α0.90 live.**
H1–H12/H5c/H6 **REFUTED**. H13–H16 open. Cap **4/5**. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | check `contract.submission` |
| Lium / spend | $33,067 · ~$920 · cap rem ~$3,080 |
| miner | τ10.000 free · 0 submissions |
| H12 | **REFUTED** n80 INVALID base×**2.017** (parent duel was ×1.00) |
| H13 | merge done; engines up → n80 |
| H14 | merging ~2/16 |
| H15 | merging ~5/16 |
| H16 | bootstrap (TP×plmk α**0.90**) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h13-1 | zesty-orbit-df | 38.255.28.22:20099 | ~21:32Z | H13 serve→n80 |
| mine-h14-1 | swift-orbit-cd | 38.255.28.19:20100 | 21:38Z | H14 merge→n80 |
| mine-h15-1 | cosmic-shark-43 | 152.236.142.232:40309 | 21:42Z | H15 merge→n80 |
| mine-h16-1 | cosmic-eagle-2d | 152.236.142.237:40109 | 21:51Z | H16 α0.90 boot |

known_hosts `/tmp/mine-h{13,14,15,16}-1.known_hosts`. **1 free slot.**

## Blocked

No submit until some n80 margin > 0.04. No pandora/golden-crown/kevin/
diane/adambell/plmk@α0.75 merges (band). Tok*/alskdjf/qpoewir gated;
kkkkk/mxvb/Sansaliu 404. Parent-duel base× ≠ merge base× (H12).

## Next action

**Poll nested `*_decision.json` (H13 n80 first; then H14/H15/H16).**
On REFUTE: `lium rm` that `mine-h*-1` only. Free slot → next accessible
healthy-baseline B, or α-sweep if band still binds. TRY_ALPHA_095 if
H16 gate-valid and 0.02≤m≤0.04; ADVANCE if m>0.04.
