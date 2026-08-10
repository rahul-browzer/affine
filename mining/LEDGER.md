# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $176,226.50 | 2026-08-10T03:02Z |
| cumulative mining spend | ~$21,515 (Δ bal from p526 baseline) | 2026-08-10T03:02Z |
| **available for mining** | **~$166,227** (balance − $10,000 floor) | 2026-08-10T03:02Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | ~$28.00/h | 2026-08-10T03:02Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-10T03:02Z | 176226.50 | p1451 KING-WATCH idle; engines 200/200/200; burn~$28/h; no rent/rm |
| 2026-08-10T03:01Z | 176226.50 | p1450 KING-WATCH idle; engines 200/200/200; burn~$28/h; no rent/rm |
| 2026-08-10T03:00Z | 176235.06 | p1449 KING-WATCH idle; engines 200/200/200; burn~$28/h; no rent/rm |
| 2026-08-10T02:57Z | 176235.06 | p1447 KING-WATCH idle; engines 200/200/200; burn~$28/h; no rent/rm |
| 2026-08-10T02:56Z | 176235.06 | p1446 KING-WATCH idle; engines 200/200/200; burn~$28/h; no rent/rm |
| 2026-08-10T02:55Z | 176235.06 | p1445 KING-WATCH idle; engines 200/200/200; burn~$28/h; no rent/rm |
| 2026-08-10T02:54Z | 176243.20 | p1444 KING-WATCH idle; engines 200/200/200; burn~$28/h; no rent/rm |
| 2026-08-10T02:53Z | 176243.20 | p1443 KING-WATCH idle; engines 200/200/200; burn~$28/h; no rent/rm |
| 2026-08-10T02:52Z | 176243.20 | p1442 KING-WATCH idle; engines 200/200/200; burn~$28/h; no rent/rm |
| 2026-08-10T02:50Z | 176243.20 | p1440 TTL refresh via `lium up`; rm cosmic-matrix-e2 (~$0.12); burn~$28/h |
