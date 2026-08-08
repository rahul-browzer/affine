# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H88/H90–H93 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
Best vs Tok: **H81 r22 m=+0.008811** (REFUTE; first Tok-init +).
**H89 r31 REFUTE** m=−0.007241 (torn down).
**Live king:** Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$185,574** · cum ~$11,200 · **avail ~$175.6k** |
| miner | τ10.000 free · 0 submissions |
| H88 | n80 a203 ~71/80 · mid304 · t/k/c=200 |
| H90 | n80 a203 live · mid304 rearmed · t/k/c=200 |
| H91 | chall loading · king+teacher=200 · preempt armed |
| H92 | train r13 live (0/26) · stamp OK |
| H93 | bootstrap COUNT=8 @$31.92 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h88-1 | zesty-hawk-be | 38.255.28.19:20100 | ~03:32Z+1d | n80+mid304 |
| mine-h90-1 | noble-shark-3c | 152.236.142.232:40310 | ~04:23Z+1d | n80+mid304 |
| mine-h91-1 | brave-shark-d2 | 38.255.28.18:20099 | ~04:31Z+1d | chall load |
| mine-h92-1 | calm-lion-f6 | 152.236.142.236:40300 | ~05:12Z+1d | train r13 |
| mine-h93-1 | eager-raven-1e | 38.255.28.22:20099 | ~05:21Z+1d | bootstrap r15 |

known_hosts `/tmp/mine-h{88,90,91,92,93}-1.known_hosts`. **Free: 0.** ~$152/h.
Non-mine `wan-lora-*` / `affine-*` — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: plmk/α/TP×ks/m7×ks/union/lr micro/ep≥2/r≤8∨=16–24∨≥32/α≤8∨=16∨≥64/clip≥0.08/king-self.
**m7×r17/r18 + Tok-init r17/r18/r22/r23/r25–r29/r31 closed.** Open: H88/H90–H93.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
Never `pkill -f`; match `$0` via `/proc/*/cmdline` (not SSH argv).
recover264=chall; king-only relaunch. Never sed live post_train.
mid304 for mid-n80 bare; preempt exits on isolated TCACHE.
Tok-init: `preprocessor_config` + real visual shard (index≠disk).
King Triton ENOENT → isolated TCACHE; OOM@util=0.80 → **0.72**.
H91: chall→preempt settle; arm mid304 when n80 starts.
H90: keep mid304; await `h90_decision.json`.

## Next action

1. **H88/H90** await n80 → `h*_decision.json` (keep mid304).
2. **H91** await :8002=200 → preempt settle → n80+mid304.
3. **H92** await train→merge→n80.
4. **H93** await `h93_train_launched.stamp`.
