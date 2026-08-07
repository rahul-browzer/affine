# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H1 train DONE; merge DONE (LoRA applied); first_1MiB gate
FALSE-POSITIVE fixed; resume pipeline RUNNING (HF push + chall re-serve →
n40→n80).**

Stage 0–3 complete. H2 kevin×pandora REFUTED. H1 LoRA train finished
**03:35:57Z** (step 110/110, final loss **0.237**, min **0.175** @80).
Final adapter on HF (`…/h1-lora` commit `4fe72892…`). GPU merge wrote
`/root/h1/merged` but old first_1MiB==kevin check **falsely refused sim**
(embed-leading shard; q/k/v/o_proj + shared_expert.gate differ). Pass 47
rewrote identity probe (head/mid/tail on `model-*-of-*`) and launched
`resume_after_false_identical.sh` pid **127103**: bg merged HF push
**127187** → chall-only re-serve of `/root/h1/merged` → n40→n80. Host
harvest **1486917**; deadman **1405846** @ **07:00Z**. No submissions.
**kevin still king**; chal-00275 cleared; **chal-00276** scoring.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `kevin954/Affine-5dfqbbh8ev-sft` @ `6a5815fad8f4e34c983b1933c1fae5762fe25220` |
| king S | 0.03955783762471344 |
| reign # | 2 (pandora-m4 still earning as reign 1) |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | 8767079 |
| weight_version_key | 1 |
| min_margin | 0.02 (duel) |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $34,235.98 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$119.34** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 verdict | **REFUTED** (`experiments/s4-h2-merge/result.md`) |
| H1 harvest | **DONE** — 440 examples |
| H1 train | **DONE** — 03:35:57Z; step 110; loss final 0.237 / min 0.175@80 |
| H1 mid-ckpt | checkpoint-50 + 100 + **110** on disk; 50+100+final adapter on HF |
| H1 merge | **DONE** — `/root/h1/merged`; `weight_identical: false` |
| H1 identity gate | **FIXED** — multi-window; first_1MiB alone was false-positive |
| H1 resume | **RUNNING** — pid **127103** (`h1_resume.nohup`); push **127187** |
| H1 merged HF salvage | **IN FLIGHT** — `unconst/Affine-5czsc2fc98-h1-merged` |
| Host harvest | **ARMED** — pid **1486917** |
| Host deadman | **ARMED** — pid **1405846** → rm at **07:00Z** |
| H1 triage | **ARMED** — live-king guard; waits for n40/n80 |
| Live challenger | **chal-00276** Sansaliu/…-v1 scoring (king 42/80 @ 03:56Z) |
| reg_cost_tao | **~0.79** (snapshot market) |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H1 resume: push→chall-serve→n40→n80 | SSH `root@69.63.236.160 -p 40301`; host deadman 07:00Z |

On pod:
- Teacher:8000 + King:8001 — /health 200; Chall:8002 loading `/root/h1/merged`
- Resume pid **127103**, log `/root/logs/h1_resume.nohup`
- Merged HF push pid **127187**, log `/root/logs/h1_push_merged.nohup`
- After serve READY: n40 → `h1_sim_result_n40.json` then n80 → `h1_sim_result.json`
- Merge meta: `/root/affine_data/h1_merge_meta.json` (`false_positive_first_1MiB_gate: true`)

Host (no GPU):
- Artifact harvester pid **1486917**
- TTL deadman pid **1405846** @ 07:00Z
- Triage → `results/h1_decision.json` when sim lands

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. Soft deadline 06:50Z; deadman 07:00Z. Chall serve may take
several minutes to load ~68G. Do **not** submit until
`results/h1_decision.json` action=`toward_submit` (n80 margin > 0.04 + H4
+ live king match).

## Next action (single, highest value)

**Poll resume:** chall /health 200 → n40 progress →
`results/h1_sim_result_n40.json` / `h1_decision.json` /
`h1_merged_salvage.json`. Confirm `weight_identical: false` stays. Re-check
snapshot (chal-00276 may crown). Do **not** submit until triage
`toward_submit`. If resume died: re-run
`resume_after_false_identical.sh` (merged weights already on disk).
