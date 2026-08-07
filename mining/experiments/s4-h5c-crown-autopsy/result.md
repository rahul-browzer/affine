# s4-h5c-crown-autopsy — result

**UTC:** 2026-08-07T09:32Z (pass 100)
**Verdict: autopsy DONE → H5c train recipe locked (L1-headroom / expanded refs).**

## Artifacts

| file | what |
|---|---|
| `results/chal-00284.json.gz` | TalentPigs `…-abc` crown vs kevin (+0.028) |
| `results/chal-00273.json.gz` | TalentPigs `…-ppp` near-miss (−0.004) |
| `results/chal-00258.json.gz` | TalentPigs `…-ruby` miss (−0.0115) |
| `results/summary.json` | recomputed decomp + style |
| `results/table.txt` | human table |
| `analyze.py` | rerunnable autopsy |

## Crown vs kevin (chal-00284, current knobs)

| | TalentPigs abc | kevin (slice) | paired Δ |
|---|---|---|---|
| S / mix | **+0.0315** | +0.0035 | **+0.0280** |
| Λ2 | −0.0010 | −0.0133 | **+0.0123** |
| clip-L1 | **+0.0325** | +0.0167 | **+0.0157** |
| r | **0.720** | 0.926 | — |
| base× | 0.895 | — | — |
| z | — | — | **3.22** (wins) |

clip-L1 share of |Δmix| = **0.56**. Crown clears δ=0.02 and 3σ; published
margin matches recompute.

## Near-misses (same lineage, lost to kevin)

| id | repo suffix | margin | c clip-L1 | c Λ2 | c r | za μ chars |
|---|---|---|---|---|---|---|
| 00284 | **-abc** | **+0.0280** | **+0.0325** | −0.0010 | **0.720** | **232** |
| 00273 | -ppp | −0.0041 | +0.0232 | −0.0002 | 0.774 | 279 |
| 00258 | -ruby | −0.0115 | +0.0139 | +0.0000 | 0.940 | 270 |

abc vs ppp (nearest miss): Δclip-L1 **+0.0093**, ΔΛ2 ≈ 0, Δr −0.054
(into classic distill band), shorter thoughts (−47 chars), almost no list
markers (0.01 vs 0.46). **The lineage crowns when clip-L1 is high and r≈0.72,
not when Λ2 moves.**

## vs our H5b (refuted)

H5b n80 vs TalentPigs: margin +0.00322; Λ2 **+0.004**; clip-L1 **flat**
(+0.0336 vs king +0.0347); r=0.670 (below H4 band). We pushed the wrong
axis relative to how TalentPigs itself beat kevin, and matched (not beat)
the king's L1 envelope.

## Decision rule application → H5c recipe

Crown win is mostly Δclip-L1 (share ≥ 0.5) and near-misses lose on L1 while
Λ2≈0 → **L1-headroom path**.

**H5c (next GPU pass):**

1. Harvest **expanded** teacher_refs from all public duel gz (not the stale
   440-only set). Crown+near-miss alone already give 226 unique turns /
   959 samples; full index has 60 duels.
2. Init from **kevin** `6a5815…` (not TalentPigs) — kevin still sits in the
   reign and historically carries L1 when r is right; measure **only** vs
   live TalentPigs.
3. Thought-only LoRA, but target envelope of the crown: r∈[0.70,0.85],
   mean clip-L1 ≥ **0.042** (≥ TalentPigs crown +0.01), base×≤1.15.
4. Sim gate unchanged: n80 paired margin **> 0.04**, all gates green.
5. Prefer shorter teacher z (filter or loss weight); avoid list-heavy z.

**Prediction (pre-register before train):** n80 margin ≥ +0.04 vs
TalentPigs; H4 OK; chall mean clip-L1 ≥ 0.042.

**Do not:** another mild TalentPigs-init 440-ref LoRA; kevin×TalentPigs
merge (H5 REFUTED); submit any prior checkpoint.

## Live context at autopsy

- King still `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` reign 3 S=0.0315
- `current_eval` chal-00301 = kevin954 re-challenge (dispatching) — re-check
  snapshot before any future sim/submit
- Only published win in full index (60 duels): chal-00284
