# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5 α0.65 REFUTED (gates); α0.50 merge+n80 LAUNCHED.**

Stage 0–3 complete. H2 / H1 / H1v2 **REFUTED**. Live king
`TalentPigs/affine-5ekxlcg3fx-abc` reign 3 @ S=0.0315. α0.65
`h5-kt65` n80 DONE: chall **INVALID** (baseline_band; base×=**4.43**);
margin forced 0; triage `reject_gates`; submit=false. Pass 77 launched
α=0.50 → `/root/merges/h5-kt50/` pipe **240001** + host harvest
**1847826**. Deadman **12:00Z**. No submit.

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
| Lium balance | $33,924.61 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$198.35** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 / H1 / H1v2 | **all REFUTED** |
| H5 α0.65 | **failed gates** — base×4.43 band; see `h5_decision.json` |
| H5 α0.50 | **open** — merge running → chall serve → n80 |
| H1v2 HF merged | public `unconst/Affine-5czsc2fc98-h1v2-merged` @ `a314357…` (do not submit) |
| Disk | host: text only; pod merges `h5-kt65/` + `h5-kt50/` (~67G each) |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H5 α0.50 merge→n80 | SSH `root@69.63.236.160 -p 40301`; deadman **12:00Z** |

On pod:
- Engines: teacher:8000 + king TalentPigs:8001 — **200**; chall:8002 still
  h5-kt65 until α0.50 serve swaps it
- α0.50 pipe pid **240001** `start_merge_sim_a50.sh`
- merge_linear pid **240011** α=0.50 → `/root/merges/h5-kt50/`
- Markers: `h5_a50_merge.done` → `h5_a50_chall_serve.done` →
  `h5_a50_sim_n80.done` → `h5_a50_merge_sim.done`
- Sim out: `/root/affine_data/h5_kt50_sim_result.json`
- Progress: `/root/affine_data/h5_kt50_sim_progress.json`
- Log: `/root/logs/h5_a50_merge_sim.nohup`

Host (no GPU):
- TTL deadman pid **1783662** @ **12:00Z**
- H5 α0.50 harvest pid **1847826** (`host_harvest_h5_a50.sh`) stop **11:45Z**
  → SCP → `triage_sim.py` → `results/h5_a50_decision.json`
- α0.65 artifacts: `results/h5_decision.json`, `h5_kt65_sim_result.json`,
  `result.md`
- Evidence: `results/h5_a50_launched.json`
- Plan: `experiments/s4-h5-talentpigs/plan.md`

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** H1/H1v2/H2/h5-kt65. Cap remaining ~$3,802.

## Next action (single, highest value)

**Check `experiments/s4-h5-talentpigs/results/h5_a50_decision.json` (or
`host_harvest_h5_a50.done` / `h5_kt50_sim_result.json`).** If present: apply
decision (margin > 0.04 + H4 + live-king → Stage 5; else if still gate-fail
or margin < 0.02 → **refute H5 merge parents** → launch TalentPigs-init
thought distill). If absent: poll pod for `h5_a50_merge.done` /
`h5_a50_chall_serve.done` / sim progress; confirm harvest **1847826** +
deadman **1783662**. Re-check snapshot before any submit. Do not rent
another pod.
