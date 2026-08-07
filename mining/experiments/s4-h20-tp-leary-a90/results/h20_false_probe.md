# H20 false REFUTE (pass 153) — do not treat as experiment result

n80 wrote `h20_decision.json` with null margin after
`rejection_reason=unpromptable:probe_sample_failed:ConnectError` — chall
died mid-probe with CUDA OOM on GPU1 (`log_softmax` alloc 7.22 GiB).
Teacher+king stayed up; chall port 8002 → 000.

Recovered 15:20Z: archived `h20_decision.FALSE_PROBE.json`, cleared
decision/sim/done, wiped chall Triton cache, relaunched chall via
`serve_three.sh`, then `retry_h20_n80.sh` @15:27Z — chall OOM'd again
on prompt logprobs at GPUUTIL=0.80. Second fix @15:31Z: chall alone at
**GPUUTIL=0.72** on GPUs 4,5; n80 retry @15:35Z (engines 200/200/200).

**Lesson:** null-margin REFUTE ≠ experiment result — check
`rejection_reason`. Chall needs ~7.2 GiB free for logprobs; use 0.72.

