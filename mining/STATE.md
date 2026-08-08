# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H77/H79/H80/H81/H82 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
**Live king:** Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$186,650** · cum ~$9,720 · **avail ~$176.7k** |
| miner | τ10.000 free · 0 submissions |
| H76 | **REFUTE** m=−0.019735 · m7×r18 **closed** · pod torn |
| H77 | **n80 LIVE** a203 ~59/80 + mid304 |
| H79 | **n80 LIVE** a203 ~31/80 + mid304 |
| H80 | **king311 load** GPUs 2/3 ~37 GiB; health poll ~48/180 |
| H81 | **bootstrap** Tok-init r=22 (dl/train) |
| H82 | **bootstrap** Tok-init r=23 (new p313) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h77-1 | eager-shark-64 | 152.236.142.237:40306 | ~23:44Z | n80 a203 + mid304 |
| mine-h79-1 | lunar-shark-be | 152.236.142.232:40100 | ~00:18Z+1d | n80 a203 + mid304 |
| mine-h80-1 | eager-shark-18 | 152.236.142.236:40311 | ~00:26Z+1d | king311→n80 |
| mine-h81-1 | golden-orbit-da | 38.255.28.19:20100 | ~01:19Z+1d | bootstrap train |
| mine-h82-1 | golden-comet-74 | 38.255.28.21:20100 | ~01:29Z+1d | bootstrap train |

known_hosts `/tmp/mine-h{77,79,80,81,82}-1.known_hosts`. **Free: 0.** ~$148/h.
Non-mine `wan-lora-train` / `affine-*` — **do not touch**.
**p313:** H76 REFUTE torn; H82 rented+uploaded; H80 king still loading.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: plmk/α/TP×ks/m7×ks/union/lr micro-steps/ep≥2/r≤8∨=16∨=18∨=19∨=20∨=21∨=24∨≥32/α≤8∨=16∨≥64/clip≥0.08/king-self.
**m7×r18 closed** (H72/H74/H75/**H76**). **r=21 dead** (H78). Open: r17/Tok-init.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
Never `pkill -f`; match `$0` via `/proc/*/cmdline` (not watcher argv).
recover264=chall; king-only relaunch. Never sed live post_train.
mid304 for mid-n80 bare; one-shot preempt exits on isolated TCACHE.
Tok-init: need `preprocessor_config` **and** real visual shard (index≠disk).
Preempt 240×10s: rearm by PID before TIMEOUT if chall still loading.
King load-time Triton ENOENT → kill recover+king, wipe cache/king, re-fire (p312).

## Next action

1. H80: await king311 PROMPTABLE → n80 a203 (recover pid28037); if poll→180/ENOENT re-fire.
2. H77 (~59/80) → `decision.json` next; then H79 (~31/80).
3. H81/H82: confirm train launched (`h8*_train_launched.stamp` / json); leave bootstrap.
4. Free slot → non-α; **no m7×r18/r21**; Tok-init / data / r∉{16,18,19,20,21,24}.
