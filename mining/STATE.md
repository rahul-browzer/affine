# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H39–H43 live (5/5).** H37/H38 REFUTED (near-null).
No submit. Best live family = H28 winner-zA (m=+0.01095).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$189,697** · cum mining ~$4,550 · **avail ~$179.7k** |
| miner | τ10.000 free · 0 submissions |
| H39 | n80 a203 @ **~46**/80 (healthy) |
| H40 | chall p216 loading (isolated TCACHE; p215 died mid-init) |
| H41 | n80 a203 @ **~8**/80 (healthy) |
| H42 | train done → **merging** LoRA |
| H43 | train done → **merging** LoRA |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h39-1 | swift-wolf-6e | 86.38.238.54:40301 | ~11:11Z | H39 n80 a203 |
| mine-h40-1 | gentle-eagle-c9 | 150.136.71.147:20300 | ~11:12Z | H40 chall→n80 |
| mine-h41-1 | zesty-lion-26 | 38.255.28.19:20099 | ~11:14Z | H41 n80 a203 |
| mine-h42-1 | cosmic-matrix-bb | 38.255.28.21:20100 | ~12:04Z | H42 merge→n80 |
| mine-h43-1 | noble-eagle-18 | 38.255.28.22:20099 | ~12:05Z | H43 merge→n80 |

known_hosts `/tmp/mine-h{39,40,41,42,43}-1.known_hosts`.
**Free slots: 0.** Burn ~$170/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36 /
**H28@lr≥1e-4** / **H28@epochs≥2**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.

## Next action

1. H40: wait chall health + completions×2 (p216 chall_pid=29824,
   TCACHE `/root/.triton/isolated/h40_chall_p216_*`). If Triton .so dies
   again → recover with isolated TCACHE (not `cache/chall_*`).
2. H39/H41: poll n80 → decision. Margin >0.04 → Stage 5.
3. H42/H43: poll merge.done → chall serve → hashed n80.
4. REFUTE → `lium rm mine-hN-1` only; fill non-α H28 (data/α axes open).
