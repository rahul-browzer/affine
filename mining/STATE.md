# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5 α0.65 merge n80 sim ADVANCING; host harvest ARMED.**

Stage 0–3 complete. H2 / H1 / H1v2 **REFUTED**. Live king
`TalentPigs/affine-5ekxlcg3fx-abc` reign 3 @ S=0.0315. H5 merge at
`/root/merges/h5-kt65/` (α=0.65 kevin×TalentPigs; weight_identical=false).
Pass 76: n80 sim pid **235312** at king **48**/80 / chall **51**/80
(120s recheck: 39→48 / 42→51 @ **3.48** tpm both; king bottleneck).
ETA finish **~07:13Z** (earlier than pass75 ~07:29Z). Host harvest
**1818104** still armed. Deadman **12:00Z**. No submit.

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
| Lium balance | $33,947.67 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$192.92** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 / H1 / H1v2 | **all REFUTED** |
| H5 | **open** — n80 ADVANCING (~king48/chall51); ETA ~07:13Z; harvest armed |
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
- Progress @ 07:03:44Z: king **48**/80, chall **51**/80
- Rate (155s sample): king **3.48**/min, chall **3.48**/min (king bottleneck)
  → ETA **~07:13Z**
- Done markers: `h5_merge.done` → `h5_chall_serve.done` → next
  `h5_sim_n80.done` → `h5_merge_sim.done`
- Identity: out 2-shard vs king 16-shard; `identical_to_king=false`
- Sim out: `/root/affine_data/h5_kt65_sim_result.json`
- Progress: `/root/affine_data/h5_kt65_sim_progress.json`
- Log: `/root/logs/h5_kt65_sim.nohup`

Host (no GPU):
- TTL deadman pid **1783662** @ **12:00Z**
- H5 harvest pid **1818104** (`host_harvest_h5.sh`) stop **11:45Z**
  → SCP result + `triage_sim.py` → `results/h5_decision.json`
- Evidence: `results/h5_n80_midflight_rate.json` (pass 76)
- Plan: `experiments/s4-h5-talentpigs/plan.md`

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** H1/H1v2/H2. Cap remaining ~$3,807.

## Next action (single, highest value)

**Check `experiments/s4-h5-talentpigs/results/h5_decision.json` (or
`host_harvest_h5.done` / `h5_kt65_sim_result.json`).** If present: apply
decision (margin > 0.04 + H4 + live-king → Stage 5 path; 0.02–0.04 →
α=0.50 merge; <0.02 → refute merge → TalentPigs-init thought distill).
If absent: poll pod progress / `h5_sim_n80.done`; confirm harvest
**1818104** still alive. Expected finish ~07:13Z. Re-check snapshot
before any submit. Do not rent another pod.
