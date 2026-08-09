# pass529 — F46 FALSE_PROBE quarantine + d203 rearm

## Incident
While chall was mid-recover264 (c:000), a203 n80 wrote:
- `rejection_reason=unpromptable:…ConnectError`
- `decision=FALSE_PROBE_H141` + `h141_n80.done`
recover264 then salvaged TCACHE (n_so 16→22) and relaunched chall.

## Actions
1. Quarantined decision/sim → `false_probes/*_p529fp_*`.
2. Cleared `h141_n80.done`.
3. Deployed `retry_h141_n80_d203first_p529.sh`; watcher+retry armed.
4. recover264 chall load continuing (GPUs 4,5 climbing).

## Gate
FALSE_PROBE ≠ REFUTE. Next pass: chall :8002=200 → d203 n80 → decision.
