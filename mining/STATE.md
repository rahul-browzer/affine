# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H1 n40 DONE (margin −0.0024, revise_recipe); n80 RUNNING.**

Stage 0–3 complete. H2 kevin×pandora REFUTED. H1 LoRA+merge served after
CausalLM config/visual fixes. **n40 vs kevin: margin −0.00241 (z=−0.18),
both valid, H4 FAIL (r=1.135∉[0.70,0.85], base×=0.817).** Triage
`revise_recipe` — **do not submit**. Chall slightly better Λ2 than king but
clip-L1 collapsed (−0.0009 vs king +0.0054). n80 auto-launched 04:27:07Z
(pid **143331**) for cleaner SE; soft 06:50Z / deadman 07:00Z. kevin still
king; live **chal-00279** scoring.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `kevin954/Affine-5dfqbbh8ev-sft` @ `6a5815fad8f4e34c983b1933c1fae5762fe25220` |
| king S | 0.03955783762471344 |
| reign # | 2 (pandora-m4 still earning as reign 1) |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | 8767079 (verify before submit) |
| weight_version_key | 1 |
| min_margin | 0.02 (duel) |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $34,189.24 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$131.54** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 verdict | **REFUTED** |
| H1 n40 | **DONE** — margin **−0.00241**; action `revise_recipe` |
| H1 n80 | **RUNNING** — pid **143331** → `h1_sim_result.json` |
| H1 merged HF | `unconst/Affine-5czsc2fc98-h1-merged` @ **3364892cefcc…** |
| Host harvest | **ARMED** — pid **1486917** |
| Host deadman | **ARMED** — pid **1405846** → rm at **07:00Z** |
| Live challenger | **chal-00279** Tok331102/…-af7 scoring (~57/80 king @ 04:27Z) |
| reg_cost_tao | **~0.78** (snapshot market) |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H1 n80 after n40 miss | SSH `root@69.63.236.160 -p 40301`; host deadman 07:00Z |

On pod:
- Teacher:8000 + King:8001 + Chall:8002 — all /health **200**
- cfgfix parent pid **132643**; n80 sim **143331**
- n40 result: `/root/affine_data/h1_sim_result_n40.json` (harvested)
- n80 out: `/root/affine_data/h1_sim_result.json` + progress `h1_sim_progress.json`

Host (no GPU):
- Artifact harvester pid **1486917**
- TTL deadman pid **1405846** @ 07:00Z
- Triage already wrote `experiments/s4-h1-sft/results/h1_decision.json`

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** this H1 merged ckpt (n40 already
`revise_recipe`). n80 is confirmation only.

## Next action (single, highest value)

**Poll n80** → `/root/affine_data/h1_sim_progress.json` →
`h1_sim_result.json` → re-triage. Expect confirm `revise_recipe`. Then plan
**H1v2** (fix r/L1 envelope: lower lr / fewer steps / loss on z_C only / or
H5 warm-start) — do **not** burn a slot on this merge. Re-check snapshot
(chal-00279 may crown). If pod dies: HF salvage @3364892… + adapters remain.
