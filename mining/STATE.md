# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F36 **REFUTE**.
**F37–F45 live** (9 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$178,800** · cum ~$18,906 · **avail ~$168.8k** |
| miner / burn | τ10 free · 0 sub · **~$246.6/h** (9) ≪$833 · free **11** |
| F37/F38 | n80 **~69/80** / **n80 live** (a203) |
| F39–F42 | RL~135 / RL+king / RL / BoN~45 |
| F43–F45 | merge shards / teacher DL / **bootstrap** |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f37-1 | calm-eagle-91 | 152.236.142.241:40049 | ~19:06Z | F37 **n80 ~69/80** |
| mine-f38-1 | golden-eagle-8b | 152.236.142.235:40300 | ~19:51Z | F38 **n80 live** |
| mine-f39-1 | cosmic-matrix-95 | 3.135.191.208:20127 | ~20:06Z | F39 RL ~135/200 |
| mine-f40-1 | zesty-wolf-91 | 152.236.142.232:40300 | ~20:12Z | F40 RL + king |
| mine-f41-1 | cosmic-fox-2d | 152.236.142.234:40300 | ~20:19Z | F41 RL retrain |
| mine-f42-1 | noble-raven-de | 152.236.142.236:40300 | ~20:25Z | F42 BoN ~45/150 |
| mine-f43-1 | zesty-matrix-8e | 38.255.28.22:20099 | ~20:34Z | F43 **merge→n80** |
| mine-f44-1 | swift-matrix-65 | 152.236.142.237:40300 | ~21:28Z | F44 teacher DL |
| mine-f45-1 | lunar-matrix-d4 | 38.255.28.21:20099 | ~21:35Z | F45 **bootstrap** |

kh: `/tmp/mine-fNN.kh` (f44/f45: `*-1.known_hosts`). Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F36**/king-init LoRA.
Open: H132–H139 + **H140/F45 last-N full-rank RL**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8; `--chall-repo`=/v1/models id.
**p506:** `dd87f25e` COUNT=3 blacklisted.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F37/F38**: await n80 → decision; m>+0.015 → CONFIRM k=4; else REFUTE/tear.
2. **F43**: merge→chall→n80; **F44/F45**: bootstrap→teacher→train.
3. **F39–F42**: train→merge→n80.
4. Free slots → orthogonal (not LoRA-RL/BoN/DPO/F45-cell/past-king FT/raw).
