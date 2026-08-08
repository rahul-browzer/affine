# H61 — m7×winner-zA @ lr=5.15e-6

**Claim:** denser probe of the open 5.1–5.25 gap: H58@5.1e-6 (open)
↔ H57@5.25e-6 (REFUTE m=+0.01537). One-axis: **lr=5.15e-6**.
(H60@5.3 sits above the dead 5.25 point; H42@5e-6 still best +0.01613.)

**Method:** same H28 cell — m7-init, winner-zA 406, thought-only LoRA r16/α32,
1 epoch, lr=**5.15e-6**. n80 vs TalentPigs king.

**Decision rule:** REFUTE if n80 paired margin ≤0.04 or any gate fail.

**Rent note:** before launch, patch `post_train_pipeline.sh` SOFT/DEADMAN
`:-` defaults to ≥TTL−1h (env alone dies on restart). Prefer UUID @$≥28/h,
verify nvidia-smi COUNT=8. If H56 n80 reports first, launch **H62 r=20**
(`s4-h62-m7-winner-za-r20/`) instead of this hyp.
