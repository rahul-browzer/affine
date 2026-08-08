# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H91–H95 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
Best vs Tok: **H81 r22 m=+0.008811** (REFUTE; first Tok-init +).
**Live king:** Tok331102 S=0.04456 (reign 4).
**H90 REFUTE** m=−0.008472 (Tok-init r14 dead).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$185,220** · cum ~$11,646 · **avail ~$175.2k** |
| miner | τ10.000 free · 0 submissions |
| H91 | n80 **b203** attempt2 ~1/80 + mid304 (a203 died king 400) |
| H92 | n80 a203 ~54/80 + mid304 |
| H93 | n80 a203 ~16/80 + mid304 (recover264 DONE) |
| H94 | n80 a203 just started + mid304 (king recover OK) |
| H95 | **TRAIN_LAUNCHED** pid=4987 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h91-1 | brave-shark-d2 | 38.255.28.18:20099 | ~04:31Z+1d | n80 b203+mid304 |
| mine-h92-1 | calm-lion-f6 | 152.236.142.236:40300 | ~05:12Z+1d | n80+mid304 |
| mine-h93-1 | eager-raven-1e | 38.255.28.22:20099 | ~05:21Z+1d | n80+mid304 |
| mine-h94-1 | cosmic-fox-43 | 152.236.142.237:40311 | ~05:27Z+1d | n80+mid304 |
| mine-h95-1 | calm-raven-0f | 38.255.28.19:20100 | ~06:05Z+1d | train |

known_hosts `/tmp/mine-h{91,92,93,94,95}-1.known_hosts`. **Free: 0.** ~$152/h.
Non-mine `wan-lora-*` / `affine-*` — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: plmk/α/TP×ks/m7×ks/union/lr micro/ep≥2/r≤8∨=14∨=16–24∨≥32/α≤8∨=16∨≥64/clip≥0.08/king-self.
**m7×r17/r18 + Tok-init r14/r17/r18/r22/r23/r25–r31 closed.** Open: H91–H95.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
Never `pkill -f`; match `$0` via `/proc/*/cmdline` (not SSH argv).
recover264=chall; king-only relaunch. Never sed live post_train.
mid304 for mid-n80 bare; preempt exits on isolated TCACHE.
Tok-init: `preprocessor_config` + real visual shard (index≠disk).
King Triton ENOENT → isolated TCACHE; OOM@util=0.80 → **0.72**.
Seed chall from **live king isolated TCACHE** (not bare `cache/king`).
recover264/king-recover rearm form+n80 only — **arm mid304 when n80 starts**.

## Next action

1. **H91/H92/H93/H94** await n80 → `h{91..94}_decision.json` (keep mid304).
2. **H95** await merge/serve → n80; arm mid304 when n80 starts.
3. On any REFUTE: `lium rm` that `mine-*` only, fill slot with next open r.
