# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H16/H17 REFUTED (band-clear, weak margin). H18–H20 n80 recovering.**
H1–H17/H5c/H6 **REFUTED**. Cap **3/5** (2 free). No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | $32,738 · ~$1,380 · cap rem ~$2,620 |
| miner | τ10.000 free · 0 submissions |
| H16 | REFUTE m=+0.0097 base×**1.146** valid — pod rm |
| H17 | REFUTE m=−0.0037 base×**1.133** valid — pod rm |
| H18 | teacher recover → n80 retry @15:27Z |
| H19 | king recover → n80 @15:27Z |
| H20 | false probe cleared; chall recover → n80 retry @15:27Z |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h18-1 | golden-comet-e1 | 152.236.142.232:40307 | 22:57Z | H18 n80 retry |
| mine-h19-1 | eager-eagle-c6 | 152.236.142.234:40297 | 22:50Z | H19 n80 |
| mine-h20-1 | swift-lion-ac | 38.255.28.22:20100 | 22:53Z | H20 n80 retry |

known_hosts `/tmp/mine-h{18,19,20}-1.known_hosts`. **2 free slots.**

## Blocked

No submit until some n80 margin > 0.04. α0.90 band-clear but near-zero
margin on plmk/kkk-af — do not α-sweep those B's further. Next free-slot
hyps must be a **new parent class** (e.g. syntaxsorcerer1/sft2 +0.0109,
alskdjf +0.0139 if ungated) or non-linear merge / distill — not another
TP×near-miss α0.90.

## Next action

**Poll H18/H19/H20 nested `*_decision.json`.** On genuine REFUTE (non-null
margin or real INVALID): `lium rm` that `mine-h*-1` only. Ignore
`*.FALSE_PROBE.json`. With free slots: rent ≤2 new `mine-h21/h22` on
untried accessible B (verify HF first) — not α-retry of H12–H17 parents.
TRY_ALPHA_095 only if gate-valid and 0.02≤m≤0.04.
