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
| Lium / spend | **~$186,768** · cum ~$9,534 · **avail ~$176.8k** |
| miner | τ10.000 free · 0 submissions |
| H76 | **n80 LIVE** a203 ~45/80 + mid304 |
| H77 | **n80 LIVE** a203 (king308 PROMPTABLE @13:02Z) + mid304 |
| H78 | **n80 LIVE** a203 ~55/80 + mid304 |
| H79 | recover264 a1 loading post **visual restore** (36 GiB/GPU) |
| H80 | recover264 a1 loading post **visual restore** (36 GiB/GPU) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h76-1 | gentle-raven-df | 38.255.28.18:20100 | ~23:38Z | n80 a203 + mid304 |
| mine-h77-1 | eager-shark-64 | 152.236.142.237:40306 | ~23:44Z | n80 a203 + mid304 |
| mine-h78-1 | eager-comet-a4 | 38.255.28.22:20100 | ~23:44Z | n80 a203 + mid304 |
| mine-h79-1 | lunar-shark-be | 152.236.142.232:40100 | ~00:18Z+1d | recover→n80 |
| mine-h80-1 | eager-shark-18 | 152.236.142.236:40311 | ~00:26Z+1d | recover→n80 |

known_hosts `/tmp/mine-h{76,77,78,79,80}-1.known_hosts`. **Free: 0.** ~$148/h.
Non-mine `wan-lora-train` / `affine-*` — **do not touch**.
**p310:** Tok-init phantom visual index — CausalLM left 333 visual keys in
index pointing at language shards with 0 tensors. Restored
`model-visual-restored.safetensors` (852 MiB) on H79+H80; patched
`merge_lora.py` to refuse phantom. `…/pass310_visual_phantom_fix.md`.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: plmk/α/TP×ks/m7×ks/union/lr micro-steps/ep≥2/r≤8∨=16∨=19∨=20∨=24∨≥32/α≤8∨=16∨≥64/clip≥0.08/king-self.
**m7×r18 closed** (H72/H74/H75; H76 last). Open: r17/r21/Tok-init.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
Never `pkill -f`; match `$0` via `/proc/*/cmdline` (not watcher argv).
recover264=chall; king-only relaunch. Never sed live post_train.
mid304 for mid-n80 bare; one-shot preempt exits on isolated TCACHE.
Tok-init: need `preprocessor_config` **and** real visual shard (index≠disk).
Preempt 240×10s: rearm by PID before TIMEOUT if chall still loading.

## Next action

1. H79/H80: await recover264 health+promptable → n80 a203 (rearm retry if missing).
2. H76/H77/H78: await n80 → `decision.json` (FAIL×3=quarantine≠REFUTE).
3. Free slot → non-α; **no m7×r18**; Tok-init / data / r∉{18,16,19,20}.
