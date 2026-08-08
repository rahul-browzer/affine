# pass395 — F4 mid-load king→chall TCACHE peer-seed

## Symptom
`relaunch_chall_pass264` @22:18:39Z logged `no king TCACHE to seed` then launched
chall into empty isolated TCACHE, despite:
- live king :8001 `TRITON_CACHE_DIR=/root/.triton/isolated/h100_king_p332_1786226823_56841`
- pathfile `/root/logs/h100_king_tcache_pass332.path` present
- 19 `__triton_launcher*.so` in that dir

## Action
2026-08-08T22:19:12Z mid-load `rsync -a` king TCACHE →
`/root/.triton/isolated/h100_chall_p260_a1_1786227519_63229` (0→19 .so).
Chall pid=63624 still loading (`Resolved architecture: Qwen3_5Moe…`).

## Fix shipped
`relaunch_chall_pass264.sh` (F4+F9): prefer `*_king_tcache_pass332.path`,
then `ps -eo pid,args` split match, then `isolated/*king*`, then bare.
SCP'd to both pods for attempt 2/3.

## Next
Await chall :8002=200 → diverse warm → freeze → longwait n80 sampling.
