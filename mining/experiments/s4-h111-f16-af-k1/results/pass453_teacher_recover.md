# pass453 — F16 teacher recover

**Symptom:** n80 attempt1 ConnectError; `vllm_teacher.log` Triton ENOENT
`EAUHKKZ…/__triton_launcher.so` @02:50:20Z → EngineDead; :8000=000.
King :8001 + chall :8002 stayed 200 (GPUs 2–5). GPUs 0,1 free.

**Action:** `relaunch_teacher_pass332.sh` @03:04:24Z — wipe teacher* → settle20 →
unique TCACHE `teacher_p332_1786244664_26465` util=0.80. Cleared stale
`h111_sim_n80.done` / sim artifacts. Killed mid-wait retry (poll~52/120);
watcher rearmed `retry_h111_n80_d203first.sh` at poll=0/360.

**Expect:** teacher promptable ~10–15m → n80 d203. Next pass: confirm :8000=200
+ n80 progress; else re-fire on ENOENT.
