# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F18**/F19–**F21**/F24/**F17**/**F25**/**F23** **REFUTE**.
**F22,F26–F35 live** (11 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$180,218** · cum ~$17,477 · **avail ~$170.2k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$359.0/h** (11 mine-*) ≪ $833/h · free slots **9** |
| n80 | F27 king478 loading weights; F28 king435 loading; F26 teacher479 loading |
| other | F29 k=200; F32 train; F22/F33–F35 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 t+k up; tok→chall→n80 |
| mine-f26-1 | gentle-fox-2c | 152.236.142.235:40300 | ~16:12Z | F26 k+c=200; **teacher479 load** |
| mine-f27-1 | eager-orbit-15 | 152.236.142.237:40299 | ~16:16Z | F27 **king478** weight load |
| mine-f28-1 | eager-eagle-b1 | 152.236.142.232:40300 | ~16:20Z | F28 **king435** load |
| mine-f29-1 | gentle-shark-9c | 152.236.142.234:40300 | ~16:26Z | F29 king only |
| mine-f30-1 | lunar-wolf-aa | 152.236.142.236:40300 | ~16:31Z | F30 engines? |
| mine-f31-1 | golden-hawk-bb | 38.255.28.21:20099 | ~16:39Z | F31 engines? |
| mine-f32-1 | noble-wolf-e8 | 38.255.28.22:20099 | ~16:49Z | F32 train_full live |
| mine-f33-1 | golden-matrix-f1 | 3.135.191.208:20127 | ~17:07Z | F33 full-FT train |
| mine-f34-1 | brave-eagle-b1 | 38.255.28.18:20099 | ~17:10Z | F34 full-FT train |
| mine-f35-1 | zesty-matrix-04 | 150.136.71.147:20294 | ~17:19Z | F35 full-FT train |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F18**/F19–**F21**/F24/**F17**/**F25**/**F23**/king-init LoRA.
Open: H117/F22 + H121–**H130**/F26–**F35**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate (API lies).
`--chall-repo` = `/v1/models` id (not blind realpath). King cold ENOENT → seed chall n_so≥16.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F26**: poll teacher479 → :8000=200 + PROMPTABLE → n80 (k+c already 200; watcher→full-ft).
2. **F27**: poll king478 → KING PROMPTABLE → n80 d203 (`/tmp/h122_merged`).
3. **F28**: poll king435 → PROMPTABLE → n80 (`/root/h123/merged`).
4. F29 teacher+chall; F30/F31 engines→n80; F32 save→post_train; F22/F33–F35.
5. Free slot → af-k1 dense-FT (only if a pod tears).
