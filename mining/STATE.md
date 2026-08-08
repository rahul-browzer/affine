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
| Lium / spend | **~$186,908** · cum ~$9,365 · **avail ~$176.9k** |
| miner | τ10.000 free · 0 submissions |
| H75 | **REFUTE** m=+0.000550 z=0.101 vs Tok (torn) |
| H76 | **n80 LIVE** a203 chall 7/80 (pid28298) + mid304 |
| H77 | king302 DONE → **n80 LIVE** a203 pid24423 + mid304 |
| H78 | **n80 LIVE** a203 chall13/king12 + mid304 |
| H79 | merge_lora Tok-init@r18 (config.json present) |
| H80 | train_lora Tok-init@r17 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h76-1 | gentle-raven-df | 38.255.28.18:20100 | ~23:38Z | **n80 a203** + mid304 |
| mine-h77-1 | eager-shark-64 | 152.236.142.237:40306 | ~23:44Z | **n80 a203** + mid304 |
| mine-h78-1 | eager-comet-a4 | 38.255.28.22:20100 | ~23:44Z | **n80 a203** + mid304 |
| mine-h79-1 | lunar-shark-be | 152.236.142.232:40100 | ~00:18Z+1d | merge → chall |
| mine-h80-1 | eager-shark-18 | 152.236.142.236:40311 | ~00:26Z+1d | train Tok-init r17 |

known_hosts `/tmp/mine-h{76,77,78,79,80}-1.known_hosts`.
**Free slots: 0.** Burn ~$148/h mining.
Non-mine `wan-lora-train` / `affine-*` — **do not touch**.
**mid304:** continuous bare-TCACHE guard while sim alive (p304); one-shot preempt ≠ enough.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: plmk/α/TP×ks/m7×ks/union/lr∈{≤2.5e-6,4e-6,4.95,5.01,5.02,5.05,5.08,5.1,5.15,5.25,5.3,5.5,5.75,6,7.5,8,≥3e-5}/ep≥2/r≤8∨=**16**∨=**19**∨=20∨=24∨≥32/α≤8∨=16∨≥64/clip≥0.08/H42@5e-6/king-self.
**m7×r18 closed for new rents** (H72/H74/H75 m≈≤0; H76 last draw).
**r=17 open** (H77 m7; H80 Tok-init). **r=21 open** (H78 n80). **Tok-init open** (H79/H80).
FALSE_PROBE≠REFUTE; never rm non-mine. Reject COUNT≠8 or $/h<$20.
Never `pkill -f`; kill by PID. recover264 owns chall → king-only relaunch.
Never sed live post_train. Preempt: skip isolated TCACHE / if recover alive.
Stale retry poll≳100 before chall up → kill retry PID (watcher relaunches).
**p298/p300/p302:** match `$0` via `/proc/*/cmdline`. King recover stuck orphan → re-fire.
**p303/p304:** recover264 DONE rearms form+n80 only — one-shot preempt exits on
isolated; use **mid304** continuous guard for mid-n80 bare.

## Next action

1. H76/H77/H78: await n80 → `decision.json`. FAIL×3 → quarantine, not REFUTE.
2. H79: await merge→chall serve→n80 vs Tok (preempt+mid304 armed).
3. H80: await train→merge→n80 vs Tok.
4. Free slot → non-α neighbor; **no m7×r18**; prefer Tok-init / data / r∉{18,16,19,20}.
