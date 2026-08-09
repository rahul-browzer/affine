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
| Lium / spend | **~$180,344** · cum ~$17,351 · **avail ~$170.3k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$359.0/h** (11 mine-*) ≪ $833/h · free slots **9** |
| n80 | **F28 @1/80** (d203); F26/F27 engines→n80 |
| other | F29/F30 merge.done→serve; F31 finalize /tmp; F32 saving; F33–F35 train (tf32 fixed) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 Tok Range ~92% → serve→n80 |
| mine-f26-1 | gentle-fox-2c | 152.236.142.235:40300 | ~16:12Z | F26 engines loading → n80 |
| mine-f27-1 | eager-orbit-15 | 152.236.142.237:40299 | ~16:16Z | F27 serve_three → n80 |
| mine-f28-1 | eager-eagle-b1 | 152.236.142.232:40300 | ~16:20Z | F28 **n80 1/80** |
| mine-f29-1 | gentle-shark-9c | 152.236.142.234:40300 | ~16:26Z | F29 serve (finalize /tmp OK) |
| mine-f30-1 | lunar-wolf-aa | 152.236.142.236:40300 | ~16:31Z | F30 serve (finalize /tmp OK) |
| mine-f31-1 | golden-hawk-bb | 38.255.28.21:20099 | ~16:39Z | F31 finalize ckpt-60 → /tmp |
| mine-f32-1 | noble-wolf-e8 | 38.255.28.22:20099 | ~16:49Z | F32 saving → post_train /tmp |
| mine-f33-1 | golden-matrix-f1 | 3.135.191.208:20127 | ~17:07Z | F33 full-FT train (p474 relaunch) |
| mine-f34-1 | brave-eagle-b1 | 38.255.28.18:20099 | ~17:10Z | F34 full-FT train (p474 relaunch) |
| mine-f35-1 | zesty-matrix-04 | 150.136.71.147:20294 | ~17:19Z | F35 full-FT train (p474 relaunch) |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F18**/F19–**F21**/F24/**F17**/**F25**/**F23**/king-init LoRA.
Open: H117/F22 + H121–**H130**/F26–**F35**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate (API lies).
p472–p474: never copytree/finalize onto gocryptfs `/root`; **/tmp only** + symlink. Pod `post_train` must have `MERGED=/tmp/hN_merged` (local fixed; scp before arm).

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F28**: poll n80 → margin in `h123_decision.json` (screen gate ±0.015).
2. F26/F27: engines promptable → n80 start; read margins.
3. F29/F30: engines→n80; F31 finalize→serve→n80.
4. F32 save.done→post_train (/tmp MERGED already on pod); F22 Tok Range→serve→n80.
5. F33–F35 train→finalize /tmp. Free slot → af-k1 dense-FT.
