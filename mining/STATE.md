# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H79/H80/H81/H82/H83 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
**Live king:** Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$186,608** · cum ~$9,860 · **avail ~$176.6k** |
| miner | τ10.000 free · 0 submissions |
| H77 | **REFUTE** m=−0.021756 · **m7×r17 dead** · pod torn |
| H79 | **n80 LIVE** a203 ~62/80 + mid304 |
| H80 | **king315** util=0.72 isolated TCACHE (after p314 OOM) |
| H81 | **train LIVE** (BOOTSTRAP_DONE @13:40Z) |
| H82 | **bootstrap** Tok-init dl ~10/11 |
| H83 | **bootstrap** Tok-init r=25 (just rented) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h79-1 | lunar-shark-be | 152.236.142.232:40100 | ~00:18Z+1d | n80 a203 + mid304 |
| mine-h80-1 | eager-shark-18 | 152.236.142.236:40311 | ~00:26Z+1d | king315→n80 |
| mine-h81-1 | golden-orbit-da | 38.255.28.19:20100 | ~01:19Z+1d | train live |
| mine-h82-1 | golden-comet-74 | 38.255.28.21:20100 | ~01:29Z+1d | bootstrap dl |
| mine-h83-1 | cosmic-matrix-be | 38.255.28.18:20098 | ~01:44Z+1d | bootstrap r25 |

known_hosts `/tmp/mine-h{79,80,81,82,83}-1.known_hosts`. **Free: 0.** ~$152/h.
Non-mine `wan-lora-*` / `affine-*` — **do not touch**.
**p315:** H77 REFUTE+rm; H80 king util↓0.72 after OOM; H83 rented.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: plmk/α/TP×ks/m7×ks/union/lr micro-steps/ep≥2/r≤8∨=16∨=17∨=18∨=19∨=20∨=21∨=24∨≥32/α≤8∨=16∨≥64/clip≥0.08/king-self.
**m7×r17/r18 closed.** **r=21 dead** (H78). Open: Tok-init (H79–H83).
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
Never `pkill -f`; match `$0` via `/proc/*/cmdline` (not watcher argv).
recover264=chall; king-only relaunch. Never sed live post_train.
mid304 for mid-n80 bare; one-shot preempt exits on isolated TCACHE.
Tok-init: need `preprocessor_config` **and** real visual shard (index≠disk).
King load-time Triton ENOENT → isolated TCACHE; **first-n80 CUDA OOM at util=0.80 → util=0.72** (p315).

## Next action

1. H80: await `h80_king_recover_pass315.done` → n80 a203; if exit3 OOM try util=0.68.
2. H79 (~62/80) → `decision.json` next.
3. H81 train → merge/post_train; H82/H83 confirm `h8*_train_launched.stamp`.
4. Free slot → Tok-init / data / r∉{16,17,18,19,20,21,24}; **no m7×r17/r18**.
