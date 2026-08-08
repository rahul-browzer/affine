# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H72–H76 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
**Live king:** Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$187,181** · cum ~$8,890 · **avail ~$177.2k** |
| miner | τ10.000 free · 0 submissions |
| H71 | **REFUTE** m=−0.013655 vs Tok → tore; **r=16 dead** |
| H72 | n80 vs Tok a203 **~68/80** |
| H73 | n80 vs Tok a203 **~72/80** |
| H74 | n80 vs Tok a203 **~15/80** |
| H75 | merge done; chall :8002 loading |
| H76 | **bootstrap** r18-rep#4 just launched |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h72-1 | golden-comet-7a | 152.236.142.232:40299 | ~22:20Z | **n80 vs Tok** ~68/80 |
| mine-h73-1 | eager-matrix-9a | 38.255.28.19:20100 | ~22:21Z | **n80 vs Tok** ~72/80 |
| mine-h74-1 | brave-orbit-28 | 152.236.142.236:40300 | ~22:42Z | **n80 vs Tok** ~15/80 |
| mine-h75-1 | cosmic-hawk-20 | 38.255.28.21:20100 | ~23:07Z | **serve chall** after merge |
| mine-h76-1 | gentle-raven-df | 38.255.28.18:20100 | ~23:38Z | **bootstrap** r18-rep#4 |

known_hosts `/tmp/mine-h{72,73,74,75,76}-1.known_hosts`.
**Free slots: 0.** Burn ~$152/h mining.
Non-mine `wan-lora-train` / `affine-*` — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: plmk/α/TP×ks/m7×ks/union/lr∈{≤2.5e-6,4e-6,4.95,5.01,5.02,5.05,5.08,5.1,5.15,5.25,5.3,5.5,5.75,6,7.5,8,≥3e-5}/ep≥2/r≤8∨=**16**∨=20∨=24∨≥32/α≤8∨=16∨≥64/clip≥0.08/H42@5e-6.
**r=18/19 research-open** (H72/H74/H75/H76 reps + H73 r19). H69 r17 shortlist-weak.
FALSE_PROBE≠REFUTE; never rm non-mine. Reject COUNT≠8 or $/h<$20.
Never `pkill -f`; kill by PID. recover264 owns chall → king-only relaunch.
Never sed live post_train. Preempt: skip isolated TCACHE / if recover alive.
Stale retry poll≳100 before chall up → kill retry PID (watcher relaunches).

## Next action

1. H72/H73: await n80 `decision.json` vs Tok → tear / shortlist / submit-gate.
2. H74: await n80 progress → decision.
3. H75: await chall promptable → n80 vs Tok.
4. H76: await train→merge→chall→n80 vs Tok.
5. Free slot → non-α neighbor **KING=Tok331102 from rent** (prefer
   replicate best shortlist cell, not 1% lr step).
