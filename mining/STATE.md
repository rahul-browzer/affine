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
| Lium | ~$123,523 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| board | live duel **chal-00441** (thompsville cgpb8, load_challenger) |
| queue | 431→450→451→452→455→456→**458 whoami** |
| disk | ~295 GiB free on `/root` (84%) |
| R2d/e/f/h | 0.22× / REFUTE / SKIP / REFUTE −0.59× |
| **R2g** | Talent×saysth **REFUTE** hr **−0.89×** (n=79) |
| 440 saysth | hr **0.73×** (parent only; merge lost) |
| **R2j** | BKN-seven **SKIP** hr **−0.57×** (no Talent×BKN7) |
| R2i/k…p | wait 441/431/450/456/451/452/455 Reason+ |
| **R2q** | pure saysth **ARMED** · after R2i…R2p · pid **157147** |
| **R2r-prep** | **whoami** prefetch+watch **458** armed (pids **159761**/**159877**) |
| prefetch | BKN6+sft3+asdf+zeus+sth+cp200 DONE; **whoami INFLT** |
| gated+ | diane-new 0.54× / nvidia 0.45× / aurora 0.17× — still weight-gated |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · R2i/k…p + R2q + **whoami/458** |

- Engines 8000/8001/8002 healthy (chall still `/tmp/r2g_alpha_merged` idle).
- R2j terminal: `r2j_premerge.skip` + `r2j_merge_reload.done` (pids dead).
- R2q log: `/root/logs/r2q_saysth_reload.log` → decision `r2q_saysth_decision.json`.
- 441 watch: `tail /root/logs/watch_chal00441_reason.log` → `chal00441_reason.json`.
- whoami: `tail /root/logs/r2_prefetch_whoami.log` · watch `watch_chal00458_reason.log`.

## Blocked

- No submit on R1*/R2d/e/g/h/j (below bar / Reason−). No S\* 0.04 gate / king-watch.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- Lane-free = **pidfile kill -0** only. Recompute Reason from lpC fields.
- No merge thomp/BKN6/sft3/cp200/asdf/zeus/sth/whoami until Reason+. No re-n80 R2e/R2g/R2h/R2j.
- nvidia/diane-new/aurora weight-gated. R2q waits remaining chain terminals.
- No R2r GPU merge until 458 hr>0 **and** R2q terminal (do not steal chall).

## Next action

**Harvest chal-00441** when gzip lands; if hr>0 let **R2i** Talent×thomp fire→n80. Else keep R2k…R2p Reason+ gates; first hr≥**1.5×** → submit. Else **R2q** pure-saysth after chain ends. If **458** Reason+ → arm **R2r** Talent×whoami after R2q.
