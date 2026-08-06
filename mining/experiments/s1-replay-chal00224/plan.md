# s1-replay-chal00224 — Stage 1 offline duel replay

## Hypothesis

Recomputing a published duel from stored pair logprobs with current
`affine.score.duel` knobs reproduces the AGENTS.md retroactive crown margins
for reigns 1–2 (those duels were published as losses under `r_lo=1.0`).

## Method

1. Download public artifacts:
   - `https://s3.hippius.com/affine-sn120/evals/chal-00224.json.gz`
     (kevin954/Affine-5dfqbbh8ev-sft vs genesis)
   - `https://s3.hippius.com/affine-sn120/evals/chal-00203.json.gz`
     (pandora-box/…ckpt300-m4 vs genesis)
2. Extract `challenger_rows` / `king_rows` and published `bank_frac`.
3. Call `affine.affine.score.duel` under:
   - **old knobs** (as at duel time): `r_lo=1.0`, `min_margin=0.05`, no baseline band
   - **current knobs**: `r_lo=0.3`, `baseline_band=1.25`, `min_margin=0.02`
4. No GPU. Read-only import of scoring code.

## Pre-registered decision rule (Stage 1 gate)

**PASS** if under current knobs, recomputed margin/z match AGENTS.md claims
within rounding:

| duel | claimed margin | claimed z |
|---|---|---|
| chal-00224 (kevin) | ~+0.070 | ~6.3 |
| chal-00203 (pandora) | ~+0.061 | ~5.7 |

Secondary check: under old `r_lo=1.0`, challenger INVALID → published
`margin=0`, `wins=false`.

## Prediction (before run)

kevin margin ≈ +0.070, z ≈ 6.3; pandora margin ≈ +0.061, z ≈ 5.7; both win
under current knobs; both invalid under `r_lo=1.0` (r ≈ 0.72–0.76).
