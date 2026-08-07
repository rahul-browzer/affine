# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5b REFUTED (n80 margin +0.00322). Pivot to H5c.**

Stage 0–3 complete. H2 / H1 / H1v2 / H5 merge / **H5b** **REFUTED**.
Live king `TalentPigs/affine-5ekxlcg3fx-abc` reign 3 @ S=0.0315 (still;
chal-00300 was loading at triage — re-check snapshot). Engines still up
on `mine-sim-1`. No submit.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4` |
| king S | 0.031501971059510636 |
| reign # | **3** |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | **8767079** |
| weight_version_key | 1 |
| min_margin | 0.02 (duel) |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $33,722.29 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **~$249** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 / H1 / H1v2 / H5 merge / H5b | **all REFUTED** |
| H5b n80 | margin **+0.00322** z=0.55; H4 r=0.670 FAIL; action `revise_recipe` |
| H1v2 HF merged | public `unconst/Affine-5czsc2fc98-h1v2-merged` @ `a314357…` (do not submit) |
| H5b HF | private `…-h5b-lora` / `…-h5b-merged` @ `e1d39a1…` (salvage only; do not submit) |
| Disk | host: text only; pod `/root` 8% used; `/root/h5b` 67G |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | idle engines after H5b; pivot platform | SSH `root@69.63.236.160 -p 40301`; deadman **12:00Z** |

On pod:
- Engines: teacher:8000 + king TalentPigs:8001 + chall H5b:8002 — **all 200**
- H5b pipe + n80 sim **exited** (PIPELINE_DONE 09:25:18Z)
- Markers: `train.done` ✓ → `h5b_merge.done` ✓ → `h5b_chall_serve.done` ✓
  → `h5b_sim_n80.done` ✓ → `h5b_pipeline.done` ✓
- Host harvest **exited** after triage (`host_harvest_h5b.done`)
- Host deadman pid **1783662** @ **12:00Z** (~2.5h left as of 09:26Z)
- Teacher refs still at `/root/h1/teacher_refs_sft.jsonl` (440)
- **LANDMINE:** never SCP/edit a live pipe script while bash sleeps in it

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** any H1/H1v2/H2/h5/h5b checkpoint.
Cap remaining ~$3,751. Do not repeat mild TalentPigs-init 440-ref LoRA
(H5b autopsy: Λ2+0.004, clip-L1 flat → margin noise).

## Next action (single, highest value)

**Open H5c under `experiments/s4-h5c-*/` with a plan that is not another
mild king-init LoRA on the same 440 refs.** Prefer in order: (1) public
TalentPigs-vs-kevin crown-duel decomposition for a new lever; (2) expand
teacher_refs from all public gz then train; (3) kevin-init thought
recipe re-measured vs live TalentPigs only if (1)/(2) point there.
Re-check `api/v1/snapshot` first (chal-00300 was loading). Keep
`mine-sim-1` only if a GPU job launches this pass — else `lium rm` **only**
`mine-sim-1` / `swift-shark-52` before deadman to stop idle burn. Do not
rent a second pod. Deadman **1783662** → 12:00Z.
