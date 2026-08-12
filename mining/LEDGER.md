# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $117,436.594 | 2026-08-12T09:56Z |
| cumulative mining spend | ~$80,164 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-12T09:56Z |
| **available for mining** | **~$107,437** (balance − $10,000 floor) | 2026-08-12T09:56Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (4 pods) | **$220.25/h** (2×B300 $64 + 2×B200 $52.25+$40) · **vs floor $833/h** | 2026-08-12T09:56Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-12T09:56Z | 117436.594 | p2224 no new rent (8×=0; sbs-v2 **403** demote R10/R18; burst**3745530** next=R5b); burn **$220.25/h**; Δ−$24 vs p2223 |
| 2026-08-12T09:52Z | 117460.770 | p2223 no new rent (8×=0; R10 Hub false-OK + QUEUE promote; burst**3735496** next=R10); burn **$220.25/h**; Δ−$24 vs p2222 |
| 2026-08-12T09:47Z | 117484.964 | p2222 no new rent (8×=0; burst**3704917**→**3725622** MAX_ITERS=86400); burn **$220.25/h**; Δ−$24 vs p2221 |
| 2026-08-12T09:43Z | 117509.142 | p2221 no new rent (8×=0; n80 teacher-len gate + post relaunch); burn **$220.25/h**; Δ−$24 vs p2220 |
| 2026-08-12T09:39Z | 117533.486 | p2220 no new rent (8×=0; R24 teacher-maxlen sidecar); burn **$220.25/h**; Δ$0 vs p2219 |
| 2026-08-12T09:36Z | 117533.486 | p2219 no new rent (8×=0; burst**3682673**→**3704917** next=R27); burn **$220.25/h**; Δ−$24 vs p2218 |
| 2026-08-12T09:32Z | 117557.280 | p2218 no new rent (8×=0; R21 stale R20 adapter archived; R24 stale sim cleared); burn **$220.25/h**; Δ−$25 vs p2217 |
| 2026-08-12T09:28Z | 117581.794 | p2217 no new rent (8×=0; R24 post KING→guass; burst**3682673**); burn **$220.25/h**; Δ−$24 vs p2216 |
| 2026-08-12T09:24Z | 117605.928 | p2216 no new rent (8×=0; R25 guass DONE enforce-eager; teacher restore); burn **$220.25/h**; Δ−$24 vs p2215 |
| 2026-08-12T09:14Z | 117654.475 | p2215 no new rent (8×=0; R25 guass retarget; burst**3652502** next=R27); burn **$220.25/h**; Δ−$24 vs p2214 |
