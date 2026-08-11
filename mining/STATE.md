# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4** — Reason v3 crown push (operator 2026-08-10).
King-watch **revoked**. `weight_version_key=3`. Score = mean Reason (Λ2 only).

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · `weight_version_key=3` · crown = margin > 3·SE |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` (reign 4) |
| corpus | epoch **7** · schema v2 |
| Lium | ~$123,545 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| board | live duel **chal-00432** (BKN seven, scoring); queue 441→431→450→451→452→455→456 |
| disk | ~295 GiB free on `/root` (84%) |
| R2d/e/f/h | 0.22× / REFUTE / SKIP / REFUTE −0.59× |
| **R2g** | Talent×saysth **REFUTE** hr **−0.89×** (n=79) |
| 440 saysth | hr **0.73×** (parent only; merge lost) |
| R2i…R2p | wait 441/432/431/450/456/451/452/455 Reason+ (GPU serial) |
| **R2q** | pure saysth **ARMED** · after R2i…R2p · pid **157147** |
| prefetch | BKN6+sft3+asdf+zeus+sth+cp200 DONE |
| gated+ | diane-new 0.54× / nvidia 0.45× / aurora 0.17× — still weight-gated |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · R2i…R2p + **R2q/saysth** |

- Engines 8000/8001/8002 healthy (chall still `/tmp/r2g_alpha_merged` idle).
- R2q log: `/root/logs/r2q_saysth_reload.log` → decision `r2q_saysth_decision.json`.
- 455 watch: `tail /root/logs/watch_chal00455_reason.log` → `chal00455_reason.json`.

## Blocked

- No submit on R1*/R2d/e/g/h (below bar). No S\* 0.04 gate / king-watch.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- Lane-free = **pidfile kill -0** only. Recompute Reason from lpC fields.
- No merge thomp/BKN/sft3/cp200/asdf/zeus/sth until Reason+. No re-n80 R2e/R2g/R2h.
- nvidia/diane-new/aurora weight-gated. All queued parents cached; R2q waits chain end.

## Next action

**Let R2i…R2p fire** on Reason+; harvest first hr ≥ **1.5×** → submit. Else let **R2q** pure-saysth n80 run after chain terminals. Scan intake for new DL Reason+ parent.
