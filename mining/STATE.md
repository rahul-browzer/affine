# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F18**/F19–**F21**/F24/**F17**/**F25**/**F23** **REFUTE**.
**F22,F26–F34 live** (10 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$180,601** · cum ~$17,138 · **avail ~$170.6k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$318.9/h** (10 mine-*) ≪ $833/h · free slots **10** |
| n80 | none mid-flight |
| other | F22 everest done; Tok king DL ~14G+incompletes; F26–F33 train; F34 pip |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 everest ready; Tok king DL → then serve+n80 |
| mine-f26-1 | gentle-fox-2c | 152.236.142.235:40300 | ~16:12Z | F26 **full-FT train** |
| mine-f27-1 | eager-orbit-15 | 152.236.142.237:40299 | ~16:16Z | F27 **full-FT train** |
| mine-f28-1 | eager-eagle-b1 | 152.236.142.232:40300 | ~16:20Z | F28 **full-FT train** |
| mine-f29-1 | gentle-shark-9c | 152.236.142.234:40300 | ~16:26Z | F29 **full-FT train** |
| mine-f30-1 | lunar-wolf-aa | 152.236.142.236:40300 | ~16:31Z | F30 **full-FT train** |
| mine-f31-1 | golden-hawk-bb | 38.255.28.21:20099 | ~16:39Z | F31 **full-FT train** |
| mine-f32-1 | noble-wolf-e8 | 38.255.28.22:20099 | ~16:49Z | F32 **full-FT train** |
| mine-f33-1 | golden-matrix-f1 | 3.135.191.208:20127 | ~17:07Z | F33 **full-FT train** |
| mine-f34-1 | brave-eagle-b1 | 38.255.28.18:20099 | ~17:10Z | F34 **diane-FT pip** |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F18**/F19–**F21**/F24/**F17**/**F25**/**F23**/king-init LoRA.
Open: H117/F22 + H121–**H129**/F26–**F34**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. Poll F26–F34 train.done → finalize+serve+n80.
2. F22: wait Tok king DL (bootstrap auto-serve); if incompletes freeze → Range-resume; then n80.
3. Hold CONFIRM until screen >+0.015. Free slot → everest/af-k1 dense-FT or F5 if traj.
