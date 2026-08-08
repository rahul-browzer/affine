# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H71–H75 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
**Live king:** Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$187,229** · cum ~$8,810 · **avail ~$177.2k** |
| miner | τ10.000 free · 0 submissions |
| H70 | **REFUTE** m=−0.000525 vs Tok → tore; **lr=5.01e-6 dead** |
| H71 | n80 vs Tok a203 **~67/80** |
| H72 | n80 vs Tok a203 **~53/80** |
| H73 | n80 vs Tok a203 **~56/80** |
| H74 | **n80 LIVE** vs Tok a203 (salvage264 freeze n_so=22) |
| H75 | **train** r18 step **26**/~110 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h71-1 | eager-fox-be | 152.236.142.237:40311 | ~22:05Z | **n80 vs Tok** ~67/80 |
| mine-h72-1 | golden-comet-7a | 152.236.142.232:40299 | ~22:20Z | **n80 vs Tok** ~53/80 |
| mine-h73-1 | eager-matrix-9a | 38.255.28.19:20100 | ~22:21Z | **n80 vs Tok** ~56/80 |
| mine-h74-1 | brave-orbit-28 | 152.236.142.236:40300 | ~22:42Z | **n80 vs Tok** just started |
| mine-h75-1 | cosmic-hawk-20 | 38.255.28.21:20100 | ~23:07Z | **train** r18 @26 |

known_hosts `/tmp/mine-h{71,72,73,74,75}-1.known_hosts`.
**Free slots: 0.** Burn ~$148/h mining.
Non-mine `wan-lora-train` / `affine-*` — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: plmk/α/TP×ks/m7×ks/union/lr∈{≤2.5e-6,4e-6,4.95,**5.01**,5.02,5.05,5.08,5.1,5.15,5.25,5.3,5.5,5.75,6,7.5,8,≥3e-5}/ep≥2/r≤8∨=20∨=24∨≥32/α≤8∨=16∨≥64/clip≥0.08/H42@5e-6.
**r=18/19 research-open** (H72/H74/H75 reps + H73 r19). H69 r17 shortlist-weak.
FALSE_PROBE≠REFUTE; never rm non-mine. Reject COUNT≠8 or $/h<$20.
Never `pkill -f`; kill by PID. recover264 owns chall → king-only relaunch.
Never sed live post_train. Preempt: skip isolated TCACHE / if recover alive.
Stale retry poll≳100 before chall up → kill retry PID (watcher relaunches).

## Next action

1. H71/H72/H73: await n80 `decision.json` vs Tok → tear / shortlist / submit-gate.
2. H74: await n80 `decision.json` (salvage264 done; sim live a203).
3. H75: await train→merge→chall→n80 vs Tok.
4. Free slot → non-α neighbor **KING=Tok331102 from rent** (prefer
   replicate best shortlist cell, not 1% lr step).
