# H27 — clip-L1 shaping via high-L1 winner z_A

## Claim

α-merge is a ~1-in-260 lottery (LESSONS). Teacher-refs distill (H1/H5c/H6)
failed to raise mean clip-L1. Crown autopsy: TalentPigs beat kevin on
**Δclip-L1**, not Λ2. So train on the actual scored thoughts: challenger
`z_A` from public pairs with clipped L1lift ≥ 0.05, paired with teacher
`y_C`, init from live king TalentPigs.

## Method

1. Harvest (`harvest_high_l1_za.py`): c_clipL1≥0.028 duels + chal-00284;
   pair clipL1≥0.04; z≤300; drop listy; y=best teacher y_C → **406** ex
   (mean clipL1 0.089, z p50 182). See `results/harvest_stats.json`.
2. TalentPigs-init thought-only LoRA (same train_lora.py as H1v2/H5c),
   lr=1e-5 (between H5c 2e-5 and H6 5e-6), r=16/α32, 1 epoch.
3. Merge → n80 vs TalentPigs @ `dbfbb3e2…` (mine-h27-1, ttl→05:34Z).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; chall mean clip-L1 ≥ **0.042**; r∈[0.3,4];
base× ≤ 1.25.

## Decision rule

- margin > 0.04 + gates green → Stage 5 submit path.
- Genuine REFUTE (nested decision, not ConnectError) → tear pod, keep lesson.
- Do **not** requeue α0.90 mid-pack merges on the free slot.

## Distinguisher vs refuted

| hyp | init | data |
|---|---|---|
| H5c REFUTE | kevin | teacher z_C shortz |
| H6 REFUTE | TalentPigs | teacher z_C shortz-nolist mild lr |
| **H27** | TalentPigs | **winner z_A** high clip-L1 |
