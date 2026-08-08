# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H88–H92 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
Best vs Tok: **H81 r22 m=+0.008811** (REFUTE; first Tok-init +).
**H87 r29 REFUTE** m=+0.005075 (torn down).
**Live king:** Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$185,620** · cum ~$11,100 · **avail ~$175.6k** |
| miner | τ10.000 free · 0 submissions |
| H88 | n80 a203 ~59/80 · mid304 · t/k/c=200 |
| H89 | n80 a203 ~67/80 · mid304 · t/k/c=200 |
| H90 | king340 loading util=0.72 · chall=200 · retry armed |
| H91 | king340 loading · merge shard1/2 · preempt wait chall |
| H92 | bootstrap (Tok-init r13) · COUNT=8 @$28 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h88-1 | zesty-hawk-be | 38.255.28.19:20100 | ~03:32Z+1d | n80+mid304 |
| mine-h89-1 | gentle-fox-06 | 152.236.142.237:40309 | ~03:38Z+1d | n80+mid304 |
| mine-h90-1 | noble-shark-3c | 152.236.142.232:40310 | ~04:23Z+1d | king340+retry |
| mine-h91-1 | brave-shark-d2 | 38.255.28.18:20099 | ~04:31Z+1d | king340+merge |
| mine-h92-1 | calm-lion-f6 | 152.236.142.236:40300 | ~05:12Z+1d | bootstrap r13 |

known_hosts `/tmp/mine-h{88,89,90,91,92}-1.known_hosts`. **Free: 0.** ~$148/h.
Non-mine `wan-lora-*` / `affine-*` — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: plmk/α/TP×ks/m7×ks/union/lr micro/ep≥2/r≤8∨=16–24∨≥32/α≤8∨=16∨≥64/clip≥0.08/king-self.
**m7×r17/r18 + Tok-init r17/r18/r22/r23/r25–r29 closed.** Open: H88–H92.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
Never `pkill -f`; match `$0` via `/proc/*/cmdline` (not SSH argv).
recover264=chall; king-only relaunch. Never sed live post_train.
mid304 for mid-n80 bare; preempt exits on isolated TCACHE.
Tok-init: `preprocessor_config` + real visual shard (index≠disk).
King Triton ENOENT → isolated TCACHE; OOM@util=0.80 → **0.72**.
H90/H91: await `h*_king_recover_pass340.done` before trusting :8001.
H91: merge→chall→preempt; arm mid304 when n80 starts.

## Next action

1. **H90/H91** confirm `*_king_recover_pass340.done` (re-fire if ENOENT).
2. **H91** merge→chall→preempt; arm mid304 when n80 starts.
3. **H88/H89** await n80 → `h*_decision.json` (keep mid304).
4. **H92** await train launch (`h92_train_launched.stamp`).
