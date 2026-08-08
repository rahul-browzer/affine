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
| Lium / spend | **~$186,861** · cum ~$9,415 · **avail ~$176.9k** |
| miner | τ10.000 free · 0 submissions |
| H76 | **n80 LIVE** a203 ~21/80 + mid304 |
| H77 | **king306 LOADING** → retry 0/120 + mid304 |
| H78 | **n80 LIVE** a203 ~29/80 + mid304 |
| H79 | merge+HF done; king ~113 GiB load; chall pending |
| H80 | **merge_lora** saving; teacher up |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h76-1 | gentle-raven-df | 38.255.28.18:20100 | ~23:38Z | n80 a203 + mid304 |
| mine-h77-1 | eager-shark-64 | 152.236.142.237:40306 | ~23:44Z | king306 → n80 |
| mine-h78-1 | eager-comet-a4 | 38.255.28.22:20100 | ~23:44Z | n80 a203 + mid304 |
| mine-h79-1 | lunar-shark-be | 152.236.142.232:40100 | ~00:18Z+1d | king→chall→n80 |
| mine-h80-1 | eager-shark-18 | 152.236.142.236:40311 | ~00:26Z+1d | merge→chall→n80 |

known_hosts `/tmp/mine-h{76,77,78,79,80}-1.known_hosts`. **Free: 0.** ~$148/h.
Non-mine `wan-lora-train` / `affine-*` — **do not touch**.
**p306:** H77 EngineDead (sample_tokens timeout @chall15) → king306 pid26103;
retry 0/120; chall untouched. mid304 rearmed.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: plmk/α/TP×ks/m7×ks/union/lr micro-steps/ep≥2/r≤8∨=16∨=19∨=20∨=24∨≥32/α≤8∨=16∨≥64/clip≥0.08/king-self.
**m7×r18 closed** (H72/H74/H75; H76 last). Open: r17/r21/Tok-init.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
Never `pkill -f`; match `$0` via `/proc/*/cmdline` (not watcher argv).
recover264=chall; king-only relaunch. Never sed live post_train.
mid304 for mid-n80 bare; one-shot preempt exits on isolated TCACHE.

## Next action

1. H77: await king306 PROMPTABLE → fresh a203 n80 + mid304.
2. H76/H78: await n80 → `decision.json` (FAIL×3=quarantine≠REFUTE).
3. H79/H80: await merged-chall promptable → n80 vs Tok.
4. Free slot → non-α; **no m7×r18**; Tok-init / data / r∉{18,16,19,20}.
