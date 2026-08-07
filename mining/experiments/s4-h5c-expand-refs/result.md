# s4-h5c-expand-refs — harvest result

**UTC:** 2026-08-07T09:35Z (pass 101)
**Verdict: harvest DONE. Primary train set = `teacher_refs_shortz.jsonl` (791).**

## Counts (60 public duels, read-only `affine/state/evals/`)

| set | examples | vs H1 440 | z p50 | listy frac | bytes |
|---|---|---|---|---|---|
| **expanded** (all best-lp) | **1329** | **3.02×** | 216 | 0.1415 | 42.4 MB |
| **shortz** (z≤250) | **791** | **1.80×** | 127 | **0.0013** | 26.0 MB |
| shortz + drop-listy | 790 | 1.80× | 126 | 0.0 | 26.0 MB |

Raw teacher samples across duels: **18860**. Unique turn_ids with bash-ok
refs: **1329**. Missing from corpus: **0** (9000-turn index).

## Key observation

`max-z-chars=250` alone collapses listy thoughts (14.15% → 0.13%). The
TalentPigs crown style (short z, μ≈232, near-zero list markers) is mostly a
**length filter**, not a separate list scrub. Prefer **shortz** as H5c DATA;
nolist variant is redundant (+1 row).

## Artifacts

| path | tracked? |
|---|---|
| `harvest_refs.py` | yes |
| `plan.md` / `result.md` | yes |
| `results/*_stats.json` / `*.meta.json` | yes |
| `results/*.sample.jsonl` | yes (20/20/10 rows) |
| `results/teacher_refs_{expanded,shortz,shortz_nolist}.jsonl` | **no** (gitignored; regenerable) |

Regenerate on host or pod:
```bash
python3 harvest_refs.py \
  --duels-dir /path/to/evals --turns /path/to/turns_minicoder.jsonl \
  --out results/teacher_refs_shortz.jsonl --max-z-chars 250
```

## Train path (locked for next GPU pass)

| knob | value |
|---|---|
| DATA | `teacher_refs_shortz.jsonl` (791 rows; SCP ~26 MB or re-harvest on pod) |
| INIT | `kevin954/Affine-5dfqbbh8ev-sft` @ `6a5815fad8f4e34c983b1933c1fae5762fe25220` |
| LOSS | thought-only (`s4-h1v2-sft/train_lora.py --loss-on thought`) |
| LR / epochs | 2e-5 / 1 (H1v2 recipe; lever is DATA) |
| SIM king | live TalentPigs `…-abc` @ `dbfbb3e2…` (re-check snapshot) |
| GATE | n80 margin **> 0.04**; r∈[0.70,0.85]; base×≤1.15; clip-L1≥0.042 |

**Do not submit** until gate clears. Do not re-use H5b TalentPigs-init 440-ref.

## Next action

Rent one `mine-h5c-1` H200 (floor/cap check), upload shortz JSONL + H1v2
train/merge scripts, train → merge → n80 vs TalentPigs.
