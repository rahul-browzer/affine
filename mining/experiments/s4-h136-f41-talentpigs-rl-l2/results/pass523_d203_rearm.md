# pass523 — H136/F41 FALSE_PROBE a203 loop → d203 rearm

## Symptom
- Engines :8000/:8001/:8002 = 200; chall completions with mid=`/root/h136/merged` = 200.
- n80 a203 wrote artifact with nested `rejection_reason=unpromptable:…400` on :8002.
- `write_merge_decision` → `FALSE_PROBE_H136`; stale `retry_h136_n80_d203first.sh` still listed BLOCK_HASHES a203/b203/c203 and treated SIM present as N80_DONE (exit 0).
- `watch_n80_retry` relaunched → attempt 1/3 a203 again. form watcher: `ERROR sim result missing after sim exit`.

## Action
- SCP `retry_h136_n80_d203first_p523.sh` (d203→e→f→g→b; `_is_false_probe_sim` continues next hash; MAX=5).
- Kill live retry $0 + run_sim local-h136; quarantine stale sim/decision; rearm form + watch_n80 → p523; launch p523.
- Confirmed: `run_sim_duel … --block-hash d203…0004` pid live; engines 200.

## Next
Await n80 margin on d203; m>+0.015 → CONFIRM k=4; else REFUTE/tear (no replace per operator).
