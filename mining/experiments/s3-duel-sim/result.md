# s3-duel-sim — Stage 3 gate result

**UTC:** 2026-08-06T23:36:30Z (approx; `elapsed_s`≈426 from gate start)
**Pod:** `mine-sim-1` / `swift-shark-52`
**Raw:** `s3_gate_result.json` (also `/root/affine_data/s3_gate_result.json`)

## Setup

- Force-echo rescoring of published chal-00224 `(z,y)` texts through live vLLM
  (no fresh sampling). Slice digest `4d7254ac…`, n=80, corpus manifest
  `515df523…`.
- Roles: teacher `GLM-4.5-Air-FP8`:8000; king=genesis:8001; chall=kevin:8002.
- Serve knobs: TP=2, max-model-len 32768, util 0.80, FLASH_ATTN, moe triton,
  `VLLM_USE_DEEP_GEMM=0`, `CUDA_HOME=…/nvidia/cu13`,
  `gdn_prefill_backend=triton`.
- Score knobs: `r_lo=0.3`, `baseline_band=1.25`, `min_margin=0.02` (current).

## Numbers

| side | valid | S | r | gate_pass | baseline_abs |
|---|---|---|---|---|---|
| kevin (chall) | **True** | **0.03843** | 0.724 | 0.884 | 0.1207 |
| genesis (king) | **True** | −0.03108 | 1.142 | 0.581 | 0.1154 |

| duel | value |
|---|---|
| challenger_wins | **True** |
| margin | **+0.06890** |
| se | 0.01093 |
| z | 6.302 |
| n_paired | 80 |

Artifact top-level `verdict` (old knobs at duel time): `challenger_wins=False`,
`margin=0.0`, challenger `valid=False` (r_lo was 1.0 / min_margin 0.05) while
`mean_mix` already = 0.03956. Offline Stage-1 replay under current knobs had
margin **+0.070000** / z=6.311. Live Δ vs that target: **−0.0011**.

## Decision

**STAGE3_GATE = MET**

Pre-registered rule: kevin wins with margin ≥ 0.04 (and/or |Δ|≤0.02 vs
+0.070). Live margin +0.0689, both sides valid, |Δ| vs Stage-1 +0.070 ≈ 0.001.

Simulator path is trustworthy for Stage 4 candidate scoring. Reuse this pod
(engines still up; TTL → 2026-08-07T04:53:17Z) — swap roles so kevin is king
and candidate is challenger for H1/H2.

## Not done here

No SFT, no merge, no submission.
