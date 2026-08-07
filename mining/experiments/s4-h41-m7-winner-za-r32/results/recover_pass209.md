# H41 king recover — pass 209

## Symptom
Prewarm stuck `t=1 k=0` ~14m. `vllm_king.log` EngineCore init failed:
`__triton_launcher.so: cannot open shared object file` (Triton race).
GPUs 2,3 empty; teacher :8000 OK; merge writing on 6,7.

## Action
`relaunch_king_pass209.sh`: reap :8001 → wipe `king`/`king_*` Triton +
flashinfer sampling → settle **20s** → unique `king_p209_*` TCACHE →
`vllm serve` TalentPigs@dbfbb on 2,3 util=0.80.

## Result
- Launch 23:36:14Z pid=12748
- PREWARM_READY 23:40:06Z (elapsed 1145s)
- Completions probe 200×2 @ 23:41Z
- Merge still writing `.tmpFLIOH1` (~49GB); post_train will chall-serve after
