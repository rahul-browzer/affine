# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H1 REFUTED; H1v2 n80 SIM RUNNING (submit gate).**

Stage 0–3 complete. H2 kevin×pandora REFUTED. H1 full-completion LoRA
**refuted** (n40 −0.00241; n80 −0.01994). **H1v2** thought-only train+merge
DONE → chall :8002 READY → prefer-n80 sim pid **198714** RUNNING
(~16/80 @ 05:50). Soft 06:50Z / deadman 07:00Z.

**Pass 64:** confirmed H1v2 merged HF public salvage **DONE**
`unconst/Affine-5czsc2fc98-h1v2-merged` @ `a31435754de2974e63779f53e953ee1433eaf295`
(05:49:40Z). Also publicized H1/H1v2 LoRA adapters (private-quota hygiene).

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `kevin954/Affine-5dfqbbh8ev-sft` @ `6a5815fad8f4e34c983b1933c1fae5762fe25220` |
| king S | 0.03955783762471344 |
| reign # | 2 (pandora-m4 still earning as reign 1) |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | 8767079 (`api/v1/contract` → subnet) |
| weight_version_key | 1 |
| min_margin | 0.02 (duel) |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $34,056.97 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$164.13** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 verdict | **REFUTED** |
| H1 n40 / n80 | **REFUTED** (do not submit) |
| H1v2 train | **DONE** 05:28:51Z (55/55; thought_ok=440) |
| H1v2 merge | **DONE** 05:35:39Z; `weight_identical: false` |
| H1v2 HF adapter | OK `unconst/Affine-5czsc2fc98-h1v2-lora` @ `6c964d35…` (**public**) |
| H1v2 HF merged | **DONE** public @ `a31435754de2974e63779f53e953ee1433eaf295` |
| H1 HF merged | **public** (quota fix; recipe refuted) |
| H1v2 serve | :8000/:8001/:8002 all **200** |
| H1v2 n80 | **RUNNING** pid **198714** → `h1v2_sim_result.json` (~16/80) |
| H1v2 pipe | **171602** |
| Host harvest | **RUNNING** — pid **1670883** (n80-aware) |
| Host deadman | **ARMED** — pid **1405846** → rm at **07:00Z** |
| Live challenger | **chal-00283** Shatoria/…-test3 **scoring** ~77/80; queue chal-00284+ |
| Disk | `/root` plenty (pod); host not used for weights |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H1v2 n80 sim (merged HF salvage DONE) | SSH `root@69.63.236.160 -p 40301`; host deadman 07:00Z |

On pod:
- Teacher:8000 + King:8001 + Chall:8002 **200** (chall=`/root/h1v2/merged`)
- H1v2 n80 sim **198714** → `/root/affine_data/h1v2_sim_result.json`
- Progress: `/root/affine_data/h1v2_sim_progress.json` (~king16/chall15 @ 05:50)
- HF merged push **DONE** → `unconst/Affine-5czsc2fc98-h1v2-merged` @ `a314357…`
- Evidence: `experiments/s4-h1v2-sft/results/h1v2_merged_salvage_confirmed.json`

Host (no GPU):
- Artifact harvester pid **1670883**
- TTL deadman pid **1405846** @ 07:00Z

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** until H1v2 n80 margin > 0.04 + H4 OK.
Time budget: n80 ~16/80 @ 05:50 → ETA ~06:30 < soft 06:50 / deadman 07:00.
Merged HF salvage complete — deadman no longer erases the only copy.

## Next action (single, highest value)

**Poll `/root/affine_data/h1v2_sim_progress.json` → when n80 DONE, harvest
`h1v2_sim_result.json` and run triage → `h1v2_decision.json` (live-king
guard).** Submit only if margin > 0.04 + H4 OK. Re-check snapshot
(chal-00283 finishing ~77/80 — king may change).
