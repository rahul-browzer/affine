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
| Lium balance | ~$123,635 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| board | duel **chal-00432** BKN seven @ `load_challenger` |
| disk | **~691 GiB free** on `/root` |
| R2d pure awesome-v6 | **DONE** · hr **0.22×** · `SIGNAL_POS_BELOW_3SE` |
| R2e Talent×awesome | **DONE** · hr **−1.18×** · **REFUTED** |
| R2f kevin×awesome | **SKIPPED** · Δ=0.00899 |
| R2h Tok×Talent×kevin | **DONE REFUTE** · hr **−0.59×** |
| chal-00440 saysth | **DONE** · hr **0.73×** · `POS_BELOW_3SE` |
| **R2g Talent×saysth** | **MERGED+RELOADING** · Δ=0.626 · chall pid **142866** → n80 |
| R2i Talent×thomp | gated on 441 Reason+ (queue after R2g) |
| BKN seven | cached · watch **140530** · live eval now |
| **BKN six** | **PREFETCHING** · chal-00431 · ~48 GiB · pid **142256** |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | TK@65536 · R2g reload→n80 · R2i/441 · BKN/432 · prefetch BKN6 |

- Engines: teacher/king **200**; chall **loading** `/tmp/r2g_alpha_merged` (was R2h).
- R2g: premerge **DONE** 00:20:29Z · waiter **130835** stopped old chall · new chall **142866**.
- Check: `tail /root/logs/r2g_merge_reload.log`; harvest `r2g_alpha_decision.json`.
- BKN six: `tail /root/logs/r2_prefetch_bkn_six.log`; done → `r2_prefetch_bkn_six.done`.

## Blocked

- Do **not** submit R1 / R1b / R1c / R2d / R2e / **R2h** — all fail submit bar.
- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Never serve crown engines at `max_model_len=32768`.
- Never symlink `/usr/local/cuda`→cu13 on B300.
- Never `pkill -f` over SSH; kill by PID / pidfile only.
- Never `rm -rf` the directory behind the live chall symlink until after reload.
- R2 lane-free check must use **pidfile kill -0**, never `pgrep -af`.
- Published duel `margin` can still be S\* — **recompute Reason from lpC fields**.
- King-init high-Reason SFT family (R1/R1b/R1c) is **closed** for this king.
- Do **not** merge thompsville / BKN until duel shows Reason+ headroom.
- Talent×awesome (R2e) and Tok×Talent×kevin (R2h) are dead blends vs Tok — do not re-n80.

## Next action

**Wait R2g** chall health **200** → n80 → harvest `r2g_alpha_decision.json`. Submit only if hr ≥ **1.5×**. If R2g fails: gate **R2i** on 441 Reason+; harvest BKN `chal00432_reason.json`; confirm BKN-six prefetch DONE before next queue parent.
