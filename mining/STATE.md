# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H67–H71 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
**Live king:** Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| prev king | TalentPigs @ dbfbb3e2 S≈0.0315 (crowned-over 09:49Z) |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$187,526** · cum mining ~$8,280 · **avail ~$177.5k** |
| miner | τ10.000 free · 0 submissions |
| H66 | **REFUTE** m=+0.00976 z=1.72 base×1.187 (vs TalentPigs) · **torn down** |
| H67 | n80 a203 @ **~54**/80 vs TalentPigs (ranking only) |
| H68 | n80 a203 @ **~55**/80 vs TalentPigs (ranking only) |
| H69 | n80 a203 @ **~17**/80 vs TalentPigs (ranking only) |
| H70 | merge→Tok retarget DL (~57G) → n80 vs **Tok331102** |
| H71 | **NEW** r=16 vs Tok · bootstrap pip on mine-h71-1 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h67-1 | eager-hawk-f5 | 152.236.142.236:40300 | ~20:51Z | n80 vs old king ~54/80 |
| mine-h68-1 | cosmic-shark-68 | 38.255.28.21:20100 | ~20:58Z | n80 vs old king ~55/80 |
| mine-h69-1 | noble-eagle-06 | 38.255.28.22:20100 | ~21:08Z | n80 vs old king ~17/80 |
| mine-h70-1 | cosmic-raven-9e | 38.255.28.18:20100 | ~21:42Z | merge+Tok retarget→n80 |
| mine-h71-1 | eager-fox-be | 152.236.142.237:40311 | ~22:05Z | H71 r=16 vs Tok bootstrap |

known_hosts `/tmp/mine-h{67,68,69,70,71}-1.known_hosts`.
**Free slots: 0.** Burn ~$152/h mining.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**. H67–H69 margins
vs TalentPigs are ranking-only. Dead: plmk / α-merges / TP×ks /
m7×ks/union / **lr≤2.5e-6∨=4e-6∨=5.02e-6∨=5.05e-6∨=5.08e-6∨=5.1e-6∨=5.15e-6∨=5.25e-6∨=5.3e-6∨=5.5e-6∨=5.75e-6∨=6e-6∨=7.5e-6∨=8e-6∨≥3e-5** /
ep≥2 / r≤8∨=**18**∨=**20**∨=24∨≥32 / α≤8∨=16∨≥64 / clip≥0.08 / **H42@5e-6**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
Reject COUNT≠8 or $/h<$20. Prefer UUID ≥$28/h.
**Never `pkill -f` from SSH**; never kill by argv substring that matches
watchers (`watch_n80_retry … retry_hN` — kill retry PID only).
If recover264 owns chall, **king-only relaunch**.
**Late merge→serve:** rearm preempt if poll ≳200/240 before chall 200.

## Next action

1. H70: wait merge+retarget done → n80 vs Tok; read `decision.json`.
2. H67/H68/H69: on decision vs TalentPigs — REFUTE/teardown if m≤0.04;
   if m>0.04 queue **re-sim vs Tok** (or tear if far below).
3. H71: confirm train launched after bootstrap; keep preempt armed.
4. Free slot → non-α neighbor **with KING=Tok331102 from rent**.
