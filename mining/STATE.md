# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F37 **REFUTE**.
**F38–F47 live** (10 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$178,576** · cum ~$19,094 · **avail ~$168.6k** |
| miner / burn | τ10 free · 0 sub · **~$278.6/h** (10) ≪$833 · free **10** |
| F38/F43 | n80 @32/80 · @53/80 |
| F40 | **n80 live** b203 post salvage (p521) |
| F39/F41 | merge |
| F42/F44/F45 | BoN / online-DPO / lastN RL train |
| F46/F47 | Genesis lastN · raw Coder boot |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f38-1 | golden-eagle-8b | 152.236.142.235:40300 | ~19:51Z | F38 n80 @32/80 |
| mine-f39-1 | cosmic-matrix-95 | 3.135.191.208:20127 | ~20:06Z | F39 merge |
| mine-f40-1 | zesty-wolf-91 | 152.236.142.232:40300 | ~20:12Z | F40 n80 b203 live |
| mine-f41-1 | cosmic-fox-2d | 152.236.142.234:40300 | ~20:19Z | F41 merge |
| mine-f42-1 | noble-raven-de | 152.236.142.236:40300 | ~20:25Z | F42 BoN train |
| mine-f43-1 | zesty-matrix-8e | 38.255.28.22:20099 | ~20:34Z | F43 n80 @53/80 |
| mine-f44-1 | swift-matrix-65 | 152.236.142.237:40300 | ~21:28Z | F44 online-DPO |
| mine-f45-1 | lunar-matrix-d4 | 38.255.28.21:20099 | ~21:35Z | F45 lastN RL |
| mine-f46-1 | swift-comet-18 | 152.236.142.241:40061 | ~22:02Z | F46 bootstrap |
| mine-f47-1 | golden-matrix-bb | 38.255.28.18:20099 | ~22:07Z | F47 coder boot |

kh: `/tmp/mine-fNN.kh`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F37**/king-init LoRA.
Open: H133–H142. F5 needs traj. FALSE_PROBE≠REFUTE; COUNT>=8.
**p506:** `dd87f25e` COUNT=3 blacklisted.
**p521:** F40 salvage recover → n80 b203; a203 teacher-400 rotated.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Operator directive 2026-08-09T10:30Z — FAMILY SEARCH IS SPENT

My "+0.16 genesis / leave the basin" premise was **wrong** (see LESSONS): raw
genesis loses by −0.055 with gates clear. All 45 families refuted by one
mechanism — leaving king-init collapses Λ2. Family breadth has answered the
question; buying more of it buys more −0.05s.

1. **Let F38–F47 finish, then do not replace them.** Do not rent a new pod for
   any closed class (non-king base, full-FT, high rank, RL, raise-Λ2, raw
   models). A new family must name the refutation it escapes, in writing, first.
2. **Drift burn down** as pods resolve; do not backfill to hold 10 pods.
   Target ≤ $120/h until the operator rules on strategy. Money is not the
   constraint — there is no idea worth spending it on this hour.
3. **Watch the crown, it is the highest-value variable we have.** Our same cells
   scored +0.025 vs TalentPigs (S=0.0315) and ≈0 vs Tok (S=0.04456). Record the
   live king's S every pass. **If a king weaker than S≈0.035 takes over,
   immediately re-screen the best Tok-init winner-zA cell (H64 r=18) against it**
   — that is a better shot than anything in the current queue.
4. Keep the best Tok-init artifact warm and reproducible so step 3 is one pass,
   not a rebuild.

## Next action

1. **F43 / F38 / F40**: n80→decision; m>+0.015 → CONFIRM k=4; else REFUTE/tear.
2. **F39/F41**: merge→serve→n80.
3. **F47/F46**: await DL+serve → n80 screens.
4. **F42/F44/F45**: train→merge→n80.
5. Free slots → orthogonal (not LoRA-RL-Λ2 / BoN / DPO / lastN / past-king FT/raw-Albedo).
