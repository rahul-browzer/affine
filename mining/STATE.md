# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H49–H53 live (5/5).** H40–H48 REFUTED; **H45 REFUTE** m=+0.00819.
No submit. Best family still **H42 lr5e-6 m=+0.01613** (<0.04).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$188,846** · cum mining ~$5,900 · **avail ~$178.8k** |
| miner | τ10.000 free · 0 submissions |
| H49 | n80 retry#2 b203 **~57/80** (engines OK) |
| H50 | n80 a203 **~37/80** (engines OK) |
| H51 | chall Triton-dead@04:07 → **freeze recover** pid=28472/28548 @04:08Z |
| H52 | n80 a203 **~31/80** (engines OK) |
| H53 | n80 a203 **~15/80** (engines OK) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h49-1 | zesty-shark-45 | 86.38.238.54:40300 | ~13:59Z | H49 n80 b203 |
| mine-h50-1 | eager-hawk-5b | 152.236.142.237:40499 | ~15:03Z | H50 n80 a203 |
| mine-h51-1 | brave-lion-47 | 152.236.142.232:40300 | ~15:03Z | H51 freeze→n80 |
| mine-h52-1 | noble-wolf-4b | 38.255.28.18:20099 | ~15:05Z | H52 n80 a203 |
| mine-h53-1 | zesty-raven-e1 | 38.255.28.22:20100 | ~15:20Z | H53 n80 a203 |

known_hosts `/tmp/mine-h{49,50,51,52,53}-1.known_hosts`.
**Free slots: 0.** Burn ~$154/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36 /
**H28@lr≥3e-5** / **H28@epochs≥2** / **H28@r≥32** / **H42@lr=5e-6** /
**H43@α≥64** / **H40@ep≥2** / **H44@clipL1≥0.08** / **H47@α≤8** /
**H46@lr≤2.5e-6** / **H48@lr≤1e-6** / **H45@r≤8**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
H51: wait `h51_chall_freeze_pass240.done` — do **not** probe :8002 early.

## Next action

1. Poll H51 `/root/logs/h51_chall_freeze_pass240.done` → n80 b203 → decision.
2. Poll H49/H50/H52/H53 → `hN_decision.json` (H49 nearest finish).
3. REFUTE → `lium rm mine-hN-1` only; fill non-α H28-neighbour (not dead cells).
4. Hyperparams: H49 α4 · H50 lr7.5e-6 · H51 α16 · H52 lr6e-6 · H53 lr4e-6.
