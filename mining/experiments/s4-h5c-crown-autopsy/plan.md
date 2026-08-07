# s4-h5c-crown-autopsy — plan

**UTC opened:** 2026-08-07T09:31Z (pass 100)
**Hypothesis:** H5c (public TalentPigs crown decomposition → new lever)
**GPU:** none this pass (CPU autopsy only)

## Why this experiment

H5b (TalentPigs-init mild thought LoRA on 440 refs) got n80 margin
**+0.00322** — Λ2 +0.004, clip-L1 flat. Do not repeat that recipe.
STATE next-action #1: mine the public TalentPigs-vs-kevin crown duel
before spending more GPU.

## Method (this pass — free)

1. Download TalentPigs lineage duels vs kevin:
   - `chal-00284` crown (`…-abc`, margin +0.028, z=3.22)
   - `chal-00273` near-miss (`…-ppp`, −0.004)
   - `chal-00258` earlier miss (`…-ruby`, −0.0115)
2. Recompute under current knobs (`affine.affine.score`) and decompose
   S → Λ2 + clip(L1), r, base×, z_a length/style.
3. Pre-register H5c train recipe from the deciding numbers (not vibes).

## Pre-registered decision rule (for the train follow-up)

After this autopsy writes `results/summary.json` + `result.md`:

- If crown win is mostly **Δclip-L1** vs kevin (share ≥ 0.5) and
  near-misses lose on L1 while Λ2≈0 → H5c = **L1-headroom recipe**:
  kevin-init thought distill on **expanded** teacher_refs, target
  chall mean clip-L1 ≥ TalentPigs + 0.01 and r∈[0.70,0.85], sim
  margin > 0.04 vs live TalentPigs.
- If crown win is mostly **ΔΛ2** → H5c = stronger Λ2 distill / more
  refs from teacher z_C (not mild lr=1e-5 king-init).
- If style/length is the separator (short z, no lists) → bake that
  into the loss mask / data filter before train.

## Out of scope this pass

- No rental, no train, no submit.
- Tear down idle `mine-sim-1` if still burning with no GPU job.
