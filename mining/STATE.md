# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5 merge DONE; chall:8002 loading → n80 pending.**

Stage 0–3 complete. H2 / H1 / H1v2 **REFUTED**. Live king
`TalentPigs/affine-5ekxlcg3fx-abc` reign 3 @ S=0.0315. H5 α=0.65 merge
wrote `/root/merges/h5-kt65/` (321s; weight_identical=false vs kevin and
king). Pass-70 pipe **231222** died after merge on a shard-layout bug
(TalentPigs=16-shard, check looked for 2-shard name). Pass 71 fixed
check + launched `resume_after_merge.sh` pid **231961** → chall serve
`/root/merges/h5-kt65`:8002 loading → n80. Host deadman **12:00Z** (pid
**1783662**). No submit.

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
| Lium balance | $33,979.14 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$185.00** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 / H1 / H1v2 | **all REFUTED** |
| H5 | **open** — merge DONE; chall loading → n80 |
| H1v2 HF merged | public `unconst/Affine-5czsc2fc98-h1v2-merged` @ `a314357…` (do not submit) |
| Disk | host: text only; pod merge at `/root/merges/h5-kt65/` (~67G) |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H5 resume→sim | SSH `root@69.63.236.160 -p 40301`; deadman **12:00Z** |

On pod:
- Engines: teacher:8000 + king TalentPigs:8001 **200**; chall h5-kt65:8002
  **loading** (pid **232026**, wait_ready **232028**)
- Resume pipe pid **231961** `resume_after_merge.sh`
- Done markers: `h5_merge.done` @ 06:41:14Z → next `h5_chall_serve.done`
  → `h5_sim_n80.done` → `h5_merge_sim.done`
- Identity: out 2-shard vs king 16-shard; `identical_to_king=false`
  (`results/h5_kt65_identity.json`)
- Sim out: `/root/affine_data/h5_kt65_sim_result.json`
- Log: `/root/logs/h5_merge_sim.nohup` (+ `h5_kt65_sim.nohup` after serve)
- Plan: `experiments/s4-h5-talentpigs/plan.md`

Host (no GPU):
- TTL deadman pid **1783662** @ **12:00Z**
- Harvest: killed (pass 68); re-arm after n80 if needed for SCP

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** H1/H1v2/H2. Cap remaining ~$3,815.

## Next action (single, highest value)

**Poll `/root/logs/h5_chall_serve.done` then `/root/logs/h5_sim_n80.done`.**
When sim done: SCP `h5_kt65_sim_result.json` (+ artifact/meta) → triage
(margin > 0.04 + H4 + live-king guard). If 0.02≤margin≤0.04 try α=0.50;
if margin < 0.02 refute H5 merge parents → TalentPigs-init thought distill.
Re-check snapshot before any submit path. Do not rent another pod.
