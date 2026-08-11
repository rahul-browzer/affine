# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $121,371.45 | 2026-08-11T17:31Z |
| cumulative mining spend | ~$76,216 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T17:31Z |
| **available for mining** | **~$111,371** (balance − $10,000 floor) | 2026-08-11T17:31Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (2 pods) | **$116.25/h** (B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-11T17:31Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T17:31Z | 121371.45 | p2061 R3 w0 finish→teacher→GRPO + R2au REFUTE (no new rent; B300×8=0); burn **$116.25/h**; Δ−$78 vs p2060 |
| 2026-08-11T17:09Z | 121449.38 | p2060 R3 16-way range DL (no new rent; B300×8=0); burn **$116.25/h**; Δ$0 vs p2059 |
| 2026-08-11T17:05Z | 121449.38 | p2059 unstuck R3 HF hang + teacher stamp (no new rent; B300×8=0); burn **$116.25/h**; Δ−$31 vs p2058 |
| 2026-08-11T16:46Z | 121511.37 | p2058 killed slow crown→R3 rsync; HF parallel_dl relaunched (no new rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2057 |
| 2026-08-11T16:41Z | 121526.95 | p2057 crown→R3 parallel rsync Tok+teacher (no new rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2056 |
| 2026-08-11T16:37Z | 121542.56 | p2056 R3 parallel_dl mid-pip (no new rent; B300×8=0); burn **$116.25/h**; Δ−$15 vs p2055 |
| 2026-08-11T16:34Z | 121557.90 | p2055 R3 bootstrap launched on `mine-r3-grpo-1` (no new rent; B300×8=0); burn **$116.25/h**; Δ−$11 vs p2054 |
| 2026-08-11T16:30Z | 121568.80 | p2054 rented `mine-r3-grpo-1` 8×B300 @$64/h TTL24h (last free); burn **$116.25/h**; B300 left=0 |
| 2026-08-11T16:25Z | 121578.97 | p2052 R2at hope11 engines up + n80 ~4/80 (no new rent); burn$52.25/h; Δ−$10 vs p2051 |
| 2026-08-11T16:17Z | 121589.16 | p2051 R2as WEAK_SKIP + R2at hope11 load (no new rent); burn$52.25/h; Δ−$41 vs p2050 |
