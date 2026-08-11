# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $121,029.81 | 2026-08-11T19:21Z |
| cumulative mining spend | ~$76,557 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T19:21Z |
| **available for mining** | **~$111,030** (balance − $10,000 floor) | 2026-08-11T19:21Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (2 pods) | **$116.25/h** (B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-11T19:21Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T19:21Z | 121029.81 | p2080 R4b uploader armed (no rent; B300×8=0); burn **$116.25/h**; Δ−$15 vs p2079 |
| 2026-08-11T19:18Z | 121045.24 | p2079 R9 uploader armed (no rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2078 |
| 2026-08-11T19:14Z | 121060.74 | p2078 R3b uploader armed (no rent; B300×8=0); burn **$116.25/h**; Δ$0 vs p2077 |
| 2026-08-11T19:12Z | 121060.74 | p2077 R8 uploader armed (no rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2076 |
| 2026-08-11T19:09Z | 121076.52 | p2076 R7 uploader armed (no rent; B300×8=0); burn **$116.25/h**; Δ$0 vs p2075 |
| 2026-08-11T19:07Z | 121076.52 | p2075 R6 uploader armed (no rent; B300×8=0); burn **$116.25/h**; Δ−$15 vs p2074 |
| 2026-08-11T19:04Z | 121091.26 | p2074 R5 uploader armed (no rent; B300×8=0); burn **$116.25/h**; Δ$0 vs p2073 |
| 2026-08-11T19:01Z | 121091.26 | p2073 R3 step1–2 confirmed (no rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2072 |
| 2026-08-11T18:58Z | 121107.57 | p2072 R3 force-relaunch (no rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2071 |
| 2026-08-11T18:51Z | 121123.08 | p2071 R3 wedge-watch armed (no rent; B300×8=0); burn **$116.25/h**; Δ−$15 vs p2070 |
