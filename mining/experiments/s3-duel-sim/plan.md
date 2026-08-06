# s3-duel-sim — Stage 3 local duel simulator

## Hypothesis / gate

**Claim:** A rented pod serving teacher + king + known challenger under the
eval vLLM stack can reproduce a published duel verdict within noise on
public D (Stage 3 gate).

**Target:** recompute / re-run the shape of `chal-00224`
(`kevin954/Affine-5dfqbbh8ev-sft` vs genesis). Offline logprob replay already
matched margin **+0.070000** (pass 2). Live sim gate: paired margin within
noise of that shape (same winner, same order of magnitude; ideally |Δmargin|
≲ 0.02 on an 80-turn slice), all gates passing.

## Method

1. Rent `mine-sim-1` (8×H200, `--ttl 6h`) — done pass 5.
2. Install eval stack pins: vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0.
3. Download (pod HF cache only — never through validator host):
   - teacher `zai-org/GLM-4.5-Air-FP8`
   - king `kevin954/Affine-5dfqbbh8ev-sft` @ `6a5815fad8f4e34c983b1933c1fae5762fe25220`
   - genesis `dendriteholdings/albedo-qwen3.6-35b-king-genesis` (prior king / chal-00224 opponent)
4. Serve with eval knobs: TP=2, max-model-len 32768, gpu_memory_utilization 0.80,
   FLASH_ATTN + moe-backend triton; GPU map teacher 0,1 / king 2,3 / chall 4,5
   (optional teacher replica 6,7).
5. Run real scoring path (sample or force-echo) on a public-D slice; score with
   `affine.affine.score.duel` under current knobs (r_lo=0.3, baseline_band=1.25,
   min_margin=0.02).

## Decision rule (pre-registered)

- **Gate MET** if kevin-as-challenger vs genesis-as-king (or mirrored roles
  matching chal-00224) yields a win for kevin with margin ≥ 0.04 on an 80-turn
  slice, or margin within ±0.02 of the published +0.070 under comparable setup.
- **Gate NOT MET** if engines fail to load, injectability fails, or margin is
  near zero / wrong sign with gates passing — debug stack before Stage 4 spend.

## Out of scope this experiment

No SFT, no merge, no submission. Stage 4 starts only after this gate.
