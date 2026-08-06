# s4-h2-merge — Stage 4 H2: linear merge kevin × pandora-m4

## Hypothesis

**H2:** A linear weight merge of current king
`kevin954/Affine-5dfqbbh8ev-sft` @ `6a5815fad8f4e34c983b1933c1fae5762fe25220`
with reign-1 `pandora-box/Affine-5eqdtdzqle-ckpt300-m4` @
`5218b1383952ff7a8d49b1d7b82acfe5e1bd448d` yields S > kevin at near-zero
train cost (not weight-identical).

## Prediction (pre-registered)

First recipe `α=0.5` (equal mix, kevin as base for config/tokenizer/shard map):

- paired mean margin vs kevin on an 80-turn public-D slice **> 0.02**
- target for submit consideration: **> 0.04**, both sides valid, H4 envelope
  (r∈[0.70,0.85], base×≤1.15)

If margin < 0.02 after two recipes (`α∈{0.5, 0.65}`), refute H2 for these
parents.

## Method

1. On `mine-sim-1` (engines already hot from Stage 3): download pandora into
   pod HF cache (kevin already present).
2. `merge_linear.py` — per-tensor `out = α·kevin + (1−α)·pandora` in bf16;
   write local dir `/root/merges/h2-kp50/` using kevin's shard layout +
   config/tokenizer. Verify weight hash ≠ kevin.
3. Restart king:8001 = kevin, chall:8002 = merge path (teacher:8000 stays).
4. `run_sim_duel.py` — real `evalsrv.dueling.run_duel` path on 80-turn slice
   (seeded); score under current knobs.

## Decision rule

- **Advance toward submit** only if sim margin > 0.04, gates pass, H4 ok,
  loads under stock vllm serve.
- **Try α=0.65** if 0.02 ≤ margin ≤ 0.04 or gates soft-fail.
- **Refute H2 for these parents** if margin < 0.02 after α=0.5 and α=0.65.
- Never submit from this experiment without Stage-5 checklist + fresh hotkey.

## Out of scope

No host-side weights. No HF publish until margin clears. No validator edits.
