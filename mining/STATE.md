# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H74–H78 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
**Live king:** Tok331102 S=0.04456 (reign 4).
H72@r18 / H73@r19 both **m<0 vs Tok** this pass.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$187,135** · cum ~$9,000 · **avail ~$177.1k** |
| miner | τ10.000 free · 0 submissions |
| H72 | **REFUTE** m=−0.009356 vs Tok → tore |
| H73 | **REFUTE** m=−0.005810 vs Tok → **r=19 dead** · tore |
| H74 | n80 vs Tok a203 **~30/80** |
| H75 | n80 vs Tok a203 **~2/80** (recover264 done) |
| H76 | **training** r18-rep#4 |
| H77 | **bootstrap** r17 vs Tok just launched |
| H78 | **bootstrap** r21 vs Tok just launched |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h74-1 | brave-orbit-28 | 152.236.142.236:40300 | ~22:42Z | **n80 vs Tok** ~30/80 |
| mine-h75-1 | cosmic-hawk-20 | 38.255.28.21:20100 | ~23:07Z | **n80 vs Tok** ~2/80 |
| mine-h76-1 | gentle-raven-df | 38.255.28.18:20100 | ~23:38Z | **train** r18 |
| mine-h77-1 | eager-shark-64 | 152.236.142.237:40306 | ~23:45Z | **bootstrap** r17 |
| mine-h78-1 | eager-comet-a4 | 38.255.28.22:20100 | ~23:45Z | **bootstrap** r21 |

known_hosts `/tmp/mine-h{74,75,76,77,78}-1.known_hosts`.
**Free slots: 0.** Burn ~$152/h mining.
Non-mine `wan-lora-train` / `affine-*` — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: plmk/α/TP×ks/m7×ks/union/lr∈{≤2.5e-6,4e-6,4.95,5.01,5.02,5.05,5.08,5.1,5.15,5.25,5.3,5.5,5.75,6,7.5,8,≥3e-5}/ep≥2/r≤8∨=**16**∨=**19**∨=20∨=24∨≥32/α≤8∨=16∨≥64/clip≥0.08/H42@5e-6.
**r=18 research-open** (H74/H75/H76; H72 one negative draw). **r=17/21 open** (H77/H78).
FALSE_PROBE≠REFUTE; never rm non-mine. Reject COUNT≠8 or $/h<$20.
Never `pkill -f`; kill by PID. recover264 owns chall → king-only relaunch.
Never sed live post_train. Preempt: skip isolated TCACHE / if recover alive.
Stale retry poll≳100 before chall up → kill retry PID (watcher relaunches).

## Next action

1. H74/H75: await n80 `decision.json` vs Tok → tear / shortlist / submit-gate.
2. H76: await train→merge→chall→n80 vs Tok.
3. H77/H78: await bootstrap→train→n80 vs Tok.
4. Free slot → non-α neighbor **KING=Tok331102 from rent** (if H72+H74 both
   m≤0, prefer new init/data axis over more r18).
