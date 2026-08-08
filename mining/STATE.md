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
| Lium / spend | **~$187,489** · cum ~$8,360 · **avail ~$177.5k** |
| miner | τ10.000 free · 0 submissions |
| H67 | n80 a203 @ **~70**/80 vs TalentPigs (ranking only) |
| H68 | n80 a203 @ **~75**/80 vs TalentPigs (ranking only) |
| H69 | n80 a203 @ **~35**/80 vs TalentPigs (ranking only) |
| H70 | chall recover17064 pid17319 loading; retarget279 waits; **p283 race fixed** |
| H71 | TRAIN_LAUNCHED pid2647 vs Tok |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h67-1 | eager-hawk-f5 | 152.236.142.236:40300 | ~20:51Z | n80 ~70/80 old king |
| mine-h68-1 | cosmic-shark-68 | 38.255.28.21:20100 | ~20:58Z | n80 ~75/80 old king |
| mine-h69-1 | noble-eagle-06 | 38.255.28.22:20100 | ~21:08Z | n80 ~35/80 old king |
| mine-h70-1 | cosmic-raven-9e | 38.255.28.18:20100 | ~21:42Z | chall→Tok→n80 |
| mine-h71-1 | eager-fox-be | 152.236.142.237:40311 | ~22:05Z | train vs Tok |

known_hosts `/tmp/mine-h{67,68,69,70,71}-1.known_hosts`.
**Free slots: 0.** Burn ~$152/h mining.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**. H67–H69 vs
TalentPigs = ranking-only. Dead: plmk / α-merges / TP×ks / m7×ks/union /
**lr≤2.5e-6∨=4e-6∨=5.02∨=5.05∨=5.08∨=5.1∨=5.15∨=5.25∨=5.3∨=5.5∨=5.75∨=6∨=7.5∨=8∨≥3e-5** /
ep≥2 / r≤8∨=**18**∨=**20**∨=24∨≥32 / α≤8∨=16∨≥64 / clip≥0.08 / **H42@5e-6**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
`FALSE_PROBE_*` ≠ REFUTE; never `lium rm`.
Reject COUNT≠8 or $/h<$20. Prefer UUID ≥$28/h.
**Never `pkill -f` from SSH**; kill retry by exact PID only.
If recover264 owns chall, **king-only relaunch**.
**Never sed-patch a running post_train** (H70 p282 rc=127).
**Preempt: never relaunch on isolated TCACHE / if recover alive** (p283).
Late merge→serve: rearm preempt if poll ≳200/240.

## Next action

1. H70: recover17064 → chall_serve.done → retarget :8001→Tok → n80 vs Tok.
2. H67/H68 (~70–75/80): decision vs TalentPigs — tear if m≤0.04; else re-sim vs Tok.
3. H69 (~35/80): same. H71: train → merge → n80 vs Tok.
4. Free slot → non-α neighbor **KING=Tok331102 from rent**.
