# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $183,047.02 | 2026-08-09T00:08Z |
| cumulative mining spend | ~$14,310 (5 pods ~$179.5/h accruing) | 2026-08-09T00:08Z |
| **available for mining** | **~$173,047** (balance − $10,000 floor) | 2026-08-09T00:08Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (5 pods) | ~$179.5/h | 2026-08-09T00:08Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T00:08Z | 183047.02 | accrual (F11 af10 fix; no rm/rent; burn ~$179.5/h) |
| 2026-08-09T00:03Z | 183076.48 | rent mine-f11-1 @$28/h (H106/F11); burn ~$179.5/h |
| 2026-08-08T23:55Z | 183108.19 | rent mine-f10-1 @$28/h (H105/F10); burn ~$151.5/h |
| 2026-08-08T23:52Z | 183136.31 | accrual (F4 d203first arm; no rm/rent; burn ~$123.5/h) |
| 2026-08-08T23:49Z | 183163.93 | rm mine-f8-1 (H103 REFUTE ~$77); burn ~$123.5/h |
| 2026-08-08T23:29Z | 183286.61 | accrual (F7 d203first; no rm/rent; burn ~$151.5/h) |
| 2026-08-08T23:24Z | 183316.64 | accrual (F4 teacher OK+n80; no rm/rent; burn ~$151.5/h) |
| 2026-08-08T23:17Z | 183346.74 | accrual (F4 teacher recover332; no rm/rent; burn ~$151.5/h) |
| 2026-08-08T23:14Z | 183376.85 | accrual (F4 n80 armed; no rm/rent; burn ~$151.5/h) |
| 2026-08-08T23:07Z | 183406.94 | accrual (F4 cuda404 cudart relaunch; no rm/rent; burn ~$151.5/h) |
