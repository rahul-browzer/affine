# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H40/H42–H45 live (5/5).** H41 REFUTED m=+0.00533.
No submit. Best live family = H28 winner-zA (m=+0.01095).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$189,499** · cum mining ~$4,810 · **avail ~$179.5k** |
| miner | τ10.000 free · 0 submissions |
| H40 | chall p219 recover (p218 .so+shm abort; ep3 weak prior) |
| H42 | n80 b203 ~48/80 |
| H43 | n80 b203 ~48/80 |
| H44 | merge done; chall health=200 @01:14Z → n80 imminent |
| H45 | bootstrap (pip) after H41 refute fill — r=8/α16 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h40-1 | gentle-eagle-c9 | 150.136.71.147:20300 | ~11:12Z | H40 chall p219→n80 |
| mine-h42-1 | cosmic-matrix-bb | 38.255.28.21:20100 | ~12:04Z | H42 n80 b203 |
| mine-h43-1 | noble-eagle-18 | 38.255.28.22:20099 | ~12:05Z | H43 n80 b203 |
| mine-h44-1 | zesty-lion-e0 | 152.236.142.232:40298 | ~12:45Z | H44 n80 arming |
| mine-h45-1 | lunar-fox-40 | 152.236.142.236:40299 | ~13:13Z | H45 bootstrap→train |

known_hosts `/tmp/mine-h{40,42,43,44,45}-1.known_hosts`.
**Free slots: 0.** Burn ~$160/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36 /
**H28@lr≥3e-5** / **H28@epochs≥2** / **H28@r≥32**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.

## Next action

1. H42/H43: poll n80 → decision. Margin >0.04 → Stage 5.
2. H44: confirm triple-promptable + n80 started (freeze TCACHE after warmup).
3. H40: wait p219 freeze+promptable → n80; if .so/shm again → consider
   REFUTE-by-ops kill (ep3 prior weak vs H38 null) and fill gentler/data.
4. H45: poll bootstrap→train→merge→n80.
5. REFUTE → `lium rm mine-hN-1` only; fill non-α H28 (lr↓/α↓/data).
