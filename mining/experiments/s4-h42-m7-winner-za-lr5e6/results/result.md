# H42 result — REFUTED (best H28-family so far)

n80 b203 vs TalentPigs@dbfbb3e2 (decision 2026-08-08T01:26:07Z).

| metric | value |
|---|---|
| margin | **+0.01613** |
| z | 1.779 |
| se | 0.00907 |
| S_c / S_k | 0.03204 / 0.01575 |
| r_c | 0.614 |
| base× | 1.216 |
| gates | both valid |

Above H28 (+0.01095) and all intensity-up cells (H37/H39/H41), still far
below 0.04 bar. **Half LR helps; keep going gentler (H46 @ 2.5e-6).**

Decision: `REFUTE_H42`. Tear `mine-h42-1`. Do not requeue lr=5e-6; prefer lr↓.
