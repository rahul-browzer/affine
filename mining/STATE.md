# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H1 REFUTED; H1v2 TRAIN DONE → MERGE DONE → CHALL LOADING → n80 next.**

Stage 0–3 complete. H2 kevin×pandora REFUTED. H1 full-completion LoRA
**refuted** (n40 −0.00241; n80 −0.01994). **H1v2** thought-only train
**DONE** 05:28:51Z → merge **DONE** 05:35:39Z (`weight_identical: false`)
→ HF adapter salvage OK + merged push in flight → chall-only re-serve
loading `/root/h1v2/merged` on :8002. Pipe **171602** will prefer **n80**
when serve READY (remain_soft after ~05:48 ≥3200s). Soft 06:50Z / deadman
07:00Z.

**Pass 55–60:** adapter path, harvest races, merge∥n80, prefer-n80, H1 n80
REFUTED. **Pass 61:** confirmed train.done→merge→HF→chall restart; harvested
metas.

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
| Lium balance | $34,080.33 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$158.87** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 verdict | **REFUTED** |
| H1 n40 / n80 | **REFUTED** (do not submit) |
| H1v2 train | **DONE** 05:28:51Z (55/55; thought_ok=440; elapsed 3139s) |
| H1v2 merge | **DONE** 05:35:39Z; `weight_identical: false` (shard tails ≠; first_1MiB FP OK) |
| H1v2 HF | adapter salvage **OK** (`…-h1v2-lora` @ 6c964d35…); mid ckpt-50/55 OK; merged push **191137** in flight |
| H1v2 serve | chall restart **191471** loading :8002 (teacher/king 200) |
| H1v2 pipe | **171602** — post-merge, waiting chall READY → prefer n80 |
| H1v2 HF repos | `unconst/Affine-5czsc2fc98-h1v2-lora` + `…-h1v2-merged` (private) |
| Host harvest | **RUNNING** — pid **1670883** (n80-aware) |
| Host deadman | **ARMED** — pid **1405846** → rm at **07:00Z** |
| Live challenger | **chal-00283** Shatoria/…-test3 **load_challenger** |
| reg_cost_tao | **~0.731** (snapshot market) |
| Disk | `/root` 397G used / 5.7T avail |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H1v2 merge done; chall load → n80 | SSH `root@69.63.236.160 -p 40301`; host deadman 07:00Z |

On pod:
- Teacher:8000 + King:8001 **200**; Chall:8002 **loading** H1v2 merged (GPUs 4,5)
- H1v2 train **DONE**; adapter `/root/h1v2/train/adapter`
- H1v2 merged `/root/h1v2/merged` (3 shards); merge.done 05:35:39Z
- Pipe **171602** — wait chall READY → **prefer n80** → `/root/affine_data/h1v2_sim_result.json`
- HF push merged pid **191137**; adapter salvage already landed
- Evidence local: `experiments/s4-h1v2-sft/results/h1v2_train_merge_transition.json`

Host (no GPU):
- Artifact harvester pid **1670883**
- TTL deadman pid **1405846** @ 07:00Z
- H1v2 code: `experiments/s4-h1v2-sft/`

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** until H1v2 n80 margin > 0.04 + H4 OK.
Time budget: serve ~05:48 → n80 (~55m) → ~06:43 < soft 06:50 / deadman 07:00.

## Next action (single, highest value)

**Poll chall :8002 /health 200** then confirm pipe launches **H1v2 n80**
(`h1v2_sim_result.json` / progress). Harvest `h1v2_merged_salvage.json` when
push finishes. When n80 done: triage `h1v2_decision.json` (live-king guard).
Submit only if margin > 0.04 + H4 OK. Re-check snapshot (chal-00283+).
