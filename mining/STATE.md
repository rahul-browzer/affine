# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H76–H80 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
**Live king:** Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$186,931** · cum ~$9,315 · **avail ~$176.9k** |
| miner | τ10.000 free · 0 submissions |
| H75 | **REFUTE** m=+0.000550 z=0.101 vs Tok (torn) |
| H76 | king302 re-fire loading (pass300 orphan stuck) → n80 |
| H77 | king302 recover loading (Triton ENOENT@12:25) → n80 |
| H78 | recover264 chall loading (n_so 16→22 salvage) |
| H79 | train_lora Tok-init@r18 (pid live) |
| H80 | bootstrap Tok DL → train r17 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h76-1 | gentle-raven-df | 38.255.28.18:20100 | ~23:38Z | king302 → n80 |
| mine-h77-1 | eager-shark-64 | 152.236.142.237:40306 | ~23:44Z | king302 → n80 |
| mine-h78-1 | eager-comet-a4 | 38.255.28.22:20100 | ~23:44Z | recover264 chall load |
| mine-h79-1 | lunar-shark-be | 152.236.142.232:40100 | ~00:18Z+1d | train Tok-init r18 |
| mine-h80-1 | eager-shark-18 | 152.236.142.236:40311 | ~00:26Z+1d | Tok DL → train r17 |

known_hosts `/tmp/mine-h{76,77,78,79,80}-1.known_hosts`.
**Free slots: 0.** Burn ~$148/h mining.
Non-mine `wan-lora-train` / `affine-*` — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: plmk/α/TP×ks/m7×ks/union/lr∈{≤2.5e-6,4e-6,4.95,5.01,5.02,5.05,5.08,5.1,5.15,5.25,5.3,5.5,5.75,6,7.5,8,≥3e-5}/ep≥2/r≤8∨=**16**∨=**19**∨=20∨=24∨≥32/α≤8∨=16∨≥64/clip≥0.08/H42@5e-6/king-self.
**m7×r18 closed for new rents** (H72/H74/H75 m≈≤0; H76 last draw).
**r=17 open** (H77 m7; H80 Tok-init). **r=21 open** (H78). **Tok-init open** (H79/H80).
FALSE_PROBE≠REFUTE; never rm non-mine. Reject COUNT≠8 or $/h<$20.
Never `pkill -f`; kill by PID. recover264 owns chall → king-only relaunch.
Never sed live post_train. Preempt: skip isolated TCACHE / if recover alive.
Stale retry poll≳100 before chall up → kill retry PID (watcher relaunches).
**p298/p300/p302:** match `$0` via `/proc/*/cmdline`. King recover stuck orphan → re-fire.

## Next action

1. H76: await king302 PROMPTABLE → retry n80 a203 → `decision.json`.
2. H77: await king302 PROMPTABLE → retry n80 a203 → `decision.json`.
3. H78: await recover264 freeze → n80; FAIL×3 → quarantine, not REFUTE.
4. H79: await train→merge→n80 vs Tok.
5. H80: await bootstrap→train→merge→n80 vs Tok.
6. Free slot → non-α neighbor; **no m7×r18**; prefer Tok-init / data / r∉{18,16,19,20}.
