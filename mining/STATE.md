# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H69–H73 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
**Live king:** Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$187,416** · cum ~$8,520 · **avail ~$177.4k** |
| miner | τ10.000 free · 0 submissions |
| H70 | n80 vs Tok ~17/80 (b203) |
| H69 | n80 ~68/80 vs TalentPigs (ranking only) |
| H71 | recover264 isolated chall loading → warm/freeze → n80 Tok |
| H72 | train r18 + teacher/Tok DL |
| H73 | train r19 + teacher/Tok DL |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h69-1 | noble-eagle-06 | 38.255.28.22:20100 | ~21:08Z | n80 ~68/80 old king |
| mine-h70-1 | cosmic-raven-9e | 38.255.28.18:20100 | ~21:42Z | **n80 vs Tok** |
| mine-h71-1 | eager-fox-be | 152.236.142.237:40311 | ~22:05Z | recover264→n80 Tok |
| mine-h72-1 | golden-comet-7a | 152.236.142.232:40299 | ~22:20Z | train r18-rep |
| mine-h73-1 | eager-matrix-9a | 38.255.28.19:20100 | ~22:21Z | train r19-rep |

known_hosts `/tmp/mine-h{69,70,71,72,73}-1.known_hosts`.
**Free slots: 0.** Burn ~$152/h mining.
Non-mine `wan-lora-train` on account — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**. H69=ranking-only.
Dead: plmk/α/TP×ks/m7×ks/union/lr∈{≤2.5e-6,4e-6,4.95,5.02,5.05,5.08,5.1,5.15,5.25,5.3,5.5,5.75,6,7.5,8,≥3e-5}/ep≥2/r≤8∨=18∨=20∨=24∨≥32/α≤8∨=16∨≥64/clip≥0.08/H42@5e-6.
**r=18/19 research-open** (H72/H73 reps). FALSE_PROBE≠REFUTE; never rm non-mine.
Reject COUNT≠8 or $/h<$20. Never `pkill -f`; kill by PID. recover264 owns chall → king-only relaunch.
Never sed live post_train. Preempt: skip isolated TCACHE / if recover alive (p283).

## Next action

1. H71: await recover264 warm→freeze→rearm → n80 vs Tok.
2. H70: await n80 decision vs Tok → tear / shortlist / submit-gate.
3. H69 (~68/80): decision vs TalentPigs — tear if m≤0.04; else re-sim vs Tok.
4. H72/H73: train → merge → n80 vs Tok.
5. Free slot → non-α neighbor **KING=Tok331102 from rent** (prefer
   replicate best shortlist cell, not 1% lr step).
