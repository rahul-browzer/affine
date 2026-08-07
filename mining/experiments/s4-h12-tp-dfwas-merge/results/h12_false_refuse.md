# H12 false-refuse (pass 137)

Merge completed 16/16 shards then `merge_linear.py` exited:
`merge looks weight-identical to A — refuse`.

## Evidence merge is NOT identical

| probe | value |
|---|---|
| shard08 `shared_expert.down_proj` max\|A−B\| | 0.855 |
| shard08 same key max\|A−O\| | 0.215 |
| shard08 merge_err vs 0.75A+0.25B | ~1e-3 (bf16) |
| shard01 first-8 keys max\|A−O\| | **0** (embeds/early norms shared) |
| first_1MiB sha A vs OUT | identical (embed-leading) |

## Root cause

`max_abs_delta_sample` only inspected the first 8 merged keys. Those are
embed/early-layer tensors identical across TalentPigs and plmk, so sample
stayed 0.0 and paired with first_1MiB match → refuse. Mid-layer weights
differ as expected for α=0.75.

## Fix

1. `merge_linear.py`: track `max_abs_delta` over **all** merged keys; refuse
   only if that max < 1e-8. first_1MiB match is a note, not a refuse.
2. `continue_after_false_refuse.sh`: mid-shard probe → rewrite meta →
   `h12_merge.done` → serve_three → `start_h12_n80.sh` (no re-merge).
