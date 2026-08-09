# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F15**/F19–**F21**/F24 **REFUTE**.
**F16–F18,F22,F23,F25 live** (6 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$181,213** · cum ~$16,528 · **avail ~$171.2k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$245.3/h** (6 mine-*) ≪ $833/h · free slots **14** |
| n80 | F16~70 F18~64 F25~32 F17~6 (retry4 after 400) |
| other | F22 everest DL 92% (11/12); F23 king incomplete ~27G growing |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f16-1 | calm-wolf-2f | 152.236.142.236:40311 | ~13:57Z | F16 **n80 ~70** |
| mine-f17-1 | eager-eagle-f3 | 38.255.28.18:20099 | ~14:02Z | F17 **n80 ~6** (retry4) |
| mine-f18-1 | cosmic-matrix-19 | 86.38.238.54:40300 | ~14:06Z | F18 **n80 ~64** |
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 everest DL 92% |
| mine-f23-1 | lunar-matrix-eb | 204.9.206.244:40301 | ~14:31Z | F23 king DL growing |
| mine-f25-1 | eager-orbit-09 | 3.135.191.208:20126 | ~15:20Z | F25 **n80 ~32** |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F15**/F19–**F21**/F24/king-init refs.
Open: H111–H113/H117–H118/H120/F16–F18/F22/F23/F25. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Poll F16 (~70) then F18 (~64)** — first finish; >+0.015 CONFIRM k=4; ≤0 REFUTE+tear.
   Note: raw af-k1 F24 m=−0.087 — F16 LoRA on same base is unlikely; still let screen finish.
2. F25 (~32): continue; F17 retry4 — confirm progress growing (engines 200).
3. F22/F23: DLs growing (F22 92%) — Range-resume only if mtime freeze.
4. Hold CONFIRM slots. Next rent = new structural family (not another raw past-earner).
   Candidates: **full-FT** (F3 was still LoRA), or F5 if traj appears.
