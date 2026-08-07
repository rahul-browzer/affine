# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H1 n40 DONE (revise_recipe); n80 RESTARTED; H1v2 TRAIN + post-train PIPE ARMED.**

Stage 0–3 complete. H2 kevin×pandora REFUTED. H1 full-completion LoRA n40
margin **−0.00241** → `revise_recipe` (H4 r=1.135 fail; clip-L1 collapsed).
n80 died mid-run on `httpx.ReadTimeout` @ ~16/80; **restarted** with
timeout 360s / 5 retries. **H1v2** thought-only train on GPUs 6,7 +
**post_train_pipeline** waiting on `train.done` → merge → chall serve → n40.
Do **not** submit H1 merge. kevin still king; live eval **chal-00280**
load_challenger.

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
| Lium balance | $34,165.93 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$136.96** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 verdict | **REFUTED** |
| H1 n40 | **DONE** — margin **−0.00241**; action `revise_recipe` |
| H1 n80 | **RESTARTED** — pid **149213** @ 04:39:52Z (was dead ReadTimeout); engines 200×3 |
| H1v2 | **TRAINING** — pid **147209**; step **3**/55 @ ~59s/step; ETA ~05:32Z |
| H1v2 pipe | **ARMED** — pid **149216** waits `train.done` → merge→serve→n40 |
| H1 merged HF | `unconst/Affine-5czsc2fc98-h1-merged` @ **3364892cefcc…** |
| Host harvest | **ARMED** — pid **1486917** |
| Host deadman | **ARMED** — pid **1405846** → rm at **07:00Z** |
| Live challenger | **chal-00280** Tok331102/…-af8 **load_challenger** |
| reg_cost_tao | **~0.78** (snapshot market) |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H1 n80 + H1v2 train + pipe | SSH `root@69.63.236.160 -p 40301`; host deadman 07:00Z |

On pod:
- Teacher:8000 + King:8001 + Chall:8002 — all /health **200** (GPUs 0–5)
- H1 n80 sim **149213** (restarted; timeout patched 360s×5)
- H1v2 train **147209** on GPUs 6,7 — step 3/55; log `/root/logs/h1v2_train.nohup`
- H1v2 post-train pipe **149216** — log `/root/logs/h1v2_pipeline.nohup`
- n40 result: `/root/affine_data/h1_sim_result_n40.json` (harvested)
- n80 out: `/root/affine_data/h1_sim_result.json` + progress `h1_sim_progress.json`
- H1v2 n40 out (when ready): `/root/affine_data/h1v2_sim_result_n40.json`

Host (no GPU):
- Artifact harvester pid **1486917**
- TTL deadman pid **1405846** @ 07:00Z
- H1v2 code: `experiments/s4-h1v2-sft/` (plan + train + start + post_train_pipeline)

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** H1 merged ckpt. H1v2 merge/serve auto via
pipe after train.done (pipe waits for n80 to finish before chall restart,
or kills sim if <45m to soft 06:50Z). Soft 06:50Z / deadman 07:00Z.

## Next action (single, highest value)

**Poll H1v2 train** (`train.done` / step progress) and **n80**
(`h1_sim_result.json`). Prefer H1v2 n40 triage once pipe finishes — that is
the submit candidate path. Expect H1 n80 to confirm `revise_recipe`. No
submit until sim margin > 0.04 + H4 OK. Re-check snapshot (chal-00280 may
crown).
