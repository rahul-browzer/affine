# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H40/H43–H46 live (5/5).** H41/H42 REFUTED.
No submit. Best live family = **H42 lr5e-6 m=+0.01613** (still <0.04).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$189,442** · cum mining ~$4,860 · **avail ~$179.4k** |
| miner | τ10.000 free · 0 submissions |
| H40 | chall :8002=000 (p219 recover; GPUs 4–5 occupied) |
| H43 | n80 b203 ~75/80 |
| H44 | n80 a203 ~19/80 |
| H45 | train r8/α16 (early) |
| H46 | bootstrap (H42 follow-up lr=2.5e-6) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h40-1 | gentle-eagle-c9 | 150.136.71.147:20300 | ~11:12Z | H40 chall recover |
| mine-h43-1 | noble-eagle-18 | 38.255.28.22:20099 | ~12:05Z | H43 n80 ~75/80 |
| mine-h44-1 | zesty-lion-e0 | 152.236.142.232:40298 | ~12:45Z | H44 n80 ~19/80 |
| mine-h45-1 | lunar-fox-40 | 152.236.142.236:40299 | ~13:13Z | H45 train r8 |
| mine-h46-1 | cosmic-fox-ea | 38.255.28.19:20100 | ~13:28Z | H46 bootstrap→train |

known_hosts `/tmp/mine-h{40,43,44,45,46}-1.known_hosts`.
**Free slots: 0.** Burn ~$160/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36 /
**H28@lr≥3e-5** / **H28@epochs≥2** / **H28@r≥32** / **H42@lr=5e-6**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.

## Next action

1. H43: poll n80 → decision. Margin >0.04 → Stage 5.
2. H44: poll n80 (~19→80).
3. H40: if chall still :8002=000 after recover → REFUTE-by-ops kill;
   fill non-α H28 (lr↓/α↓/data). Ep3 prior weak vs H38 null.
4. H45: poll train→merge→n80.
5. H46: poll bootstrap→train→merge→n80.
6. REFUTE → `lium rm mine-hN-1` only; fill gentler H28 variant.
