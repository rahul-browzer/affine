# LESSONS overflow p374
- p253/p260 diverse writable warmups→freeze beats short-only post-w1 freeze.
- B300 flashinfer JIT: clear `cached_ops/sampling`, `SERVE_STAGGER_S≥45`.
- Clone hyp scripts: replace full EXP dirname **before** `h46→hN` sed.
- **Diverse-warm d4 quoting:** python3 -c \\'print(\\"x\\"... → SyntaxError; fixed to python3 -c "print('x' * 4096)" on F4–F9 (archived from LESSONS p419 for cap).
- Kill stale relaunchers by **full cmdline** (`tr '\0' ' ' </proc/$pid/cmdline`), not `head -1` (arg0 is just `bash`). Stale p401/p403 can coexist with p404 and reap a healthy chall. — p404/p405
