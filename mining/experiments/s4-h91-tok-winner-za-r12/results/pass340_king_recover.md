# H91 pass340 — re-fire king after p339 Triton ENOENT

**Trigger:** p339 ABORT early poll=12 — ImportError
`NODUTTS4…/__triton_launcher.so` ENOENT; zombie :8001 left on GPUs 2,3
(~37 GiB each); merge still saving shards on 6,7; teacher 200; chall not up.

**Action:** `king_recover_pass340.sh` — kill leftover :8001 + GPU 2,3 reap,
wipe bare `cache/king` + failed `isolated/h91_king_p339_*`, fresh isolated
TCACHE util=0.72, settle 30s, no completions probe. Leave merge/post_train.

**Check:** `cat /root/logs/h91_king_recover_pass340.done` before trusting :8001;
then await merge→chall→preempt; arm mid304 when n80 starts.
