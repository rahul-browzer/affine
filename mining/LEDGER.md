# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $123,221.47 | 2026-08-11T03:26Z |
| cumulative mining spend | ~$74,373 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T03:26Z |
| **available for mining** | **~$113,221** (balance − $10,000 floor) | 2026-08-11T03:26Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$64.00/h** (`mine-crown-1` 8×B300) | 2026-08-11T03:26Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T03:26Z | 123221.47 | p1951 R2v harvest + R2l/R2w deadlock fix (no new rent); burn$64/h; Δ−$45 vs p1950 (shared ok) |
| 2026-08-11T03:09Z | 123266.24 | p1950 R2w yield-to-R2l mid-merge fix (no new rent); burn$64/h; bal flat vs p1949 |
| 2026-08-11T03:05Z | 123266.24 | p1949 HF pre-purge +140 GiB + stage5-push relaunch (no new rent); burn$64/h; Δ−$22 vs p1948 (shared ok) |
| 2026-08-11T03:01Z | 123288.62 | p1948 stage5-push armed + asdf_chall pre-staged (no new rent); burn$64/h; Δ−$11 vs p1947 (shared ok) |
| 2026-08-11T02:57Z | 123299.75 | p1947 R2w pure-asdf + bridge→R2n armed (no new rent); burn$64/h; bal flat vs p1946 |
| 2026-08-11T02:53Z | 123299.75 | p1946 R2v→R2l bridge armed (no new rent); burn$64/h; Δ−$11 vs p1945 (shared ok) |
| 2026-08-11T02:49Z | 123310.93 | p1945 R2v n80 gathering 1/80 (no new rent); burn$64/h; Δ−$22 vs p1944 (shared ok) |
| 2026-08-11T02:43Z | 123333.33 | p1944 R2v pure-sft3 armed (no new rent); burn$64/h; bal flat vs p1943 |
| 2026-08-11T02:38Z | 123333.33 | p1943 R2t REFUTE harvest (no new rent); burn$64/h; Δ−$34 vs p1942 (shared ok) |
| 2026-08-11T02:20Z | 123366.81 | p1942 R2k SKIP harvest 431 (no new rent); burn$64/h; Δ−$11 vs p1941 (shared ok) |
