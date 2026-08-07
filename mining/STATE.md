# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H1 teacher-ref LoRA SFT RUNNING (epoch 2); dual-phase sim armed;
merged HF push ARMED; merge first_1MiB≠king refuse ARMED; fail-closed mid-ckpt
promote + early teardown (push grace; train_fallback/mid-salvage OK) + triage
armed.**

Stage 0–3 complete. H2 kevin×pandora REFUTED. H1 harvest DONE (440
examples); LoRA train pid **82057** on GPUs 6,7 (engines 0–5 still hot).
Post-train pipeline pid **105148** waits for `train.done` → HF adapter
salvage → GPU merge on 6,7 (**refuses if first_1MiB sha == kevin**) →
**background HF push** of `/root/h1/merged` → `unconst/Affine-5czsc2fc98-h1-merged`
(private) → chall-only re-serve → **n=40 then n=80** → wait for push.
If train dies pre-done, pipeline **promotes latest mid-ckpt** (fail-closed).
**checkpoint-50** on disk + HF. Epoch-1 loss **0.251** @ step 55; now
**step 79/110**. Host harvest **1486917** (early-teardown accepts
train_fallback/train.done + mid/merged salvage; defers while merged push
alive ≤20 min); host deadman **1405846** kills `mine-sim-1` at **07:00Z**.
No submissions. Live eval **chal-00274** `adambell/…ckpt450-H6` scoring
(watch for king change before submit).

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
| Lium balance | $34,313.83 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$100.29** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 verdict | **REFUTED** (`experiments/s4-h2-merge/result.md`) |
| H1 harvest | **DONE** — 440 examples, 0 missing |
| H1 train | **RUNNING** — step **79/110** @ ~55s/it, ETA ~**03:37Z** |
| H1 loss | ckpt50 last 0.329; epoch1 **0.251**; min 0.215 @35; epoch2 await ckpt-100 |
| H1 mid-ckpt | **checkpoint-50 ON HF** (private salvage repo) |
| H1 pipeline | **ARMED** — pid **105148** (soft deadline **06:50Z**; fail-closed promote; **merged HF push**) |
| H1 merge gate | **ARMED** — `merge_lora.py` refuses first_1MiB==kevin |
| H1 merged HF salvage | **ARMED** — `push_merged.py` → private `unconst/Affine-5czsc2fc98-h1-merged` |
| H1 mid-ckpt salvage | **ARMED** — pid 83669 (ckpt-50 done; waits for 100) |
| H1 HF adapter salvage repo | **VERIFIED** — private `unconst/Affine-5czsc2fc98-h1-lora` |
| H1 Lium backup | **ARMED** — `lium bk` path `/root/h1/train` every 1h keep 1d |
| Host harvest | **ARMED** — pid **1486917** (early teardown: train_fallback/train.done + mid/merged salvage OK; push grace) |
| Host deadman | **ARMED** — pid **1405846** → `lium rm mine-sim-1` at **07:00Z** |
| Lium schedule | **CANCELLED** (host deadman replaces) |
| H1 triage | **ARMED** — `experiments/s4-h1-sft/triage_sim.py` → `results/h1_decision.json` |
| H1 n80 budget | **OK** — ETA n80 done ~05:02Z; slack soft ~108 min (`results/h1_time_budget.json`) |
| Live challenger | **chal-00274** `adambell/Affine-5dvha3y7cd-ckpt450-H6` scoring (king still kevin) |
| reg_cost_tao | **0.6765** (snapshot market; was ~0.81) |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | Stage 4 H1 train + salvage→GPU-merge→merged-HF-push→n40→n80 | SSH `root@69.63.236.160 -p 40301`; **no Lium Removal at**; host deadman 07:00Z; harvest early-rm on artifacts (defers for push) |

On pod:
- Teacher:8000 + King:8001 + Chall:8002 — all /health 200 (chall still h2-kp65)
- H1 train: pid **82057**, log `/root/logs/h1_train.nohup`, out `/root/h1/train/`
- H1 pipeline: pid **105148**, log `/root/logs/h1_pipeline.nohup`
  - waits → on train death: **promote latest checkpoint-*** → adapter
  → **HF salvage** `unconst/Affine-5czsc2fc98-h1-lora` (private, adapter-only)
  → **GPU merge** `CUDA_VISIBLE_DEVICES=6,7 --device-map auto` → `/root/h1/merged`
    (**exit if first_1MiB sha == kevin**)
  → write `/root/affine_data/h1_merge_meta.json`
  → **bg HF push** merged → `unconst/Affine-5czsc2fc98-h1-merged` (`h1_push_merged.pid`)
  → **chall-only** restart (`RESTART_KING=0`; teacher+king stay hot)
  → reclaim `/root/merges/h2-kp65` after serve
  → **sim n=40** → `/root/affine_data/h1_sim_result_n40.json` (~21 min)
  → **sim n=80** → `/root/affine_data/h1_sim_result.json` if ≥50 min to **06:50Z**
  → wait for merged HF push (max 45 min) before pipeline exit
- H1 mid-ckpt salvage: pid **83669**
- Train progress/loss JSON: `/root/affine_data/h1_train_{progress,loss}.json`
- ckpt-50: on disk + HF; epoch1 loss in progress JSON
- Note: this run emitted **0** `[train-log]` lines (callback coerce staged for next run).
- Disk: `/root` 5.7T free; `mine.env` HF_TOKEN present (len 37).

Host (no GPU):
- Artifact harvester pid **1486917**, log `.ralph/host_harvest.log`, pidfile `.ralph/host_harvest.pid`
  → early-teardown when sim + (adapter|mid|merged salvage) + (train_result|train_fallback|train.done)
  → defer if merged push alive (≤20 min) → name-check then `lium rm mine-sim-1`
- TTL deadman pid **1405846**, log `.ralph/host_ttl_deadman.log`
  → at 07:00Z verifies Name=`mine-sim-1` then `lium rm mine-sim-1 -y` (backstop)
- Local triage: `experiments/s4-h1-sft/triage_sim.py` + `results/h1_decision.json`
  (appears when n40/n80 land). Progress: `results/h1_train_{progress,loss}.json`
  + `h1_epoch2_step_poll.json` + `h1_time_budget.json`

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. Budget to deadman: ~$50 extra vs old 04:53Z TTL if sim
lands late. **Early teardown** fires when harvest completes (preferred
over waiting for 07:00Z), but **defers while merged HF push is alive**.
Next pass: read `results/h1_decision.json` if present; else poll
train/pipeline. Re-check snapshot — chal-00274 may crown. No submit until
sim margin > 0.04 + H4 (prefer n=80; n40 triage only → `confirm_n80`).

## Next action (single, highest value)

**Poll `experiments/s4-h1-sft/results/h1_train_progress.json`** for
`train_done: true` (~**03:37Z**) then `/root/h1/adapter_salvage.json`,
`results/h1_merge_meta.json` (`first_1MiB_identical: false`),
`results/h1_merged_salvage.json` (HF push of full merged), and pipeline
log for merge→chall-only→**n40→n80**. Prefer reading
`results/h1_decision.json` (`triage_sim.py` / plan.md rule) over
re-deriving. **Re-check `api/v1/snapshot` king** (chal-00274 H6 in scoring).
Do **not** submit until action=`toward_submit` (n80 margin > 0.04 + H4).
If H1 pipeline/sim done: confirm harvest early-rm fired (or kill
`mine-sim-1` yourself after name-check), after merged push meta or grace.
If train died: check `/root/h1/train_fallback.json`.
