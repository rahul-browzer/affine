# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H86–H90 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
Best vs Tok: **H81 r22 m=+0.008811** (REFUTE; first Tok-init +).
**Live king:** Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$185,856** · cum ~$10,740 · **avail ~$175.9k** |
| miner | τ10.000 free · 0 submissions |
| H86 | **n80** a203 **~69/80** · mid304 |
| H87 | chall loading · teacher+king=200 · preempt |
| H88 | chall loading · teacher+king=200 · post_train |
| H89 | chall :8002=200 · tchr+king recover332 loading |
| H90 | **bootstrap** (Tok-init r14) · COUNT=8 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h86-1 | calm-wolf-21 | 152.236.142.236:40300 | ~02:59Z+1d | n80 ~69/80 |
| mine-h87-1 | swift-shark-4f | 38.255.28.22:20100 | ~03:31Z+1d | chall bare→preempt |
| mine-h88-1 | zesty-hawk-be | 38.255.28.19:20100 | ~03:32Z+1d | chall bare loading |
| mine-h89-1 | gentle-fox-06 | 152.236.142.237:40309 | ~03:38Z+1d | tchr+king recover332 |
| mine-h90-1 | noble-shark-3c | 152.236.142.232:40310 | ~04:23Z+1d | bootstrap r14 |

known_hosts `/tmp/mine-h{86,87,88,89,90}-1.known_hosts`. **Free: 0.** ~$148/h.
Non-mine `wan-lora-*` / `affine-*` — **do not touch**.
**p333:** rented mine-h90-1 @$28/h ttl12h; H90 Tok-init r=14 launched.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: plmk/α/TP×ks/m7×ks/union/lr micro/ep≥2/r≤8∨=16–24∨≥32/α≤8∨=16∨≥64/clip≥0.08/king-self.
**m7×r17/r18 + Tok-init r17/r18/r22/r23/r25/r26/r27 closed.** Open: H86–H90.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
Never `pkill -f`; match `$0` via `/proc/*/cmdline` (not SSH argv).
recover264=chall; king-only relaunch. Never sed live post_train.
mid304 for mid-n80 bare; preempt exits on isolated TCACHE.
Tok-init: `preprocessor_config` + real visual shard (index≠disk).
King Triton ENOENT → isolated TCACHE; OOM@util=0.80 → **0.72**.
recover264 rearms form+n80 **not** mid304 — arm mid304 when n80 starts.
Do **not** probe completions during recover settle (CUDA illegal-access).
mid304 detect: `$0` arg1=`…/watch_mid_n80…sh` only — SSH `-c` text is false positive.

## Next action

1. **H86 n80 → `decision.json`**; tear if REFUTE; refill free slot (data variant or replicate shortlist).
2. H89 :8000+:8001 promptable → n80 → arm mid304.
3. H87/H88 :8002=200 bare → recover264 → n80+mid304.
4. H90 bootstrap → train → merge → n80.
