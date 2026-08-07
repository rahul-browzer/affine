# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H1 n40 DONE (revise_recipe); n80 RUNNING; H1v2 TRAIN + pipe
ARMED; pass-58 teardown/n80-wait/meta fixes deployed.**

Stage 0–3 complete. H2 kevin×pandora REFUTED. H1 full-completion LoRA n40
margin **−0.00241** → `revise_recipe` (H4 r=1.135 fail; clip-L1 collapsed).
n80 restarted after ReadTimeout (timeout 360s×5). **H1v2** thought-only train
on GPUs 6,7 + **post_train_pipeline** waiting on `train.done` → merge∥n80 →
HF salvage → chall serve → n40.

**Pass 55:** pipe adapter path fixed. **Pass 56:** host harvest waits on H1v2
HF push PIDs + triage_sim. **Pass 57:** pipe reordered merge before n80 wait;
freed h2-kp65. **Pass 58:** (1) host early-teardown accepts `got_h1v2` without
H1 n80; (2) pipe n80 wait/pkill scoped to `h1_sim_result` only; (3)
`merge_lora` stages `h1v2_merge_meta.json` under `/h1v2/`. Do **not** submit
H1. kevin still king; live eval **chal-00280** scoring.

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
| Lium balance | $34,134.50 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$146.11** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 verdict | **REFUTED** |
| H1 n40 | **DONE** — margin **−0.00241**; action `revise_recipe` |
| H1 n80 | **RUNNING** — pid **149213**; king/chall **~49/48**/80 @ 05:04Z |
| H1v2 | **TRAINING** — pid **147209**; step **~28**/55; loss **0.381** (step25); ETA ~05:32Z |
| H1v2 pipe | **ARMED** — pid **167913** (merge∥n80; H1-scoped wait) |
| H1v2 mid-salvage | **ARMED** — pid **154590** → `…-h1v2-lora` |
| H1v2 HF repos | `unconst/Affine-5czsc2fc98-h1v2-lora` + `…-h1v2-merged` (private, pre-created) |
| H1 merged HF | `unconst/Affine-5czsc2fc98-h1-merged` @ **3364892cefcc…** |
| Host harvest | **RUNNING** — pid **1662067** (got_h1v2 teardown OK) |
| Host deadman | **ARMED** — pid **1405846** → rm at **07:00Z** |
| Live challenger | **chal-00280** Tok331102/…-af8 **scoring** |
| reg_cost_tao | **~0.890** (snapshot market) |
| Disk | `/root` 397G used / 5.7T avail |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H1 n80 + H1v2 train + pipe + HF salvage | SSH `root@69.63.236.160 -p 40301`; host deadman 07:00Z |

On pod:
- Teacher:8000 + King:8001 + Chall:8002 — all /health **200** (GPUs 0–5)
- H1 n80 sim **149213** (timeout patched 360s×5)
- H1v2 train **147209** on GPUs 6,7 — step ~28/55; log `/root/logs/h1v2_train.nohup`
- H1v2 post-train pipe **167913** — log `/root/logs/h1v2_pipeline.nohup`
- H1v2 mid-ckpt salvage **154590** — log `/root/logs/h1v2_mid_salvage.nohup`
- n40 result: `/root/affine_data/h1_sim_result_n40.json` (harvested)
- n80 out: `/root/affine_data/h1_sim_result.json` + progress `h1_sim_progress.json`
- H1v2 n40 out (when ready): `/root/affine_data/h1v2_sim_result_n40.json`
- Pass-58 evidence: `experiments/s4-h1v2-sft/results/h1v2_teardown_n80_wait_fix.json`

Host (no GPU):
- Artifact harvester pid **1662067**
- TTL deadman pid **1405846** @ 07:00Z
- H1v2 code: `experiments/s4-h1v2-sft/`

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** H1 merged ckpt. H1v2 merge/serve/HF-push
auto via pipe after train.done. Soft 06:50Z / deadman 07:00Z.
Time budget OK (n80 ETA ~05:20Z; train ~05:32Z; n40 ~05:55Z).

## Next action (single, highest value)

**Poll H1v2 train.done** then confirm pipe: merge → HF salvage PIDs → (n80
done or H1-scoped wait) → chall serve → n40. Prefer **H1v2 n40 triage**
(`h1v2_decision.json` / live-king guard) — submit candidate path. Expect H1
n80 to confirm `revise_recipe`. No submit until sim margin > 0.04 + H4 OK.
Re-check snapshot (chal-00280 may crown). Verify H1v2 HF push metas land.
