# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F2/F3 **REFUTE**.
**F1+F4+F6+F7+F8+F9 live**. No submit. Best vs Tok: H81 +0.0088.
King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$184,073** · cum ~$13,250 · **avail ~$174.1k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$213/h** (6 mine-*) ≪ $833/h · free slots **14** |
| F1 | chall :8002=200 + completions200; recover264 diverse warm→freeze→n80 |
| F4 | merge DONE; Tok Range-resume shard2 ~52%/35G; teacher loading |
| F6 | bare chall ENOENT → recover264 a1 fired; n80 watcher rearmed |
| F7 | recover264 a1 (post_train reaped); n80 watcher rearmed |
| F8 | RL train live |
| F9 | kevin DL ~37 GiB |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f1-1 | brave-hawk-5a | 86.38.238.54:40099 | ~07:05Z+1d | F1 recover warm→n80 |
| mine-f4-1 | calm-wolf-30 | 204.9.206.243:40099 | ~07:18Z+1d | F4 Tok Range→serve |
| mine-f6-1 | noble-shark-14 | 152.236.142.237:40300 | ~08:42Z+1d | F6 recover264→n80 |
| mine-f7-1 | lunar-shark-87 | 152.236.142.232:40311 | ~08:52Z+1d | F7 recover264→n80 |
| mine-f8-1 | brave-matrix-d8 | 152.236.142.236:40309 | ~09:04Z+1d | H103 RL train |
| mine-f9-1 | lunar-fox-0a | 38.255.28.18:20099 | ~09:12Z+1d | H104 kevin DL |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP×ks/m7×ks/union/lr/ep≥2/winner-zA/−0.004/Tok r9–31/**F2**/**F3**/king-init refs.
Open: H98/F1, H100/F4, H101/F6, H102/F7, H103/F8, H104/F9.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28; never `pkill -f`.
recover264=chall; king-only relaunch; seed chall from live king TCACHE.
**F4:** hub≥1.27 never resumes incompletes — Range script only; await
`tok331102.done` then king+chall re-serve (serve_three child died when king killed).
**F6/F7:** recover a1 live; n80 watchers rearmed p383.
**F1:** warmups live — await freeze+DONE → n80; do not second-launch recover.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F1** await recover264 freeze+DONE → confirm n80 vs Tok started.
2. **F6/F7** await recover264 → n80 (watchers armed).
3. **F4** await `tok331102.done` (Range) → king util=0.72 + chall → n80.
4. **F8** RL→merge→n80; **F9** kevin DL→train→merge→n80.
