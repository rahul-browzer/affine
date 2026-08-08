# pass218 — dual-sim race kill

post_train (pid2302→sim16400 @00:40:36) and retry (sim16785 @00:40:52)
both wrote `h42_sim_result.json`. Progress corrupt (chall2/king4).

Killed post_train + both sims; quarantined progress →
`false_probes/h42_sim_progress_dualsim_*.json`. Retry relaunched clean
attempt 2/3 `block_hash=b203…` (single sim). Patched post_train to skip
when `watch_n80_retry` / `retry_h42_n80` armed (not only when sim alive).
