# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $120,983.36 | 2026-08-11T19:38Z |
| cumulative mining spend | ~$76,604 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T19:38Z |
| **available for mining** | **~$110,983** (balance − $10,000 floor) | 2026-08-11T19:38Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (2 pods) | **$116.25/h** (B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-11T19:38Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T19:38Z | 120983.36 | p2085 R12 BoN-CE uploader + fleet-boot (no rent; B300×8=0); burn **$116.25/h**; Δ−$15 vs p2084 |
| 2026-08-11T19:34Z | 120998.61 | p2084 R11 online-DPO uploader + rent TARGET→25 (no rent; B300×8=0); burn **$116.25/h**; Δ$0 vs p2083 |
| 2026-08-11T19:30Z | 120998.61 | p2083 R6b long-z uploader armed (no rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2082 |
| 2026-08-11T19:28Z | 121014.23 | p2082 R10 merge+RL uploader armed (no rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2081 |
| 2026-08-11T19:24Z | 121029.81 | p2081 R5b Talent uploader armed (no rent; B300×8=0); burn **$116.25/h**; Δ$0 vs p2080 |
| 2026-08-11T19:21Z | 121029.81 | p2080 R4b uploader armed (no rent; B300×8=0); burn **$116.25/h**; Δ−$15 vs p2079 |
| 2026-08-11T19:18Z | 121045.24 | p2079 R9 uploader armed (no rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2078 |
| 2026-08-11T19:14Z | 121060.74 | p2078 R3b uploader armed (no rent; B300×8=0); burn **$116.25/h**; Δ$0 vs p2077 |
| 2026-08-11T19:12Z | 121060.74 | p2077 R8 uploader armed (no rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2076 |
| 2026-08-11T19:09Z | 121076.52 | p2076 R7 uploader armed (no rent; B300×8=0); burn **$116.25/h**; Δ$0 vs p2075 |
