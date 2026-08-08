# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H80/H81/H82/H83/H84 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
**Live king:** Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$186,494** · cum ~$10,008 · **avail ~$176.5k** |
| miner | τ10.000 free · 0 submissions |
| H80 | **n80 LIVE** b203 **~32/80** · engines 200 · mid304 armed |
| H81 | **merge LIVE** shard1=47G + tmp~19G · preempt **rearmed** |
| H82 | **merge LIVE** tmp~47G · preempt **rearmed** @14:08Z |
| H83 | **train LIVE** r25 @14:05Z (tok_init DONE) |
| H84 | **train LIVE** r26 ~13/26 loss~0.44 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h80-1 | eager-shark-18 | 152.236.142.236:40311 | ~00:26Z+1d | n80 b203 ~32/80 |
| mine-h81-1 | golden-orbit-da | 38.255.28.19:20100 | ~01:19Z+1d | merge→chall |
| mine-h82-1 | golden-comet-74 | 38.255.28.21:20100 | ~01:29Z+1d | merge→chall |
| mine-h83-1 | cosmic-matrix-be | 38.255.28.18:20098 | ~01:44Z+1d | train r25 |
| mine-h84-1 | gentle-lion-26 | 152.236.142.237:40311 | ~01:56Z+1d | train r26 |

known_hosts `/tmp/mine-h{80,81,82,83,84}-1.known_hosts`. **Free: 0.** ~$152/h.
Non-mine `wan-lora-*` / `affine-*` — **do not touch**.
**p318:** H83 train LIVE; H81/H82 preempt rearmed; H80 ~32/80.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: plmk/α/TP×ks/m7×ks/union/lr micro-steps/ep≥2/r≤8∨=16∨=17∨=18∨=19∨=20∨=21∨=24∨≥32/α≤8∨=16∨≥64/clip≥0.08/king-self.
**m7×r17/r18 closed.** **Tok-init r18 closed (H79).** **r=21 dead** (H78).
Open: Tok-init H80–H84 (r17/22/23/25/26).
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
Never `pkill -f`; match `$0` via `/proc/*/cmdline` (not watcher argv).
recover264=chall; king-only relaunch. Never sed live post_train.
mid304 for mid-n80 bare; one-shot preempt exits on isolated TCACHE.
Tok-init: need `preprocessor_config` **and** real visual shard (index≠disk) — patched `merge_lora` derives both.
King load-time Triton ENOENT → isolated TCACHE; **first-n80 CUDA OOM at util=0.80 → util=0.72** (p315; king315 OK).
Preempt 240×10s≈40m — **rearm before TIMEOUT** when merge late (p318 H81/H82).

## Next action

1. H80 (~32/80) → `decision.json`; if exit3 OOM try util=0.68.
2. H81/H82 merge → chall serve → n80 (preempt armed); H83/H84 train → merge.
3. Free slot → Tok-init r∉{16–21,24,18} / data variant; **no m7×r17/r18; no Tok-init r18**.
