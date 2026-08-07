# H20 false REFUTE (pass 153) — do not treat as experiment result

n80 wrote `h20_decision.json` with null margin after
`rejection_reason=unpromptable:probe_sample_failed:ConnectError` — chall
died mid-probe with CUDA OOM on GPU1 (`log_softmax` alloc 7.22 GiB).
Teacher+king stayed up; chall port 8002 → 000.

Recovered 15:20Z: archived `h20_decision.FALSE_PROBE.json`, cleared
decision/sim/done, wiped chall Triton cache, relaunched chall via
`serve_three.sh`, then `retry_h20_n80.sh` attempt 1 @15:27Z.

**Lesson:** `write_merge_decision.py` treats null margin as REFUTE — never
tear down on null/probe failures; check `rejection_reason` first.
