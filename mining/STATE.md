# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H82–H86 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
Best vs Tok: **H81 r22 m=+0.008811** (REFUTE; first Tok-init +).
**Live king:** Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$186,254** · cum ~$10,265 · **avail ~$176.3k** |
| miner | τ10.000 free · 0 submissions |
| H82 | **n80** a203 **~38/80** · mid304 |
| H83 | **n80** a203 **~9/80** · mid304 |
| H84 | **n80** b203 **~18/80** · mid304 |
| H85 | **chall serve** post-merge · :8002 loading |
| H86 | **bootstrap** r28 · just launched (p324) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h82-1 | golden-comet-74 | 38.255.28.21:20100 | ~01:29Z+1d | n80 ~38/80 |
| mine-h83-1 | cosmic-matrix-be | 38.255.28.18:20098 | ~01:44Z+1d | n80 ~9/80 |
| mine-h84-1 | gentle-lion-26 | 152.236.142.237:40311 | ~01:56Z+1d | n80 b203 ~18/80 |
| mine-h85-1 | eager-fox-a3 | 152.236.142.232:40300 | ~02:34Z+1d | chall→n80 |
| mine-h86-1 | calm-wolf-21 | 152.236.142.236:40300 | ~02:59Z+1d | bootstrap r28 |

known_hosts `/tmp/mine-h{82,83,84,85,86}-1.known_hosts`. **Free: 0.** ~$148/h.
Non-mine `wan-lora-*` / `affine-*` — **do not touch**.
**p324:** H81 REFUTE m=+0.008811 → rm; rent H86 r28.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: plmk/α/TP×ks/m7×ks/union/lr micro/ep≥2/r≤8∨=16–21∨=24∨≥32/α≤8∨=16∨≥64/clip≥0.08/king-self.
**m7×r17/r18 + Tok-init r17/r18/r22 + r=21 closed.** Open: H82–H86.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
Never `pkill -f`; match `$0` via `/proc/*/cmdline` (not SSH argv).
recover264=chall; king-only relaunch. Never sed live post_train.
mid304 for mid-n80 bare; preempt exits on isolated TCACHE.
Tok-init: `preprocessor_config` + real visual shard (index≠disk).
King Triton ENOENT → isolated TCACHE; OOM@util=0.80 → **0.72**.
recover264 rearms form+n80 **not** mid304 — arm mid304 when n80 starts.
H84 n80 uses **b203** (a203 aborted by king death).

## Next action

1. H82 (~38/80) → `decision.json`; then H83/H84.
2. H85 :8002=200 → n80 + arm mid304.
3. H86 bootstrap→train→merge→chall; arm mid304 when n80 starts.
4. Free slot → Tok-init r∉{16–22,24} / data variant; no m7×r17/r18.
