# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $121,247.33 | 2026-08-11T18:14Z |
| cumulative mining spend | ~$76,340 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T18:14Z |
| **available for mining** | **~$111,247** (balance − $10,000 floor) | 2026-08-11T18:14Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (2 pods) | **$116.25/h** (B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-11T18:14Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T18:14Z | 121247.33 | p2066 R2az vvv arm + HF purge (no new rent; B300×8=0); burn **$116.25/h**; Δ−$15 vs p2065 |
| 2026-08-11T18:08Z | 121262.81 | p2065 R2ay sbs-v2 arm (no new rent; B300×8=0); burn **$116.25/h**; Δ−$15 vs p2064 |
| 2026-08-11T18:04Z | 121277.80 | p2064 R2av REFUTE + R2ax auto-continue (no new rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2063 |
| 2026-08-11T18:00Z | 121293.97 | p2063 R3 GRPO relaunch after wedge (no new rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2062 |
| 2026-08-11T17:54Z | 121309.53 | p2062 R3 king@65536 + teacher recover (no new rent; B300×8=0); burn **$116.25/h**; Δ−$62 vs p2061 |
| 2026-08-11T17:31Z | 121371.45 | p2061 R3 w0 finish→teacher→GRPO + R2au REFUTE (no new rent; B300×8=0); burn **$116.25/h**; Δ−$78 vs p2060 |
| 2026-08-11T17:09Z | 121449.38 | p2060 R3 16-way range DL (no new rent; B300×8=0); burn **$116.25/h**; Δ$0 vs p2059 |
| 2026-08-11T17:05Z | 121449.38 | p2059 unstuck R3 HF hang + teacher stamp (no new rent; B300×8=0); burn **$116.25/h**; Δ−$31 vs p2058 |
| 2026-08-11T16:46Z | 121511.37 | p2058 killed slow crown→R3 rsync; HF parallel_dl relaunched (no new rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2057 |
| 2026-08-11T16:41Z | 121526.95 | p2057 crown→R3 parallel rsync Tok+teacher (no new rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2056 |
