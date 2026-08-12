# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $116,928.362 | 2026-08-12T11:44Z |
| cumulative mining spend | ~$80,673 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-12T11:44Z |
| **available for mining** | **~$106,928** (balance − $10,000 floor) | 2026-08-12T11:44Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (4 pods) | **$220.25/h** (2×B300 $64 + 2×B200 $52.25+$40) · **vs floor $833/h** | 2026-08-12T11:44Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-12T11:44Z | 116928.362 | p2243 no rent (8×=0); HF purge ~484 GB REFUTE merges; burn **$220.25/h**; Δ$0 vs p2242 |
| 2026-08-12T11:40Z | 116928.362 | p2242 no new rent (8×=0; Soft/Dead fix R22/R23/R27–R32); burn **$220.25/h**; Δ−$24 vs p2241 |
| 2026-08-12T11:36Z | 116952.590 | p2241 no new rent (8×=0; R5b→R19 warm on r4); burn **$220.25/h**; Δ−$24 vs p2240 |
| 2026-08-12T11:32Z | 116976.217 | p2240 no new rent (8×=0; R5b CHALL_REPO fix → n80 gather); burn **$220.25/h**; Δ−$25 vs p2239 |
| 2026-08-12T11:28Z | 117000.788 | p2239 no new rent (8×=0; R5b n80 watchers armed); burn **$220.25/h**; Δ−$24 vs p2238 |
| 2026-08-12T11:25Z | 117025.100 | p2238 no new rent (8×=0; R5b train→finalize→serve); burn **$220.25/h**; Δ−$48 vs p2237 |
| 2026-08-12T11:10Z | 117073.416 | p2237 no new rent (8×=0; R5b Soft/Dead fix + post_train relaunch); burn **$220.25/h**; Δ−$24 vs p2236 |
| 2026-08-12T11:06Z | 117097.803 | p2236 no new rent (8×=0; R5b ENOSPC reclaim+Talent DL relaunch); burn **$220.25/h**; Δ−$23 vs p2235 |
| 2026-08-12T11:03Z | 117120.544 | p2235 no new rent (8×=0; R21/R26 n80 done → warm R33+R5b); burn **$220.25/h**; Δ−$74 vs p2234 |
| 2026-08-12T10:48Z | 117194.509 | p2234 no new rent (8×=0; R21/R26 merge relaunch after pipe abort); burn **$220.25/h**; Δ−$24 vs p2233 |
