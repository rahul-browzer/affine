# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H1 n40 DONE (revise_recipe); n80 RUNNING (~11/80); H1v2 PLAN READY.**

Stage 0–3 complete. H2 kevin×pandora REFUTED. H1 full-completion LoRA n40
margin **−0.00241** → `revise_recipe` (H4 r=1.135 fail; clip-L1 collapsed).
n80 confirmation still running on the same merge. **H1v2 plan drafted**
(`experiments/s4-h1v2-sft/plan.md`): thought-only loss + lr 2e-5 / 1 epoch.
Do **not** submit H1 merge. kevin still king; live eval **chal-00280**
dispatching (chal-00279 finished without crowning).

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
| Lium balance | $34,181.35 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$133.70** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 verdict | **REFUTED** |
| H1 n40 | **DONE** — margin **−0.00241**; action `revise_recipe` |
| H1 n80 | **RUNNING** — pid **143331**; king **11**/80 chall **10**/80 @ 04:33Z |
| H1v2 | **PLAN READY** — thought-only distill; not started |
| H1 merged HF | `unconst/Affine-5czsc2fc98-h1-merged` @ **3364892cefcc…** |
| Host harvest | **ARMED** — pid **1486917** |
| Host deadman | **ARMED** — pid **1405846** → rm at **07:00Z** |
| Live challenger | **chal-00280** Tok331102/…-af8 **dispatching** |
| reg_cost_tao | **~0.78** (snapshot market) |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H1 n80 after n40 miss | SSH `root@69.63.236.160 -p 40301`; host deadman 07:00Z |

On pod:
- Teacher:8000 + King:8001 + Chall:8002 — all /health **200**
- cfgfix parent pid **132643**; n80 sim **143331** (~2.5 turns/min; ETA ~05:00Z)
- n40 result: `/root/affine_data/h1_sim_result_n40.json` (harvested)
- n80 out: `/root/affine_data/h1_sim_result.json` + progress `h1_sim_progress.json`

Host (no GPU):
- Artifact harvester pid **1486917**
- TTL deadman pid **1405846** @ 07:00Z
- H1v2 plan: `experiments/s4-h1v2-sft/plan.md`

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** H1 merged ckpt. n80 is confirmation only.
H1v2 train waits until n80 finishes (or soft/deadman) so GPUs 6,7 + chall
slot are free; reuse same pod if TTL allows.

## Next action (single, highest value)

**Poll n80** → when `h1_sim_result.json` appears, re-triage (expect confirm
`revise_recipe`). Then **implement + launch H1v2** on `mine-sim-1` per
`experiments/s4-h1v2-sft/plan.md` (thought-only loss mask + lr=2e-5 / 1ep)
before deadman 07:00Z if possible; else salvage HF and re-rent `mine-*`
under floor/cap. Re-check snapshot (chal-00280 may crown). No submit until
sim margin > 0.04 + H4 OK.
