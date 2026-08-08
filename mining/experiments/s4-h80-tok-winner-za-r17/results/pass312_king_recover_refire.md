# Pass 312 — H80 king311 re-fire after load-time Triton ENOENT

- king311 (pid24653→king24852) hit ImportError ENOENT
  `…/4WD73Z7…/__triton_launcher.so` @13:20:11Z during EngineCore load;
  health:8001 stayed 000; recover kept polling.
- Reaped recover+king tree; GPUs 2,3 → 0 MiB; teacher+chall untouched (:8000/:8002=200).
- Re-fired `king_recover_pass311.sh` pid**28037** @13:21:11Z
  (`h80_king_recover_pass311.relaunch312.nohup`). form/retry/mid304 still armed.
