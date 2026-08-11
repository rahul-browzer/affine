# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.
**2026-08-11:** replaced bricked B300 with 8×B200 @$52.25/h (B300 sold out).

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $121,905.35 | 2026-08-11T13:43Z |
| cumulative mining spend | ~$75,683 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T13:43Z |
| **available for mining** | **~$111,905** (balance − $10,000 floor) | 2026-08-11T13:43Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$52.25/h** (`mine-crown-1` 8×B200) | 2026-08-11T13:43Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T13:43Z | 121905.35 | p2033 R2ao n80 continue after mid-script crash (no new rent); burn$52.25/h; Δ−$41 vs p2032 (shared ok) |
| 2026-08-11T13:23Z | 121946.14 | p2032 R2am REFUTE + TKC rescue (no new rent); burn$52.25/h; Δ−$31 vs p2031 (shared ok) |
| 2026-08-11T13:08Z | 121976.83 | p2031 arm R2aq pure-now+Stage-5 (no new rent); burn$52.25/h; Δ−$10 vs p2030 (shared ok) |
| 2026-08-11T13:05Z | 121986.56 | p2030 arm R2ap pure-h44+Stage-5 (no new rent); burn$52.25/h; Δ$0 vs p2029 |
| 2026-08-11T13:02Z | 121986.56 | p2029 SKIP_BOARD R2an + arm R2ao (no new rent); burn$52.25/h; Δ−$11 vs p2028 (shared ok) |
| 2026-08-11T12:58Z | 121997.20 | p2028 arm af17 prefetch+watch489 (no new rent); burn$52.25/h; Δ−$10 vs p2027 (shared ok) |
| 2026-08-11T12:55Z | 122007.39 | p2027 arm now-after-h44 + watch486 (no new rent); burn$52.25/h; Δ$0 vs p2026 |
| 2026-08-11T12:53Z | 122007.39 | p2026 arm h44 prefetch + R2am Stage-5 (no new rent); burn$52.25/h; Δ−$10 vs p2025 (shared ok) |
| 2026-08-11T12:48Z | 122017.57 | p2025 R2am timeout relaunch (no new rent); burn$52.25/h; Δ−$71 vs p2023 (shared ok) |
| 2026-08-11T12:13Z | 122088.99 | p2023 R2ad REFUTE + purge pig + R2am n80 (no new rent); burn$52.25/h; Δ−$71 vs p2021 (shared ok) |
