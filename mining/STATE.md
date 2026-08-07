# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H1v2 REFUTED; NEW KING TalentPigs; pivot next.**

Stage 0–3 complete. H2 / H1 / **H1v2 all REFUTED**. H1v2 n80 margin
**−0.00030** (king-parity, H4 r=0.904 fail). Live king flipped mid-sim:
**TalentPigs/affine-5ekxlcg3fx-abc** reign 3 @ S=0.0315 (chal-00284).
`mine-sim-1` kept alive (harvest killed to block early-teardown); host
deadman **08:00Z**. No submit.

**Pass 68:** harvested n80 + triage → revise_recipe; killed harvest;
documented refute; next = pivot engines to new king.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4` |
| king S | 0.031501971059510636 |
| reign # | **3** (kevin still earning as reign 2; pandora reign 1) |
| prev king (sim target) | kevin954/…-sft @ `6a5815…` S=0.0396 |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | 8767079 (re-check contract before any submit) |
| weight_version_key | 1 |
| min_margin | 0.02 (duel) |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $34,010.24 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$175.84** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 / H1 / H1v2 | **all REFUTED** |
| H1v2 n80 | margin **−0.00030**; r=0.904; clip-L1 +0.015; submit=false |
| H1v2 HF merged | public `unconst/Affine-5czsc2fc98-h1v2-merged` @ `a314357…` |
| Live eval | chal-00286 ensure_king (next challenger loading) |
| Disk | host: text only; pod kept for pivot |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | KEEP for new-king pivot | SSH `root@69.63.236.160 -p 40301`; deadman **08:00Z** |

On pod:
- Teacher:8000 + King:8001 (still **kevin**) + Chall:8002 (H1v2 merged) **were** 200
- H1v2 n80 **DONE** → results harvested locally
- Marker: `experiments/s4-h1v2-sft/results/KEEP_POD_FOR_PIVOT.txt`
- **Do not** early-teardown; harvest process killed on purpose

Host (no GPU):
- Artifact harvester: **killed** (pass 68) — would have `lium rm` after got_h1v2
- TTL deadman pid **1757428** @ **08:00Z** (still armed)

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** H1v2 (or H1/H2). Sim was vs deposed kevin;
even vs kevin it failed the gate. Cap remaining ~$3,824.

## Next action (single, highest value)

**Pivot `mine-sim-1` to live king TalentPigs:** download
`TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` on the pod → re-serve as
king on :8001 → draft/launch H5 plan (kevin×TalentPigs merge **or** mild
thought-only from TalentPigs init) → n80 sim vs **TalentPigs** with margin
gate > 0.04. Extend deadman if download+serve needs past 08:00Z. Re-check
snapshot first (chal-00286 may crown again).
