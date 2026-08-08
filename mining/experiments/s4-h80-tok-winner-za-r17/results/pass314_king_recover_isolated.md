# Pass 314 — H80 king re-fire with isolated TCACHE

## Symptom
- king311 relaunch312 (pid28037 → king28144) hit load-time Triton
  `ImportError …/NODUTTS4…/__triton_launcher.so` @13:25:32Z.
- health:8001 stayed 000; GPUs 2/3 stuck ~37 GiB; recover polling ~60/180.
- Teacher+chall untouched (:8000/:8002=200). n80 had ConnectError (king down).

## Action
- Killed recover pid28037 (cmdline verified `/king_recover_pass311.sh`).
- Uploaded `king_recover_pass314.sh`: isolated
  `TRITON_CACHE_DIR=/root/.triton/isolated/h80_king_p314_*` + early abort on
  launcher.so ENOENT (exit 2) instead of burning 180×10s polls.
- Reaped hung king28144; GPUs 2,3 → 0 MiB; form/retry/mid304 left armed.
- Launched recover **pid31892** @13:32:51Z; king **pid32012** started
  @13:33:20Z on TCACHE `…/h80_king_p314_1786195975_31892`.

## Next
Await KING PROMPTABLE → `h80_king_recover_pass314.done` → retry n80 a203.
If early ABORT exit 2, re-fire again (do not wait for poll 180).
