# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H69–H73 live (5/5).** No submit.
Best n80 (vs old TalentPigs): **H64 r18 m=+0.02509**.
**Live king:** Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$187,453** · cum ~$8,470 · **avail ~$177.5k** |
| miner | τ10.000 free · 0 submissions |
| H70 | **n80 attempt 2/3 vs Tok** (b203) — started 10:25:50Z |
| H69 | n80 ~53/80 vs TalentPigs (ranking only) |
| H71 | merge writing shards → chall serve → n80 vs Tok |
| H72 | bootstrap m7 download |
| H73 | bootstrap m7 download |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h69-1 | noble-eagle-06 | 38.255.28.22:20100 | ~21:08Z | n80 ~53/80 old king |
| mine-h70-1 | cosmic-raven-9e | 38.255.28.18:20100 | ~21:42Z | **n80 vs Tok** |
| mine-h71-1 | eager-fox-be | 152.236.142.237:40311 | ~22:05Z | merge→serve→n80 Tok |
| mine-h72-1 | golden-comet-7a | 152.236.142.232:40299 | ~22:20Z | bootstrap m7 dl |
| mine-h73-1 | eager-matrix-9a | 38.255.28.19:20100 | ~22:21Z | bootstrap m7 dl |

known_hosts `/tmp/mine-h{69,70,71,72,73}-1.known_hosts`.
**Free slots: 0.** Burn ~$152/h mining.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**. H69 vs TalentPigs =
ranking-only. Dead: plmk / α-merges / TP×ks / m7×ks/union /
**lr≤2.5e-6∨=4e-6∨=4.95∨=5.02∨=5.05∨=5.08∨=5.1∨=5.15∨=5.25∨=5.3∨=5.5∨=5.75∨=6∨=7.5∨=8∨≥3e-5** /
ep≥2 / r≤8∨=**18**∨=**20**∨=24∨≥32 / α≤8∨=16∨≥64 / clip≥0.08 / **H42@5e-6**.
**r=18/r=19 not blacklisted for research** — H72/H73 are replicates vs Tok.
Never tear down on ConnectError/unpromptable — quarantine + recover.
`FALSE_PROBE_*` ≠ REFUTE; never `lium rm` on non-mine.
Reject COUNT≠8 or $/h<$20. Prefer UUID ≥$28/h.
**Never `pkill -f` from SSH**; kill retry by exact PID only.
If recover264 owns chall, **king-only relaunch**.
**Never sed-patch a running post_train** (H70 p282 rc=127).
**Preempt: never relaunch on isolated TCACHE / if recover alive** (p283).
Late merge→serve: rearm preempt if poll ≳200/240.

## Next action

1. H70: await n80 decision vs Tok → tear / shortlist / submit-gate.
2. H69 (~53/80): decision vs TalentPigs — tear if m≤0.04; else re-sim vs Tok.
3. H71: finish merge → chall serve → n80 vs Tok.
4. H72/H73: train → merge → n80 vs Tok.
5. Free slot → non-α neighbor **KING=Tok331102 from rent** (prefer
   replicate best shortlist cell, not 1% lr step).
