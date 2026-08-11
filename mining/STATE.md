# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4** — Reason v3 crown push (operator 2026-08-10).
King-watch **revoked**. `weight_version_key=3`. Score = mean Reason (Λ2 only).

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · `subnet.weight_version_key=3` · crown = margin > 3·SE |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` (reign 4) |
| corpus | epoch **7** · schema v2 · manifest ready |
| Lium balance | ~$123,657 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| board | duel phase · chal-00440 just finished (current_eval null @00:13Z) |
| R2d pure awesome-v6 | **DONE** · hr **0.22×** · `SIGNAL_POS_BELOW_3SE` |
| R2e Talent×awesome | **DONE** · hr **−1.18×** · **REFUTED** |
| R2f kevin×awesome | **SKIPPED** · Δ=0.00899 |
| R2h Tok×Talent×kevin | **DONE REFUTE** · margin **−0.0211** · z=−1.77 · hr **−0.59×** · n=60 |
| **chal-00440 saysth** | **DONE** · margin **+0.00916** · z=2.18 · hr **0.73×** · `POS_BELOW_3SE` · king_match |
| R2g Talent×saysth | **RUNNING** · gate ok · CPU merge α Talent0.25/saysth0.75 → reload→n80 |
| R2i Talent×thomp | premerge **138637** + reload **139014** (waits 441 Reason+) |
| BKN seven prefetch | **DONE** · watch **140530** → `chal00432_reason.json` |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | TK@65536 · R2g merge · R2i/441 · BKN/432 |

- Engines 8000/8001/8002 all **200**; chall still `/tmp/r2h_ttk_merged` until R2g reload.
- R2g: `merge_alpha.py` **140939** blending → `/root/r2_out/alpha_talent_saysth_v9a_skew`; waiter **130835** → reload+n80.
- Check R2g: `tail /root/logs/r2g_premerge.log`; then `r2g_alpha_decision.json`.
- Check 441: `chal00441_reason.json`; R2i → `r2i_alpha_decision.json`.
- Check 432: `chal00432_reason.json` (BKN; merge only if Reason+).

## Blocked

- Do **not** submit R1 / R1b / R1c / R2d / R2e / **R2h** — all fail submit bar.
- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Never serve crown engines at `max_model_len=32768`.
- Never symlink `/usr/local/cuda`→cu13 on B300.
- Never `pkill -f` over SSH; kill by PID / pidfile only.
- R2 lane-free check must use **pidfile kill -0**, never `pgrep -af`.
- Published duel `margin` can still be S\* (Λ2+L1) — **recompute Reason from lpC fields**.
- King-init high-Reason SFT family (R1/R1b/R1c) is **closed** for this king.
- Do **not** merge thompsville / BKN until duel shows Reason+ headroom.
- Talent×awesome (R2e) and Tok×Talent×kevin (R2h) are dead blends vs Tok — do not re-n80.

## Next action

**Wait R2g** premerge DONE → chall reload → n80 → harvest `r2g_alpha_decision.json`. Submit only if hr ≥ **1.5×**. If R2g fails, gate **R2i** on 441 Reason+; else harvest BKN `chal00432_reason.json` before a BKN merge lane.
