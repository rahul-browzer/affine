# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5 merge REFUTED; H5b TalentPigs-init thought distill LAUNCHED.**

Stage 0–3 complete. H2 / H1 / H1v2 / **H5 merge** **REFUTED**. Live king
`TalentPigs/affine-5ekxlcg3fx-abc` reign 3 @ S=0.0315. α0.65 INVALID
(base×4.43); α0.50 **unpromptable** (`**` gibberish). Pass 78 launched
H5b thought-only LoRA from TalentPigs init (lr=1e-5) train **245350** +
pipe **245426** + host harvest **1871830**. Deadman **12:00Z**. No submit.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4` |
| king S | 0.031501971059510636 |
| reign # | **3** (kevin reign 2 earning; pandora reign 1) |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | re-check `api/v1/contract` before any submit |
| weight_version_key | 1 |
| min_margin | 0.02 (duel) |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $33,901.01 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **~$203** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 / H1 / H1v2 / H5 merge | **all REFUTED** |
| H5b | **open** — train loading → merge → n80 |
| H1v2 HF merged | public `unconst/Affine-5czsc2fc98-h1v2-merged` @ `a314357…` (do not submit) |
| Disk | host: text only; pod kept `h5-kt65/`; freed broken `h5-kt50/` |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H5b train→n80 | SSH `root@69.63.236.160 -p 40301`; deadman **12:00Z** |

On pod:
- Engines: teacher:8000 + king TalentPigs:8001 — **200**; chall:8002 still
  broken h5-kt50 serve until H5b merge swaps it (or h5-kt65 leftover — either
  way unused until pipe)
- H5b train pid **245350** GPUs 6,7 (`train_lora.py --loss-on thought --lr 1e-5`)
- H5b pipe pid **245426** `post_train_pipeline.sh` → `/root/h5b/merged` → n80
- Markers: `h5b/train/train.done` → `h5b_merge.done` → `h5b_chall_serve.done`
  → `h5b_sim_n80.done` → `h5b_pipeline.done`
- Sim out: `/root/affine_data/h5b_sim_result.json`
- Progress: `/root/affine_data/h5b_sim_progress.json`
- Train log: `/root/logs/h5b_train.nohup`
- Pipe log: `/root/logs/h5b_pipeline.stdout`

Host (no GPU):
- TTL deadman pid **1783662** @ **12:00Z**
- H5b harvest pid **1871830** (`host_harvest_h5b.sh`) stop **11:45Z**
  → SCP → `triage_sim.py` → `results/h5b_decision.json`
- Evidence: `experiments/s4-h5b-talentpigs-distill/results/h5b_launched.json`
- H5 merge closed: `experiments/s4-h5-talentpigs/result.md`

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** H1/H1v2/H2/h5-kt*. Cap remaining ~$3,797.

## Next action (single, highest value)

**Check `experiments/s4-h5b-talentpigs-distill/results/h5b_decision.json`
(or `host_harvest_h5b.done` / `h5b_sim_result.json`).** If present: apply
decision (margin > 0.04 + H4 + live-king → Stage 5; else refute H5b / iterate).
If absent: poll train (pid **245350**, log `/root/logs/h5b_train.nohup`) for
steps/loss → `train.done`; confirm pipe **245426** + harvest **1871830** +
deadman **1783662**. ETA train ~55–70m then merge+serve+n80 ~60–80m → decision
~09:30–10:30Z. Re-check snapshot before any submit. Do not rent another pod.
