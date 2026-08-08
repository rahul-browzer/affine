# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H66–H70 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
**Live king CHANGED** → Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| prev king | TalentPigs @ dbfbb3e2 S≈0.0315 (crowned-over 09:49Z) |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$187,563** · cum mining ~$8,225 · **avail ~$177.6k** |
| miner | τ10.000 free · 0 submissions |
| H66 | n80 a203 @ **~71**/80 vs **TalentPigs** (ranking only) |
| H67 | n80 a203 @ **~40**/80 vs TalentPigs |
| H68 | n80 a203 @ **~35**/80 vs TalentPigs |
| H69 | n80 a203 @ **~2–7**/80 vs TalentPigs |
| H70 | train DONE → merge → **retarget279** → n80 vs **Tok331102** |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h66-1 | swift-eagle-f0 | 152.236.142.232:40300 | ~20:26Z | n80 vs old king ~71/80 |
| mine-h67-1 | eager-hawk-f5 | 152.236.142.236:40300 | ~20:51Z | n80 vs old king ~40/80 |
| mine-h68-1 | cosmic-shark-68 | 38.255.28.21:20100 | ~20:58Z | n80 vs old king ~35/80 |
| mine-h69-1 | noble-eagle-06 | 38.255.28.22:20100 | ~21:08Z | n80 vs old king early |
| mine-h70-1 | cosmic-raven-9e | 38.255.28.18:20100 | ~21:42Z | merge+retarget→Tok n80 |

known_hosts `/tmp/mine-h{66,67,68,69,70}-1.known_hosts`.
**Free slots: 0.** Burn ~$152/h mining.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**. H66–H69 margins
vs TalentPigs are not submit-valid. Dead: plmk / α-merges / TP×ks /
m7×ks/union / **lr≤2.5e-6∨=4e-6∨=5.02e-6∨=5.05e-6∨=5.1e-6∨=5.15e-6∨=5.25e-6∨=5.3e-6∨=5.5e-6∨=5.75e-6∨=6e-6∨=7.5e-6∨=8e-6∨≥3e-5** /
ep≥2 / r≤8∨=**18**∨=**20**∨=24∨≥32 / α≤8∨=16∨≥64 / clip≥0.08 / **H42@5e-6**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
Reject COUNT≠8 or $/h<$20. Prefer UUID ≥$28/h.
**Never `pkill -f` from SSH**; never kill by argv substring that matches
watchers (`watch_n80_retry … retry_hN` — kill retry PID only).
If recover264 owns chall, **king-only relaunch**.
**Late merge→serve:** rearm preempt if poll ≳200/240 before chall 200.

## Next action

1. H70: confirm `h70_king_retargeted_pass279.done` + n80 vs Tok; read `decision.json`.
2. H66→decision vs TalentPigs: REFUTE/teardown if m≤0.04; if m>0.04 queue **re-sim vs Tok**.
3. H67/H68/H69: same (TalentPigs ranking only).
4. Free slot → non-α neighbor **with KING=Tok331102 from rent**.
