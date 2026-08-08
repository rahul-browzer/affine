# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H74–H78 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
**Live king:** Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$187,026** · cum ~$9,110 · **avail ~$177.0k** |
| miner | τ10.000 free · 0 submissions |
| H74 | n80 vs Tok a203 **~71/80** |
| H75 | n80 vs Tok a203 **~58/80** |
| H76 | **n80 STARTED** vs Tok a203 (retry refresh + recover264) |
| H77 | **merging** (shards writing; teacher/king up) |
| H78 | **merging** (shards writing; T200, K loading) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h74-1 | brave-orbit-28 | 152.236.142.236:40300 | ~22:42Z | **n80 vs Tok** ~71/80 |
| mine-h75-1 | cosmic-hawk-20 | 38.255.28.21:20100 | ~23:07Z | **n80 vs Tok** ~58/80 |
| mine-h76-1 | gentle-raven-df | 38.255.28.18:20100 | ~23:38Z | **n80 vs Tok** just started |
| mine-h77-1 | eager-shark-64 | 152.236.142.237:40306 | ~23:45Z | **merge** r17 |
| mine-h78-1 | eager-comet-a4 | 38.255.28.22:20100 | ~23:45Z | **merge** r21 |

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
**p298:** `/[r]etry_hN_n80\.sh/` still matches watcher argv — exclude `watch_n80_retry` or match `$0`.

## Next action

1. H74/H75/H76: await n80 `decision.json` vs Tok → tear / shortlist / submit-gate.
2. H76: watch recover264 finish warm+freeze without killing mid-n80; if
   FALSE_PROBE → quarantine + recover (not REFUTE).
3. H77/H78: await merge→chall→n80 vs Tok.
4. Free slot → non-α neighbor **KING=Tok331102 from rent** (if H72+H74 both
   m≤0, prefer new init/data axis over more r18).
