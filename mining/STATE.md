# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H1 REFUTED; H1v2 n80 SIM RUNNING (submit gate).**

Stage 0–3 complete. H2 kevin×pandora REFUTED. H1 full-completion LoRA
**refuted** (n40 −0.00241; n80 −0.01994). **H1v2** thought-only train+merge
DONE → chall :8002 **READY 05:41:16Z** → pipe preferred **n80** (skip n40;
remain_soft=4124s ≥3200) → sim pid **198714** writing
`/root/affine_data/h1v2_sim_result.json`. Soft 06:50Z / deadman 07:00Z.

**Pass 62:** confirmed chall health 200 + prefer-n80 launch.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `kevin954/Affine-5dfqbbh8ev-sft` @ `6a5815fad8f4e34c983b1933c1fae5762fe25220` |
| king S | 0.03955783762471344 |
| reign # | 2 (pandora-m4 still earning as reign 1) |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | verify before submit (`api/v1/contract` submission block) |
| weight_version_key | 1 |
| min_margin | 0.02 (duel) |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $34,072.51 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$161.57** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 verdict | **REFUTED** |
| H1 n40 / n80 | **REFUTED** (do not submit) |
| H1v2 train | **DONE** 05:28:51Z (55/55; thought_ok=440) |
| H1v2 merge | **DONE** 05:35:39Z; `weight_identical: false` |
| H1v2 HF | adapter OK (`…-h1v2-lora`); merged push **191137** still uploading |
| H1v2 serve | :8000/:8001/:8002 all **200** (READY 05:41:16Z) |
| H1v2 n80 | **RUNNING** pid **198714** → `h1v2_sim_result.json` |
| H1v2 pipe | **171602** — n80 launched (prefer-n80) |
| H1v2 HF repos | `unconst/Affine-5czsc2fc98-h1v2-lora` + `…-h1v2-merged` (private) |
| Host harvest | **RUNNING** — pid **1670883** (n80-aware) |
| Host deadman | **ARMED** — pid **1405846** → rm at **07:00Z** |
| Live challenger | **chal-00283** Shatoria/…-test3 **scoring** |
| reg_cost_tao | **~0.724** (snapshot market) |
| Disk | `/root` 465G used / 5.6T avail |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H1v2 n80 sim RUNNING | SSH `root@69.63.236.160 -p 40301`; host deadman 07:00Z |

On pod:
- Teacher:8000 + King:8001 + Chall:8002 **200** (chall=`/root/h1v2/merged`)
- H1v2 n80 sim **198714** → `/root/affine_data/h1v2_sim_result.json`
- Progress: `/root/affine_data/h1v2_sim_progress.json`
- HF merged push **191137** still uploading; adapter already salvaged
- Evidence local: `experiments/s4-h1v2-sft/results/h1v2_n80_launched.json`

Host (no GPU):
- Artifact harvester pid **1670883**
- TTL deadman pid **1405846** @ 07:00Z
- H1v2 code: `experiments/s4-h1v2-sft/`

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** until H1v2 n80 margin > 0.04 + H4 OK.
Time budget: n80 started 05:41 → ~55m → ~06:36 < soft 06:50 / deadman 07:00.

## Next action (single, highest value)

**Poll `/root/affine_data/h1v2_sim_progress.json` → when n80 DONE, harvest
`h1v2_sim_result.json` and run triage → `h1v2_decision.json` (live-king
guard).** Submit only if margin > 0.04 + H4 OK. Also harvest
`h1v2_merged_salvage.json` when push **191137** finishes. Re-check snapshot
(chal-00283+).
