# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H12 n80 ~75/80; H13 merging; H14/H15 boot. H6 REFUTED.** 0–3 done.
H1–H11/H5c/H6 **REFUTED**. H12–H15 open.
No submit. Cap **4/5** (1 free after H6 rm).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | check `contract.submission` (was 8767079) |
| Lium / spend | $33,082 · ~$880 · cap rem ~$3,120 |
| miner | τ10.000 free · 0 submissions |
| H6 | **REFUTED** n80 +0.00330 z=0.54; pod rm'd |
| H12 | n80 ~75/80; inline 3× retry |
| H13 | merging shards → serve→n80 |
| H14 | downloading kkkk |
| H15 | boot TP×leary (pipeline pid 830) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h12-1 | calm-hawk-89 | 152.236.142.237:40311 | 20:42Z | H12 n80 |
| mine-h13-1 | zesty-orbit-df | 38.255.28.22:20099 | ~21:32Z | H13 merge→n80 |
| mine-h14-1 | swift-orbit-cd | 38.255.28.19:20100 | 21:38Z | H14 bootstrap |
| mine-h15-1 | cosmic-shark-43 | 152.236.142.232:40309 | 21:42Z | H15 bootstrap |

known_hosts `/tmp/mine-h{12,13,14,15}-1.known_hosts`. **1 free slot.**

## Blocked

No submit until some n80 margin > 0.04. No pandora/golden-crown/kevin/
diane/adambell merges (band-INVALID at α0.75). No H5c/H6 shortz LoRA retry.
Tok* gated; kkkkk origin 404.

## Next action

**Poll nested `*_decision.json` (H12 ~75/80 first; then H13/H14/H15).**
On REFUTE: `lium rm` that `mine-h*-1` only. Free slot → next accessible
healthy-baseline B (not null-S earners). TRY_ALPHA_085 if 0.02≤m≤0.04;
ADVANCE if m>0.04.
