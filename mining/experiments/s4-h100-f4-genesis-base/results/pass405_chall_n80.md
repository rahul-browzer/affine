# F4 / H100 — pass 405 cuda404 → n80

## Done
1. Killed stale `relaunch_chall_cuda_p401` / `p403` (arg0=`bash`; match full cmdline).
2. Chall pid90746 cleared cudart barrier: weights 90s → CUDA graphs →
   **CHALL PROMPTABLE** @23:13:44Z poll=43.
3. Diverse warm d1–d4 all **200**; freeze **mode=555 n_so=22**.
4. Longwait watcher rearmed; `run_sim_duel` a203 live (pid97694, ppid1).
5. Engines 8000/8001/8002 = 200; postfreeze probe 200.

## Note
p404 log line said `mode=755` at freeze instant; done file + live `stat` = **555**.
Trust post-freeze `stat`, not the log line race.
