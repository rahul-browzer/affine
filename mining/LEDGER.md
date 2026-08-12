# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $117,000.788 | 2026-08-12T11:28Z |
| cumulative mining spend | ~$80,600 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-12T11:28Z |
| **available for mining** | **~$107,001** (balance − $10,000 floor) | 2026-08-12T11:28Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (4 pods) | **$220.25/h** (2×B300 $64 + 2×B200 $52.25+$40) · **vs floor $833/h** | 2026-08-12T11:28Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-12T11:28Z | 117000.788 | p2239 no new rent (8×=0; R5b n80 watchers armed); burn **$220.25/h**; Δ−$24 vs p2238 |
| 2026-08-12T11:25Z | 117025.100 | p2238 no new rent (8×=0; R5b train→finalize→serve); burn **$220.25/h**; Δ−$48 vs p2237 |
| 2026-08-12T11:10Z | 117073.416 | p2237 no new rent (8×=0; R5b Soft/Dead fix + post_train relaunch); burn **$220.25/h**; Δ−$24 vs p2236 |
| 2026-08-12T11:06Z | 117097.803 | p2236 no new rent (8×=0; R5b ENOSPC reclaim+Talent DL relaunch); burn **$220.25/h**; Δ−$23 vs p2235 |
| 2026-08-12T11:03Z | 117120.544 | p2235 no new rent (8×=0; R21/R26 n80 done → warm R33+R5b); burn **$220.25/h**; Δ−$74 vs p2234 |
| 2026-08-12T10:48Z | 117194.509 | p2234 no new rent (8×=0; R21/R26 merge relaunch after pipe abort); burn **$220.25/h**; Δ−$24 vs p2233 |
| 2026-08-12T10:43Z | 117218.482 | p2233 no new rent (8×=0; R33 guass-init armed+QUEUE); burn **$220.25/h**; Δ−$24 vs p2232 |
| 2026-08-12T10:38Z | 117242.945 | p2232 no new rent (8×=0; R31+R32→guass+writer); burn **$220.25/h**; Δ−$24 vs p2231 |
| 2026-08-12T10:34Z | 117266.784 | p2231 no new rent (8×=0; R29+R30→guass+writer); burn **$220.25/h**; Δ−$0 vs p2230 |
| 2026-08-12T10:31Z | 117266.784 | p2230 no new rent (8×=0; R27+R28→guass+writer); burn **$220.25/h**; Δ−$25 vs p2229 |
