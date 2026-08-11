# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.
**2026-08-11:** replaced bricked B300 with 8×B200 @$52.25/h (B300 sold out).

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $122,007.39 | 2026-08-11T12:55Z |
| cumulative mining spend | ~$75,580 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T12:55Z |
| **available for mining** | **~$112,007** (balance − $10,000 floor) | 2026-08-11T12:55Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$52.25/h** (`mine-crown-1` 8×B200) | 2026-08-11T12:55Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T12:55Z | 122007.39 | p2027 arm now-after-h44 + watch486 (no new rent); burn$52.25/h; Δ$0 vs p2026 |
| 2026-08-11T12:53Z | 122007.39 | p2026 arm h44 prefetch + R2am Stage-5 (no new rent); burn$52.25/h; Δ−$10 vs p2025 (shared ok) |
| 2026-08-11T12:48Z | 122017.57 | p2025 R2am timeout relaunch (no new rent); burn$52.25/h; Δ−$71 vs p2023 (shared ok) |
| 2026-08-11T12:13Z | 122088.99 | p2023 R2ad REFUTE + purge pig + R2am n80 (no new rent); burn$52.25/h; Δ−$71 vs p2021 (shared ok) |
| 2026-08-11T11:37Z | 122160.43 | p2021 R2ac REFUTE + purge google (no new rent); burn$52.25/h; Δ−$41 vs p2020 (shared ok) |
| 2026-08-11T11:19Z | 122201.20 | p2020 R2ac Stage-5 waiter + HF prepurge (no new rent); burn$52.25/h; Δ−$10 vs p2019 (shared ok) |
| 2026-08-11T11:16Z | 122211.42 | p2019 armed R2an Talent×cp13 EAGER (no new rent); burn$52.25/h; Δ$0 vs p2018 |
| 2026-08-11T11:13Z | 122211.42 | p2018 armed chal-00481 cp13 prefetch (no new rent); burn$52.25/h; Δ$0 vs p2017 |
| 2026-08-11T11:05Z | 122221.67 | p2017 R2ab REFUTE + R2ac n80 + R2am EAGER (no new rent); burn$52.25/h; Δ−$20 vs p2016 (shared ok) |
| 2026-08-11T11:00Z | 122242.04 | p2016 R2am Talent×sbs-v1 EAGER armed (no new rent); burn$52.25/h; Δ−$10 vs p2015 (shared ok) |
