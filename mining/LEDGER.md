# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.
**2026-08-11:** replaced bricked B300 with 8×B200 @$52.25/h (B300 sold out).

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $121,803.22 | 2026-08-11T14:36Z |
| cumulative mining spend | ~$75,785 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T14:36Z |
| **available for mining** | **~$111,803** (balance − $10,000 floor) | 2026-08-11T14:36Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$52.25/h** (`mine-crown-1` 8×B200) | 2026-08-11T14:36Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T14:36Z | 121803.22 | p2039 arm R2at pure-hope11+Stage-5 (no new rent); burn$52.25/h; Δ$0 vs p2038 |
| 2026-08-11T14:32Z | 121803.22 | p2038 rearm host-hist bridge 485–492 (no new rent); burn$52.25/h; Δ−$10 vs p2037 (shared ok) |
| 2026-08-11T14:29Z | 121813.60 | p2037 arm R2as pure-726 reload+Stage-5 (no new rent); burn$52.25/h; Δ$0 vs p2036 |
| 2026-08-11T14:26Z | 121813.60 | p2036 arm watch492+prefetch726 after hope11 (no new rent); burn$52.25/h; Δ−$10 vs p2035 (shared ok) |
| 2026-08-11T14:21Z | 121823.72 | p2035 R2ap n80 + arm R2ar iynocr2p lane (no new rent); burn$52.25/h; Δ−$20 vs p2034 (shared ok) |
| 2026-08-11T14:11Z | 121844.18 | p2034 R2ao REFUTE + R2ap h44 reload start (no new rent); burn$52.25/h; Δ−$61 vs p2033 (shared ok) |
| 2026-08-11T13:43Z | 121905.35 | p2033 R2ao n80 continue after mid-script crash (no new rent); burn$52.25/h; Δ−$41 vs p2032 (shared ok) |
| 2026-08-11T13:23Z | 121946.14 | p2032 R2am REFUTE + TKC rescue (no new rent); burn$52.25/h; Δ−$31 vs p2031 (shared ok) |
| 2026-08-11T13:08Z | 121976.83 | p2031 arm R2aq pure-now+Stage-5 (no new rent); burn$52.25/h; Δ−$10 vs p2030 (shared ok) |
| 2026-08-11T13:05Z | 121986.56 | p2030 arm R2ap pure-h44+Stage-5 (no new rent); burn$52.25/h; Δ$0 vs p2029 |
