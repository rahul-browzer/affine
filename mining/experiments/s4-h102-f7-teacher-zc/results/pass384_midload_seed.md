# H102/F7 pass384 — mid-load king TCACHE seed

## Problem
recover264 a1 logged `no king TCACHE to seed` then launched cold chall.
Live king uses isolated `TRITON_CACHE_DIR=/root/.triton/isolated/h102_king_p332_1786223780_13442`
(19 `__triton_launcher*.so`); bare `/root/.triton/cache/king` absent.
`h102_sim_n80.done` / `h102_pipeline.done` @21:30Z are false markers (retry deferred; no sim result).

## Action
- rsync king_iso → `/root/.triton/cache/king` (19 launchers) for attempt 2+
- mid-load rsync king_iso → live chall TCACHE
  `/root/.triton/isolated/h102_chall_p260_a1_1786224640_21590` (0→19)
- left recover a1 running (chall still loading weights, GPUs 4/5 ~36 GiB)
- patched local `relaunch_chall_pass264.sh` (F4/F6/F7/F8/F9) to prefer
  :8001 `TRITON_CACHE_DIR` then `isolated/*king*` then `cache/king` (F1 p382 recipe)

## Next
Await chall :8002=200 → diverse warm → freeze → n80 vs Tok.
