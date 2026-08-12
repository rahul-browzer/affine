# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $117,218.482 | 2026-08-12T10:43Z |
| cumulative mining spend | ~$80,383 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-12T10:43Z |
| **available for mining** | **~$107,218** (balance − $10,000 floor) | 2026-08-12T10:43Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (4 pods) | **$220.25/h** (2×B300 $64 + 2×B200 $52.25+$40) · **vs floor $833/h** | 2026-08-12T10:43Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-12T10:43Z | 117218.482 | p2233 no new rent (8×=0; R33 guass-init armed+QUEUE); burn **$220.25/h**; Δ−$24 vs p2232 |
| 2026-08-12T10:38Z | 117242.945 | p2232 no new rent (8×=0; R31+R32→guass+writer); burn **$220.25/h**; Δ−$24 vs p2231 |
| 2026-08-12T10:34Z | 117266.784 | p2231 no new rent (8×=0; R29+R30→guass+writer); burn **$220.25/h**; Δ−$0 vs p2230 |
| 2026-08-12T10:31Z | 117266.784 | p2230 no new rent (8×=0; R27+R28→guass+writer); burn **$220.25/h**; Δ−$25 vs p2229 |
| 2026-08-12T10:27Z | 117291.351 | p2229 no new rent (8×=0; R22+R23→guass+writer); burn **$220.25/h**; Δ−$24 vs p2228 |
| 2026-08-12T10:24Z | 117315.089 | p2228 no new rent (8×=0; R5b writer prestage + R19→guass); burn **$220.25/h**; Δ−$25 vs p2227 |
| 2026-08-12T10:19Z | 117339.674 | p2227 no new rent (8×=0; form-dec→Reason crown on 4 pods); burn **$220.25/h**; Δ−$24 vs p2226 |
| 2026-08-12T10:09Z | 117388.251 | p2226 no new rent (8×=0; merge visual `/root` cipher on 4 pods + free R24 bak); burn **$220.25/h**; Δ−$22 vs p2225 |
| 2026-08-12T10:04Z | 117410.593 | p2225 no new rent (8×=0; R5b guass-arm + prestage); burn **$220.25/h**; Δ−$26 vs p2224 |
| 2026-08-12T09:56Z | 117436.594 | p2224 no new rent (8×=0; sbs-v2 **403** demote R10/R18; burst**3745530** next=R5b); burn **$220.25/h**; Δ−$24 vs p2223 |
