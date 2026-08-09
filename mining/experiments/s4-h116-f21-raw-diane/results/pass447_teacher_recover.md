# Pass 447 — F21 teacher Triton ENOENT → recover447

**Symptom:** `:8000=000`, GPUs 0,1 empty; king `:8001=200` (134 GiB); chall mid-load.
Teacher log: `ImportError: …/cache/teacher/4NLUGJ4UK…/__triton_launcher.so: No such file` → EngineDead @02:29:23Z.

**Action:** SCP + nohup `relaunch_teacher_pass447.sh` (HYPO=h116, util=0.72, unique TCACHE, leave king/chall).
Leave chall alone (GPUs 4,5). Bootstrap still waiting on engines.

**Next:** confirm `:8000=200` + completions; then wait_ready → n80.
