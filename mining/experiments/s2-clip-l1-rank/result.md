# s2-clip-l1-rank — result (pass 164)

**Verdict:** Queue was mis-ordered by parent margin. H25’s m7 parent is the
best TP-era clip-L1 B we have; plmk must not be requeued (H16 already);
kkk (H26) is mid-pack on clip-L1 and pre-TP.

## Top TP-era by challenger clip-L1 (chal≥284)

| cid | c_clipL1 | d_clipL1 | margin | base× | status | repo |
|---|---|---|---|---|---|---|
| 00331 | **+0.0435** | **+0.0145** | +0.018 | 1.242 | **H25 live** | adambell/…ckpt1000-m7 |
| 00310 | +0.0389 | +0.0052 | +0.014 | 1.000 | **H16 REFUTE** m=+0.0097 | plmk (mirror bluecolor777) |
| 00325 | +0.0326 | +0.0052 | +0.011 | 1.009 | H21 live | sft2 |
| 00284 | +0.0325 | +0.0157 | +0.028 | 0.895 | king | TalentPigs |
| 00262 | +0.0288 | +0.0122 | +0.024 | 0.918 | H26 staged; **pre-TP** | kkk |
| 00337 | +0.0199 | +0.0045 | +0.012 | 0.996 | low clipL1 | leary-tt |
| 00333 | +0.0186 | +0.0024 | +0.008 | 1.137 | low clipL1 | hk9 |

## Actions taken

1. **Keep H25** — highest c_clipL1 of field; n80 running.
2. **Demote plmk** from next-slot queue — same α0.90 recipe already
   REFUTED as H16 (m=+0.00970, base×1.146).
3. **Demote hk9 / leary-tt** — TP-era clip-L1 below king’s band; lottery only.
4. **H26 kkk** stays as staged lottery (pre-TP margin +0.024) but is not a
   mean-shift bet; after H25, prefer a clip-L1-shaping recipe over more α0.90.

Artifacts: `table.txt`, `rank.json`, `raw/*.json.gz` (7.2M).
