# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H75–H79 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
**Live king:** Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$186,979** · cum ~$9,210 · **avail ~$177.0k** |
| miner | τ10.000 free · 0 submissions |
| H74 | **REFUTE** m=−0.011003 vs Tok (torn) |
| H75 | n80 vs Tok a203 **~75/80** (engines OK) |
| H76 | king EngineDead@18/80 → **king300 recover** loading :8001 |
| H77 | recover264 health=200 → settle/warm/freeze → n80 |
| H78 | merge.done; chall still loading :8002 |
| H79 | bootstrap: Tok-init download after venv |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h75-1 | cosmic-hawk-20 | 38.255.28.21:20100 | ~23:07Z | **n80 vs Tok** ~75/80 |
| mine-h76-1 | gentle-raven-df | 38.255.28.18:20100 | ~23:38Z | **king300** → n80 retry |
| mine-h77-1 | eager-shark-64 | 152.236.142.237:40306 | ~23:44Z | recover264 warm→n80 |
| mine-h78-1 | eager-comet-a4 | 38.255.28.22:20100 | ~23:44Z | **chall load** → n80 |
| mine-h79-1 | lunar-shark-be | 152.236.142.232:40100 | ~00:18Z+1d | bootstrap Tok-init dl |

known_hosts `/tmp/mine-h{75,76,77,78,79}-1.known_hosts`.
**Free slots: 0.** Burn ~$152/h mining.
Non-mine `wan-lora-train` / `affine-*` — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: plmk/α/TP×ks/m7×ks/union/lr∈{≤2.5e-6,4e-6,4.95,5.01,5.02,5.05,5.08,5.1,5.15,5.25,5.3,5.5,5.75,6,7.5,8,≥3e-5}/ep≥2/r≤8∨=**16**∨=**19**∨=20∨=24∨≥32/α≤8∨=16∨≥64/clip≥0.08/H42@5e-6/king-self.
**r=18 research-open** (H75/H76; H72+H74 both m≤0 — no more r18 m7 rents).
**r=17/21 open** (H77/H78). **Tok-init open** (H79).
FALSE_PROBE≠REFUTE; never rm non-mine. Reject COUNT≠8 or $/h<$20.
Never `pkill -f`; kill by PID. recover264 owns chall → king-only relaunch.
Never sed live post_train. Preempt: skip isolated TCACHE / if recover alive.
Stale retry poll≳100 before chall up → kill retry PID (watcher relaunches).
**p298/p300:** never match script path in SSH argv — use `/proc/*/cmdline` `$0`.

## Next action

1. H75: await `decision.json` vs Tok → tear / shortlist / submit-gate.
2. H76: await king300 PROMPTABLE → retry n80 a203 → `decision.json`.
3. H77: await recover264 freeze → n80; FAIL×3 → quarantine, not REFUTE.
4. H78: await chall promptable → n80 vs Tok.
5. H79: await bootstrap→train→merge→n80 vs Tok.
6. Free slot → non-α neighbor; **no more m7×r18**; prefer init/data or r≠18.
