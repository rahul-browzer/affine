# s4-h1v2-sft — Stage 4 H1v2: thought-only distill (fix r / L1)

## Parent result (H1 n40)

`experiments/s4-h1-sft/` LoRA on full teacher `(z_C, y_C)` completions from
kevin init → n40 margin **−0.00241**, both valid, **H4 FAIL**
(r=**1.135**∉[0.70,0.85], base×=0.817 OK). Chall mean_Λ2 slightly **better**
than king (−0.0345 vs −0.0380) but implied clip-L1 collapsed (−0.0009 vs king
+0.0054). Diagnosis: full-completion SFT improved teacher-like thoughts (Λ2)
while wrecking the king's calibrated empty→conditioned lift (H3/H4 envelope).

n80 on H1 merge is confirmation only — **do not submit** that ckpt.

## Hypothesis (H1v2)

**Claim:** Masking SFT loss to teacher **thought tokens only** (`z_C`),
leaving action tokens (`y_C`) untrained, plus a milder schedule, restores
r∈[0.70,0.85] and positive clip-L1 while keeping the Λ2 gain — enough for
sim margin > 0.04 vs live kevin.

Mechanism: winners sit at r≈0.72–0.81 with clip-L1 ≈ +0.026–0.031. H1 pushed
r above 1.0 by also fitting `y_C` under `z_C`, which moved lpA(y_C|·) off the
king's envelope. Training only `</think>\nTHOUGHT: {z_C}` (stop before the
bash block) should move the thought sampler toward teacher without rewriting
the action head that carries L1lift.

## Prediction (pre-register BEFORE train)

On an 80-turn public-D slice in the Stage-3 simulator vs live king:

- paired mean margin ≥ **+0.04**
- both sides gate-valid
- H4: r∈[0.70,0.85], base×≤1.15
- chall mean implied clip-L1 ≥ **+0.015** (vs H1's −0.0009)

If margin ∈ [0.02, 0.04] with H4 OK → iterate (more thought-only steps / H5
warm-start); do **not** submit. If H4 still fails or margin < 0.02 → refute
H1v2 for this mask; try H5 next.

## Method

Reuse pod `mine-sim-1` engines (teacher:8000 king:8001) after H1 n80 finishes
or after deadman salvage + re-bootstrap. Same 440 `teacher_refs` rows.

1. **Data:** same jsonl; train script gains `--loss-on thought` that labels
   only tokens up to and including the thought body, then masks from the first
   `\n\n```bash` (or first triple-backtick bash fence) onward with `-100`.
2. **Train** (GPUs 6,7): kevin @ `6a5815…`, LoRA r=16 α=32, **lr=2e-5**
   (5× lower than H1's 1e-4), **1 epoch** (~55 steps), batch=1 accum=8,
   max_len=8192. Out: `/root/h1v2/`.
3. **Merge + chall-only re-serve** (reuse CausalLM→wrapper config + visual
   shard fix from H1 `merge_lora.py`).
4. **Sim:** n40 triage then n80 if n40 margin ≥ 0.01 and H4 OK; else abort
   and revise. Soft / deadman unchanged until next rental decision.

## Decision rule

- Submit gate unchanged: sim margin > **0.04** + H4 + stock vllm +
  `submit.py --check` + fresh hotkey.
- Never resubmit H1 merge (`3364892…`) or any weight-identical king copy.

## Fallback if H1v2 misses

1. Same mask, even milder (lr=1e-5, 0.5 epoch) if r overshoots again.
2. Else **H5**: warm-start from `michael-chan-000/affine-5EqYW8McUc-h2`
   near-miss with thought-only loss.
3. Do not burn a slot on envelope failures.

## Timing / money notes

- **TRAINING launched 2026-08-07T04:36:23Z** pid 147209 on GPUs 6,7
  (parallel with H1 n80). Drafted while H1 n80 still running (ETA ~35–40 min from 04:27Z launch;
  soft 06:50Z / deadman 07:00Z).
- No new rental this plan. Cap and Lium floor still bind before any new pod.
