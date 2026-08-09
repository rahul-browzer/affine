# pass 512 — F40 king recover

- King APIServer pid alive on :8001 but health=000; EngineCore stuck
  `shm_broadcast` "No available shared memory broadcast block" since ~08:54Z.
- Prior `king_recover_pass332` ABORT @09:14:31Z (poll=180/180 health=000)
  left hung Workers on GPUs 2,3 (~36 GiB each).
- RL train healthy on GPUs 6,7: step~110/200, mean_r recent
  0.044/0.027/−0.112/0.058 @steps95–110; teacher:200 untouched.
- Action: re-fired `king_recover_pass332.sh` as
  `/root/logs/h135_king_recover_p512.nohup` (pid 29082).
  Reaped GPUs 2,3 pids 18676/18677 + APIServer 17501; new isolated
  TCACHE `…/h135_king_p332_1786267428_29082`; king relaunch pid=29199
  util=0.72 @09:24:13Z. Await promptable next pass.
