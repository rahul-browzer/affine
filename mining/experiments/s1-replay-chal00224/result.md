# s1-replay-chal00224 — result

**UTC:** 2026-08-06T22:49:00Z  
**Verdict: Stage 1 gate MET.**

## Artifacts

| file | bytes | source |
|---|---|---|
| `chal-00224.json.gz` | 266277 | hippius evals (kevin954 sft vs genesis) |
| `chal-00203.json.gz` | 280027 | hippius evals (pandora ckpt300-m4 vs genesis) |

Recompute: `replay.py` (imports read-only `affine.affine.score`).

## Published index / stored verdict (at duel time)

Both index lines: `challenger_wins=false`, `margin=0.0`, `z=0.0`.
Stored gates show `min_margin=0.05`; challenger `valid=false` (no calib_ratio
field in summary — invalid under then-live `r_lo=1.0`).

| id | challenger | king | chall mean_mix | chall r (recomputed) | king S |
|---|---|---|---|---|---|
| chal-00224 | kevin954/…-sft @ 6a5815… | genesis | **0.03955783762471344** | 0.7158 | −0.031101 |
| chal-00203 | pandora-box/…ckpt300-m4 @ 5218b1… | genesis | 0.018731398992217284 | 0.7627 | −0.042913 |

Note: live king S on snapshot equals kevin's published mean_mix exactly.

## Recompute under old knobs (`r_lo=1.0`, `min_margin=0.05`, no band)

| id | cs.valid | margin | wins | note |
|---|---|---|---|---|
| chal-00224 | False (r=0.716 < 1.0) | 0.0 / se=inf | False | matches published |
| chal-00203 | False (r=0.763 < 1.0) | 0.0 / se=inf | False | matches published |

## Recompute under current knobs (`r_lo=0.3`, `baseline_band=1.25`, `min_margin=0.02`)

| id | cs.valid | ks.valid | margin | se | z | wins | claimed |
|---|---|---|---|---|---|---|---|
| chal-00224 | True | True | **+0.070000** | 0.011092 | **6.3107** | True | +0.070 / z≈6.3 |
| chal-00203 | True | True | **+0.060845** | 0.010774 | **5.6472** | True | +0.061 / z≈5.7 |

Baseline band: kevin 0.1219 / king 0.1147 = **1.062×** (< 1.25); pandora 0.1309 / 0.1214 = **1.079×**.

Bank fracs used = published row-mean (same as evalsrv `_mean_bank`): kevin 0.5906 / 0.3979; pandora 0.4521 / 0.3625.

Clipped rank term matches published `mean_mix` bit-exactly for both sides.

## Conclusion

Offline `score.duel` on stored logprobs reproduces the retroactive crown margins
to the claimed figures. Scoring path + current knobs are understood end-to-end.
Stage 1 gate passed → proceed to Stage 2 (hypothesis ranking from public data).
