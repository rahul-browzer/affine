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

## Pod launch (pass 102)

Rented `mine-h5c-1` / `golden-hawk-dc` 8×H200 @$28/h `--ttl 10h`
(remove 2026-08-07T19:37:46Z). Bootstrap pid 902 installing stack then
kevin→train. See `results/h5c_pod_launched.json`.

## Mid50 early n40 (pass 112)

| metric | value |
|---|---|
| ckpt | checkpoint-50 (best train loss 0.4186) |
| margin / z | **−0.01924** / −1.48 |
| S_c / S_k | 0.00420 / 0.02319 |
| r_c / base× | **0.897** (H4 fail) / 1.065 OK |
| mean clip-L1 c/k | 0.015 / 0.028 (target ≥0.042) |
| weight-identical | false (shard tails differ) |

**FAIL — do not submit.** Same distill-envelope miss as H1v2. Final ckpt-99
n80 still running for formal H5c close. Artifacts:
`results/h5c_mid50_n40_result.json`, `h5c_mid50_sim_n40.json`.
Merged HF push to private `…-h5c-merged` failed (storage limit).

## Final merge (pass 113)

| item | value |
|---|---|
| finished | 2026-08-07T11:12:49Z · elapsed 431s |
| weight_identical | **false** (shard tails differ vs kevin + TalentPigs) |
| out | `/root/h5c/merged` 68G · visual sidecars restored |
| HF push | private attempt FAILED (storage limit) |

Artifacts: `results/h5c_merge_meta.json`, `h5c_identity.json`,
`h5c_final_merge_status.json`.

## Final n80 launch (pass 114)

| item | value |
|---|---|
| chall READY | 2026-08-07T11:19:28Z · `/root/h5c/merged` :8002 |
| n80 | **RUNNING** pid 43690 → `/root/affine_data/h5c_sim_result.json` |
| HF merged | repo flipped **public**; push `--public` pid 43981 (67 GiB) |
| gate | margin > 0.04 else refute + teardown |

Artifact: `results/h5c_n80_launched.json`. Next: poll decision.
