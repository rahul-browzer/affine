# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H1 REFUTED (n40+n80); H1v2 TRAIN + pipe ARMED (prefer-n80).**

Stage 0–3 complete. H2 kevin×pandora REFUTED. H1 full-completion LoRA
**refuted**: n40 margin −0.00241; n80 margin **−0.01994** (z=−2.42) →
`revise_recipe`, do not submit. **H1v2** thought-only train on GPUs 6,7 +
post_train_pipeline waiting on `train.done` → merge∥(n80 done) → HF salvage
→ chall serve → **prefer n80** → triage. Soft 06:50Z / deadman 07:00Z.

**Pass 55–59:** adapter path, harvest races, merge∥n80, prefer-n80.
**Pass 60:** harvested H1 n80; H1 closed. kevin still king; live eval
**chal-00283** load_challenger (chal-00281→00283 advanced).

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
| Lium balance | $34,111.44 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$151.76** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 verdict | **REFUTED** |
| H1 n40 | **DONE** — margin **−0.00241** |
| H1 n80 | **DONE** — margin **−0.01994**; action `revise_recipe`; **recipe REFUTED** |
| H1v2 | **TRAINING** — pid **147209**; step **~43**/55; loss **0.400**; ETA ~05:30Z |
| H1v2 pipe | **ARMED** — pid **171602** (prefer n80; H1 n80 already finished) |
| H1v2 mid-salvage | **ARMED** — pid **154590** → `…-h1v2-lora` (save_steps=50) |
| H1v2 HF repos | `unconst/Affine-5czsc2fc98-h1v2-lora` + `…-h1v2-merged` (private) |
| H1 merged HF | `unconst/Affine-5czsc2fc98-h1-merged` @ **3364892cefcc…** (salvage only) |
| Host harvest | **RUNNING** — pid **1670883** (n80-aware) |
| Host deadman | **ARMED** — pid **1405846** → rm at **07:00Z** |
| Live challenger | **chal-00283** Shatoria/…-test3 **load_challenger** |
| reg_cost_tao | **~0.824** (snapshot market) |
| Disk | `/root` 397G used / 5.7T avail |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H1v2 train + pipe + HF salvage | SSH `root@69.63.236.160 -p 40301`; host deadman 07:00Z |

On pod:
- Teacher:8000 + King:8001 + Chall:8002 — all /health **200** (GPUs 0–5; chall still H1 merged until pipe restarts)
- H1 n80 **DONE** — result `/root/affine_data/h1_sim_result.json` (harvested)
- H1v2 train **147209** on GPUs 6,7 — step ~43/55; log `/root/logs/h1v2_train.nohup`
- H1v2 post-train pipe **171602** — prefer n80; waiting train.done
- H1v2 mid-ckpt salvage **154590** — log `/root/logs/h1v2_mid_salvage.nohup`
- H1v2 n80 out (when ready): `/root/affine_data/h1v2_sim_result.json`
- Pass-60 evidence: `experiments/s4-h1-sft/results/h1_n80_confirmed.json`

Host (no GPU):
- Artifact harvester pid **1670883**
- TTL deadman pid **1405846** @ 07:00Z
- H1v2 code: `experiments/s4-h1v2-sft/`

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** H1. H1v2 merge/serve/HF-push/n80 auto via
pipe after train.done. Soft 06:50Z / deadman 07:00Z. Time budget OK:
train~05:30 → merge~05:38 → serve~05:50 → n80 alone (~55m) fits soft/deadman
via prefer-n80 (≥3200s).

## Next action (single, highest value)

**Poll H1v2 train.done** then confirm pipe: merge → HF salvage PIDs →
(H1 n80 already done — skip wait) → chall serve → **H1v2 n80** → triage
`h1v2_decision.json` (live-king guard). Submit only if margin > 0.04 + H4 OK.
Re-check snapshot (chal-00283). Verify H1v2 HF push metas land.
