# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5 α0.65 merge READY; n80 sim RUNNING vs TalentPigs.**

Stage 0–3 complete. H2 / H1 / H1v2 **REFUTED**. Live king
`TalentPigs/affine-5ekxlcg3fx-abc` reign 3 @ S=0.0315. H5 merge at
`/root/merges/h5-kt65/` (α=0.65 kevin×TalentPigs; weight_identical=false).
Pass 72: chall:8002 **200** (`h5_chall_serve.done` @ 06:46:53Z) → n80
sim pid **235312** sampling. Host deadman **12:00Z** (pid **1783662**).
No submit.

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
| Lium balance | $33,971.35 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$185.40** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 / H1 / H1v2 | **all REFUTED** |
| H5 | **open** — chall READY; n80 sim RUNNING |
| H1v2 HF merged | public `unconst/Affine-5czsc2fc98-h1v2-merged` @ `a314357…` (do not submit) |
| Disk | host: text only; pod merge at `/root/merges/h5-kt65/` (~67G) |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H5 n80 sim | SSH `root@69.63.236.160 -p 40301`; deadman **12:00Z** |

On pod:
- Engines: teacher:8000 + king TalentPigs:8001 + chall h5-kt65:8002 — **all 200**
- Resume pipe pid **231961** `resume_after_merge.sh` (parent of sim)
- Sim pid **235312** `run_sim_duel.py` n=80 vs TalentPigs
- Done markers: `h5_merge.done` → `h5_chall_serve.done` @ 06:46:53Z →
  next `h5_sim_n80.done` → `h5_merge_sim.done`
- Identity: out 2-shard vs king 16-shard; `identical_to_king=false`
  (`results/h5_kt65_identity.json`)
- Sim out: `/root/affine_data/h5_kt65_sim_result.json`
- Progress: `/root/affine_data/h5_kt65_sim_progress.json`
- Log: `/root/logs/h5_kt65_sim.nohup` (+ `/root/logs/h5_merge_sim.stdout`)
- Evidence: `experiments/s4-h5-talentpigs/results/h5_chall_ready_n80_launched.json`
- Plan: `experiments/s4-h5-talentpigs/plan.md`
- ETA: ~40–50m from 06:47Z → ~07:30–08:00Z (prior n80 cadence)

Host (no GPU):
- TTL deadman pid **1783662** @ **12:00Z**
- Harvest: killed (pass 68); re-arm after n80 if needed for SCP

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** H1/H1v2/H2. Cap remaining ~$3,815.

## Next action (single, highest value)

**Poll `/root/affine_data/h5_kt65_sim_progress.json` then
`/root/logs/h5_sim_n80.done`.** When sim done: SCP
`h5_kt65_sim_result.json` (+ artifact/meta) → triage (margin > 0.04 + H4
+ live-king guard). If 0.02≤margin≤0.04 try α=0.50; if margin < 0.02
refute H5 merge parents → TalentPigs-init thought distill. Re-check
snapshot before any submit path. Do not rent another pod.
