# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H87–H91 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
Best vs Tok: **H81 r22 m=+0.008811** (REFUTE; first Tok-init +).
**Live king:** Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$185,810** · cum ~$10,870 · **avail ~$175.8k** |
| miner | τ10.000 free · 0 submissions |
| H87 | n80 a203 ~8/80 · mid304 pid25109 · t/k/c=200 frozen |
| H88 | king311+recover264 live · teacher=200 · was bare chall |
| H89 | king=200 · teacher+chall loading (mem mid) |
| H90 | train_lora r14 + post_train |
| H91 | bootstrap DOWNLOAD tok-init |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h87-1 | swift-shark-4f | 38.255.28.22:20100 | ~03:31Z+1d | n80+mid304 |
| mine-h88-1 | zesty-hawk-be | 38.255.28.19:20100 | ~03:32Z+1d | king+chall recover |
| mine-h89-1 | gentle-fox-06 | 152.236.142.237:40309 | ~03:38Z+1d | tchr+chall load |
| mine-h90-1 | noble-shark-3c | 152.236.142.232:40310 | ~04:23Z+1d | train r14 |
| mine-h91-1 | brave-shark-d2 | 38.255.28.18:20099 | ~04:31Z+1d | DL tok-init |

known_hosts `/tmp/mine-h{87,88,89,90,91}-1.known_hosts`. **Free: 0.** ~$152/h.
Non-mine `wan-lora-*` / `affine-*` — **do not touch**.
**p335:** H87 mid304 armed; H88 king311+recover264 launched.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: plmk/α/TP×ks/m7×ks/union/lr micro/ep≥2/r≤8∨=16–24∨≥32/α≤8∨=16∨≥64/clip≥0.08/king-self.
**m7×r17/r18 + Tok-init r17/r18/r22/r23/r25/r26/r27/r28 closed.** Open: H87–H91.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
Never `pkill -f`; match `$0` via `/proc/*/cmdline` (not SSH argv).
recover264=chall; king-only relaunch. Never sed live post_train.
mid304 for mid-n80 bare; preempt exits on isolated TCACHE.
Tok-init: `preprocessor_config` + real visual shard (index≠disk).
King Triton ENOENT → isolated TCACHE; OOM@util=0.80 → **0.72**.
recover264 rearms form+n80 **not** mid304 — arm mid304 when n80 starts.
Do **not** probe completions during recover settle (CUDA illegal-access).
mid304 detect: `$0` arg1=`…/watch_mid_n80…sh` only — SSH `-c` text is false positive.
Orphan `VLLM::Worker` fds on 0–3: kill carefully (H89 p334 EngineDead).

## Next action

1. **H87** await n80 → `h87_decision.json` (mid304 stays).
2. H88 both recovers DONE → promptable → n80+mid304.
3. H89 teacher+chall 200 → n80+mid304.
4. H90/H91 train→merge→n80.
