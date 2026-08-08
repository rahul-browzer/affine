# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $183,931.93 | 2026-08-08T21:52Z |
| cumulative mining spend | ~$13,385 (6 pods ~$213/h accruing) | 2026-08-08T21:52Z |
| **available for mining** | **~$173,932** (balance − $10,000 floor) | 2026-08-08T21:52Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (6 pods) | ~$213.3/h | 2026-08-08T21:52Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-08T21:52Z | 183931.93 | accrual (F4 tokwatch; no rm/rent; burn ~$213/h) |
| 2026-08-08T21:46Z | 183931.93 | accrual (F7 a203→b203 n80; no rm/rent; burn ~$213/h) |
| 2026-08-08T21:41Z | 183967.29 | accrual (F7 unfreeze salvage; no rm/rent; burn ~$213/h) |
| 2026-08-08T21:38Z | 184002.74 | accrual (F6 peer-seed; F7 n80; no rm/rent; burn ~$213/h) |
| 2026-08-08T21:33Z | 184037.42 | accrual (F7 midload seed; F1 n80; no rm/rent; burn ~$213/h) |
| 2026-08-08T21:29Z | 184073.18 | accrual (F4 Tok Range + F6 recover; no rm/rent; burn ~$213/h) |
| 2026-08-08T21:23Z | 184108.34 | accrual (F1 recover264+seed; no rm/rent; burn ~$213/h) |
| 2026-08-08T21:19Z | 184143.47 | accrual (F1 preempt rearm; no rm/rent; burn ~$213/h) |
| 2026-08-08T21:13Z | 184177.36 | rent mine-f9-1 H200@$31.92/h ttl12h (H104/F9); burn ~$213/h |
| 2026-08-08T21:05Z | 184209.87 | rent mine-f8-1 H200@$28/h ttl12h (H103/F8); burn ~$181/h |
