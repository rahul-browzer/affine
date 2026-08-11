# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.
**2026-08-11:** replaced bricked B300 with 8×B200 @$52.25/h (B300 sold out).

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $121,732.00 | 2026-08-11T15:08Z |
| cumulative mining spend | ~$75,857 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T15:08Z |
| **available for mining** | **~$111,732** (balance − $10,000 floor) | 2026-08-11T15:08Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$52.25/h** (`mine-crown-1` 8×B200) | 2026-08-11T15:08Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T15:08Z | 121732.00 | p2043 arm R2av pure-v2+prefetch (no new rent); burn$52.25/h; Δ−$10 vs p2042 (shared ok) |
| 2026-08-11T15:04Z | 121741.67 | p2042 arm R2au pure-sft4+Stage-5 (no new rent); burn$52.25/h; Δ−$11 vs p2041 (shared ok) |
| 2026-08-11T15:00Z | 121752.38 | p2041 host-hist+495 + prefetch sft4 (no new rent); burn$52.25/h; Δ$0 vs p2040 |
| 2026-08-11T14:56Z | 121752.38 | p2040 R2ap WEAK_SKIP + R2aq n80 start (no new rent); burn$52.25/h; Δ−$51 vs p2039 (shared ok) |
| 2026-08-11T14:36Z | 121803.22 | p2039 arm R2at pure-hope11+Stage-5 (no new rent); burn$52.25/h; Δ$0 vs p2038 |
| 2026-08-11T14:32Z | 121803.22 | p2038 rearm host-hist bridge 485–492 (no new rent); burn$52.25/h; Δ−$10 vs p2037 (shared ok) |
| 2026-08-11T14:29Z | 121813.60 | p2037 arm R2as pure-726 reload+Stage-5 (no new rent); burn$52.25/h; Δ$0 vs p2036 |
| 2026-08-11T14:26Z | 121813.60 | p2036 arm watch492+prefetch726 after hope11 (no new rent); burn$52.25/h; Δ−$10 vs p2035 (shared ok) |
| 2026-08-11T14:21Z | 121823.72 | p2035 R2ap n80 + arm R2ar iynocr2p lane (no new rent); burn$52.25/h; Δ−$20 vs p2034 (shared ok) |
| 2026-08-11T14:11Z | 121844.18 | p2034 R2ao REFUTE + R2ap h44 reload start (no new rent); burn$52.25/h; Δ−$61 vs p2033 (shared ok) |
