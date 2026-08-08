# H96 pass351 — rent + bootstrap after H92 REFUTE

## Facts
- H92 n80 REFUTE m=+0.000618 z=0.087 base×0.980 r=0.681 vs Tok (gates OK).
- rm `mine-h92-1` / calm-lion-f6 (spent ~$47).
- Rented `mine-h96-1` / golden-matrix-af UUID
  `e88d6cf0-dd41-4191-96ce-bba9201c90fd` @$28/h `--ttl 12h`
  (pod id `1a80f477-8532-416d-8d3b-7863bdc2d2d0`).
- SSH `152.236.142.232:40299` known_hosts `/tmp/mine-h96-1.known_hosts`.
- COUNT=8 verified. Stack upload + bootstrap pid=900; form/retry/preempt armed.
- HF salvage: `unconst/Affine-5czsc2fc98-h96-{lora,merged}`.
- Hypothesis: Tok-init × winner-zA @ **r=9**.

## Next
Await bootstrap → train → merge → n80+mid304.
