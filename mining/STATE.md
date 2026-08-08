# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H40–H44 live (5/5).** H39 REFUTED m=+0.00544.
No submit. Best live family = H28 winner-zA (m=+0.01095).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$189,598** · cum mining ~$4,630 · **avail ~$179.6k** |
| miner | τ10.000 free · 0 submissions |
| H40 | chall p217b loading + freeze-after-warmup (p216 post-comp .so race) |
| H41 | n80 a203 @ **~52**/80 (healthy; form watcher rearmed) |
| H42 | merging (~3 shards) |
| H43 | merging (~3 shards) |
| H44 | bootstrap/pip (clipL1≥0.08 data, H28 hyps) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h40-1 | gentle-eagle-c9 | 150.136.71.147:20300 | ~11:12Z | H40 chall→n80 |
| mine-h41-1 | zesty-lion-26 | 38.255.28.19:20099 | ~11:14Z | H41 n80 a203 |
| mine-h42-1 | cosmic-matrix-bb | 38.255.28.21:20100 | ~12:04Z | H42 merge→n80 |
| mine-h43-1 | noble-eagle-18 | 38.255.28.22:20099 | ~12:05Z | H43 merge→n80 |
| mine-h44-1 | zesty-lion-e0 | 152.236.142.232:40298 | ~12:45Z | H44 train→n80 |

known_hosts `/tmp/mine-h{40,41,42,43,44}-1.known_hosts`.
**Free slots: 0.** Burn ~$164/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36 /
**H28@lr≥3e-5** / **H28@epochs≥2**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.

## Next action

1. H40: wait recover217 freeze+triple-promptable → n80. If CUDA-graph hang
   again (shm_broadcast >5m after "Registering N addresses") → kill+clear
   `/root/.cache/vllm/torch_compile_cache` + relaunch.
2. H41: poll n80 → decision. Margin >0.04 → Stage 5.
3. H42/H43: poll merge.done → chall serve → hashed n80.
4. H44: poll train → merge → n80.
5. REFUTE → `lium rm mine-hN-1` only; fill non-α H28 (data/α axes).
