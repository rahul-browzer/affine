# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5 pivot in flight (TalentPigs download → king:8001).**

Stage 0–3 complete. H2 / H1 / H1v2 **REFUTED**. Live king
`TalentPigs/affine-5ekxlcg3fx-abc` reign 3 @ S=0.0315. Pass 69 launched
pod pipeline **227022**: download TalentPigs → re-serve king :8001.
Host deadman **12:00Z** (pid **1783662**). No submit.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4` |
| king S | 0.031501971059510636 |
| reign # | **3** (kevin reign 2 earning; pandora reign 1) |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | 8767079 (re-check contract before any submit) |
| weight_version_key | 1 |
| min_margin | 0.02 (duel) |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $34,002.45 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$177.94** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 / H1 / H1v2 | **all REFUTED** |
| H5 | **open** — pivot pipeline running; merge next |
| H1v2 HF merged | public `unconst/Affine-5czsc2fc98-h1v2-merged` @ `a314357…` (do not submit) |
| Disk | host: text only; pod HF TalentPigs cache growing (~19G @ launch) |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H5 pivot | SSH `root@69.63.236.160 -p 40301`; deadman **12:00Z** |

On pod:
- Pipeline pid **227022** `start_pivot.sh` → download then `pivot_king.sh`
- Done markers: `/root/logs/h5_download.done` → `/root/logs/h5_king_pivot.done` → `/root/logs/h5_pivot_pipeline.done`
- Log: `/root/logs/h5_pivot_pipeline.nohup`
- Teacher:8000 + (old kevin) King:8001 + Chall H1v2:8002 were 200 at launch;
  king will restart as TalentPigs after download
- Plan: `experiments/s4-h5-talentpigs/plan.md`

Host (no GPU):
- TTL deadman pid **1783662** @ **12:00Z**
- Harvest: killed (pass 68); do not re-arm early-teardown until H5 decides

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** H1/H1v2/H2. Cap remaining ~$3,822.

## Next action (single, highest value)

**When `/root/logs/h5_king_pivot.done` exists** (king:8001 = TalentPigs 200):
launch kevin×TalentPigs linear merge α=**0.65** → `/root/merges/h5-kt65/`
(reuse `s4-h2-merge/merge_linear.py`) → re-serve chall:8002 → n80 sim vs
TalentPigs (gate margin > 0.04 + H4). Re-check snapshot first (crown may flip).
If download/pivot still running, poll only — do not rent another pod.
