# H76 king recover re-fire — pass 302

**When:** 2026-08-08T12:30Z
**Symptom:** `king_recover_pass300` (started 12:22Z) stuck at health=000
poll≈42/180. King APIServer gone; orphan `VLLM::Worker_TP1` pid=22303
ppid=1 on GPU3 (~117 GiB), GPU2 empty. NCCL Broken pipe in vllm_king.log.
Teacher+chall still up. Retry waiting poll≈44/120.

**Action:** Killed stuck pass300 recover by PID ($0 match). Reaped orphan
22303 on GPUs 2,3. Deployed `king_recover_pass302.sh` (same recipe, new
log/done markers). Killed stale `retry_h76_n80` so watcher rearms full wait.
Left chall alone (GPUs 4,5).

**Check:** `tail -f /root/logs/h76_king_recover_pass302.nohup` → KING PROMPTABLE
→ retry n80 a203 → `decision.json`.
