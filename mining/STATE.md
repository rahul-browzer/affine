# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H81/H82/H83/H84/H85 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
**Live king:** Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$186,327** · cum ~$10,164 · **avail ~$176.3k** |
| miner | τ10.000 free · 0 submissions |
| H81 | **n80 LIVE** a203 **~44/80** · mid304 armed |
| H82 | **n80 LIVE** a203 just started · mid304 armed (p321) |
| H83 | merge LIVE shard2 writing · preempt **rearmed** p321 |
| H84 | recover264 settle→warmups · arm mid304 when n80 starts |
| H85 | **train LIVE** r27 · post_train armed |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h81-1 | golden-orbit-da | 38.255.28.19:20100 | ~01:19Z+1d | n80 a203 ~44/80 |
| mine-h82-1 | golden-comet-74 | 38.255.28.21:20100 | ~01:29Z+1d | n80 a203 + mid304 |
| mine-h83-1 | cosmic-matrix-be | 38.255.28.18:20098 | ~01:44Z+1d | merge→chall |
| mine-h84-1 | gentle-lion-26 | 152.236.142.237:40311 | ~01:56Z+1d | recover→n80 |
| mine-h85-1 | eager-fox-a3 | 152.236.142.232:40300 | ~02:34Z+1d | train→merge |

known_hosts `/tmp/mine-h{81,82,83,84,85}-1.known_hosts`. **Free: 0.** ~$152/h.
Non-mine `wan-lora-*` / `affine-*` — **do not touch**.
**p321:** H83 preempt rearm; H82 recover DONE→n80+mid304.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: plmk/α/TP×ks/m7×ks/union/lr micro-steps/ep≥2/r≤8∨=16∨=17∨=18∨=19∨=20∨=21∨=24∨≥32/α≤8∨=16∨≥64/clip≥0.08/king-self.
**m7×r17/r18 closed.** **Tok-init r17/r18 closed (H80/H79).** **r=21 dead** (H78).
Open: Tok-init H81–H85 (r22/23/25/26/27).
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
Never `pkill -f`; match `$0` via `/proc/*/cmdline` (not watcher argv).
recover264=chall; king-only relaunch. Never sed live post_train.
mid304 for mid-n80 bare; one-shot preempt exits on isolated TCACHE.
Tok-init: need `preprocessor_config` **and** real visual shard (index≠disk).
King load-time Triton ENOENT → isolated TCACHE; **first-n80 CUDA OOM at util=0.80 → util=0.72**.
Preempt 240×10s≈40m — **rearm before TIMEOUT** when merge/serve late.
recover264 rearms form+n80 **not** mid304 — arm mid304 when n80 starts.

## Next action

1. H81 (~44/80) / H82 (just started) → `decision.json`; OOM→king util=0.68/0.72.
2. H84 recover DONE → n80; **arm mid304** when sim starts (verify via `/proc` `$0`, not SSH argv).
3. H83 merge→chall (preempt rearmed); H85 train→merge→chall.
4. Free slot → Tok-init r∉{16–21,24,17,18} / data variant; **no m7×r17/r18; no Tok-init r17/r18**.
