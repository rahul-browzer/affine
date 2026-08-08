# H90 pass337 — mid304 armed while merge writes

## Facts
- Merge alive pid=11062 (Writing shards 0/2); wchar ~41G growing; GPUs 6,7.
- t/k=200; chall :8002 not up yet. preempt264 waiting ~poll126/240.
- mid304 armed pid=12615 via `/root/logs/arm_mid304_h90.sh` (file launch,
  not SSH `-c`). Confirmed `/proc` argv1=`…/watch_mid_n80…sh` argv2=`h90`.
- Log: START @16:45:20Z — waits for `local-h90` sim (≤2h).

## Next
Await merge→chall serve→n80; mid304 auto-enters watch loop when sim appears.
