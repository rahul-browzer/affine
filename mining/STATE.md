# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H1 train/merge DONE; CausalLM-save serve bugs FIXED; n40 sim
RUNNING (then n80).**

Stage 0–3 complete. H2 kevin×pandora REFUTED. H1 LoRA train finished
**03:35:57Z** (step 110/110, final loss **0.237**, min **0.175** @80).
Merged `/root/h1/merged` is not weight-identical to kevin. Pass 47 fixed
first_1MiB false-positive; pass 48 found chall vLLM crash from
`AutoModelForCausalLM.save_pretrained` writing **text-only config** +
omitting **model.visual.*** shard. Restored wrapper config +
`model-visual-extra.safetensors` (352 keys); HF salvage patched to
`3364892…`. Chall /health **200** @ **04:10:15Z**; n40 sim pid **137799**
running. Host harvest **1486917**; deadman **1405846** @ **07:00Z**. No
submissions. **kevin still king**; live eval **chal-00279** loading.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `kevin954/Affine-5dfqbbh8ev-sft` @ `6a5815fad8f4e34c983b1933c1fae5762fe25220` |
| king S | 0.03955783762471344 |
| reign # | 2 (pandora-m4 still earning as reign 1) |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | 8767079 (contract submission block; verify before submit) |
| weight_version_key | 1 |
| min_margin | 0.02 (duel) |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $34,212.62 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$125.06** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 verdict | **REFUTED** (`experiments/s4-h2-merge/result.md`) |
| H1 harvest | **DONE** — 440 examples |
| H1 train | **DONE** — 03:35:57Z; step 110; loss final 0.237 / min 0.175@80 |
| H1 mid-ckpt | checkpoint-50 + 100 + **110** on disk; 50+100+final adapter on HF |
| H1 merge | **DONE** — `/root/h1/merged`; `weight_identical: false` |
| H1 identity gate | **FIXED** — multi-window (pass 47) |
| H1 serve hygiene | **FIXED** — restore `qwen3_5_moe` wrapper config + visual shard (pass 48) |
| H1 resume | **RUNNING** — cfgfix pid **132643**; n40 sim **137799** |
| H1 merged HF | `unconst/Affine-5czsc2fc98-h1-merged` @ **3364892cefcc…** (config+visual) |
| Host harvest | **ARMED** — pid **1486917** |
| Host deadman | **ARMED** — pid **1405846** → rm at **07:00Z** |
| H1 triage | **ARMED** — live-king guard; waits for n40/n80 |
| Live challenger | **chal-00279** Tok331102/…-af7 load_challenger |
| reg_cost_tao | **~0.78** (snapshot market) |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H1 n40→n80 sim after config+visual fix | SSH `root@69.63.236.160 -p 40301`; host deadman 07:00Z |

On pod:
- Teacher:8000 + King:8001 + Chall:8002 — all /health **200**
- cfgfix resume pid **132643**, log `/root/logs/h1_cfgfix.nohup`
- n40 sim pid **137799** → `/root/affine_data/h1_sim_result_n40.json`
- After n40: auto n80 → `h1_sim_result.json` (soft deadline 06:50Z)
- Fix meta: `/root/affine_data/h1_config_fix.json`, `h1_visual_shard_fix.json`

Host (no GPU):
- Artifact harvester pid **1486917**
- TTL deadman pid **1405846** @ 07:00Z
- Triage → `results/h1_decision.json` when sim lands

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. Soft deadline 06:50Z; deadman 07:00Z. Do **not** submit until
`results/h1_decision.json` action=`toward_submit` (n80 margin > 0.04 + H4
+ live king match).

## Next action (single, highest value)

**Poll n40:** progress `/root/affine_data/h1_sim_progress_n40.json` →
`h1_sim_result_n40.json` → n80 / `h1_decision.json`. Re-check snapshot
(chal-00279 may crown). Do **not** submit until triage `toward_submit`.
If chall dies again: re-run `resume_after_config_fix.sh` (weights+config+visual
already on disk).
