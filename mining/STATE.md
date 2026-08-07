# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H1 n40 DONE (revise_recipe); n80 RUNNING; H1v2 TRAIN + pipe
ARMED with n80-prefer (pass 59); harvest n80-aware.**

Stage 0–3 complete. H2 kevin×pandora REFUTED. H1 full-completion LoRA n40
margin **−0.00241** → `revise_recipe` (H4 r=1.135 fail; clip-L1 collapsed).
n80 restarted after ReadTimeout (timeout 360s×5). **H1v2** thought-only train
on GPUs 6,7 + **post_train_pipeline** waiting on `train.done` → merge∥n80 →
HF salvage → chall serve → **prefer n80** (skip n40 if soft/deadman ≥3200s).

**Pass 55–58:** adapter path, harvest push race, merge∥n80, teardown/n80-wait/
meta. **Pass 59:** pipe preferred n40-only (starved plan.md n80 submit path
under soft 06:50Z); fixed prefer-n80 + harvest SCP/triage. Do **not** submit
H1. kevin still king; live eval **chal-00281** dispatching (chal-00280 lost
margin −0.005).

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
| Lium balance | $34,119.21 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$148.11** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 verdict | **REFUTED** |
| H1 n40 | **DONE** — margin **−0.00241**; action `revise_recipe` |
| H1 n80 | **RUNNING** — pid **149213**; king/chall **~59/59**/80 @ 05:10Z |
| H1v2 | **TRAINING** — pid **147209**; step **~35**/55; loss **0.410** (step35); ETA ~05:29Z |
| H1v2 pipe | **ARMED** — pid **171602** (prefer n80; H1-scoped wait) |
| H1v2 mid-salvage | **ARMED** — pid **154590** → `…-h1v2-lora` |
| H1v2 HF repos | `unconst/Affine-5czsc2fc98-h1v2-lora` + `…-h1v2-merged` (private, pre-created) |
| H1 merged HF | `unconst/Affine-5czsc2fc98-h1-merged` @ **3364892cefcc…** |
| Host harvest | **RUNNING** — pid **1670883** (n80-aware) |
| Host deadman | **ARMED** — pid **1405846** → rm at **07:00Z** |
| Live challenger | **chal-00281** michael-chan-000/…-af9 **dispatching** |
| reg_cost_tao | **~0.890** (snapshot market) |
| Disk | `/root` 397G used / 5.7T avail |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H1 n80 + H1v2 train + pipe + HF salvage | SSH `root@69.63.236.160 -p 40301`; host deadman 07:00Z |

On pod:
- Teacher:8000 + King:8001 + Chall:8002 — all /health **200** (GPUs 0–5)
- H1 n80 sim **149213** (timeout patched 360s×5)
- H1v2 train **147209** on GPUs 6,7 — step ~35/55; log `/root/logs/h1v2_train.nohup`
- H1v2 post-train pipe **171602** — prefer n80; log `/root/logs/h1v2_pipeline.nohup`
- H1v2 mid-ckpt salvage **154590** — log `/root/logs/h1v2_mid_salvage.nohup`
- n40 result: `/root/affine_data/h1_sim_result_n40.json` (harvested)
- H1 n80 out: `/root/affine_data/h1_sim_result.json` + progress `h1_sim_progress.json`
- H1v2 n80 out (when ready): `/root/affine_data/h1v2_sim_result.json`
- Pass-59 evidence: `experiments/s4-h1v2-sft/results/h1v2_prefer_n80_fix.json`

Host (no GPU):
- Artifact harvester pid **1670883**
- TTL deadman pid **1405846** @ 07:00Z
- H1v2 code: `experiments/s4-h1v2-sft/`

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** H1 merged ckpt. H1v2 merge/serve/HF-push/n80
auto via pipe after train.done. Soft 06:50Z / deadman 07:00Z.
Time budget OK if pipe skips n40 → n80 (ETA train~05:29 → serve~05:45 →
n80 done ~06:40).

## Next action (single, highest value)

**Poll H1v2 train.done** then confirm pipe: merge → HF salvage PIDs →
(H1-scoped n80 wait) → chall serve → **H1v2 n80** (not n40) → triage
`h1v2_decision.json` (live-king guard). Submit only if margin > 0.04 + H4 OK.
Expect H1 n80 to confirm `revise_recipe`. Re-check snapshot (chal-00281).
Verify H1v2 HF push metas land.
