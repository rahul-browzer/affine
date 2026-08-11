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
| Lium balance | ~$123,624 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| board | duel **chal-00432** BKN seven @ `load_challenger` |
| disk | **~1.5 TiB free** on `/` (51% used) |
| R2d pure awesome-v6 | **DONE** · hr **0.22×** · `SIGNAL_POS_BELOW_3SE` |
| R2e Talent×awesome | **DONE** · hr **−1.18×** · **REFUTED** |
| R2f kevin×awesome | **SKIPPED** · Δ=0.00899 |
| R2h Tok×Talent×kevin | **DONE REFUTE** · hr **−0.59×** |
| chal-00440 saysth | **DONE** · hr **0.73×** · `POS_BELOW_3SE` |
| **R2g Talent×saysth** | **n80 RUNNING** · ~16/80 · sim pid **146391** |
| R2i Talent×thomp | gated on 441 Reason+ (waiters armed) |
| BKN seven | cached · watch **140530** · still load_challenger (evals 404) |
| BKN six | **PREFETCH DONE** · `@a12fc171…` |
| sft3 (450) | **PREFETCH DONE** · `@381dbc82…` |
| asdf (451) | **PREFETCHING** · `@c2309815…` · ~27 GiB · pid **147881** |
| zeus (452) | **ARMED** after asdf · `@accc9249…` · chain pid **147860** |
| **sth (455)** | **ARMED** after zeus · `@8d81e782…` · chain pid **148630** · weights_ok |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | TK@65536 · R2g n80 · R2i/441 · BKN/432 · asdf→zeus→sth |

- Engines: teacher/king/chall **200** · chall=`/tmp/r2g_alpha_merged` (Talent×saysth Δ0.626).
- R2g n80: `block_hash=d4044d4eaa11…` · out `/root/affine_data/r2g_alpha_reason_sim.json` · decision → `r2g_alpha_decision.json`.
- Check: `cat /root/affine_data/r2g_alpha_reason_progress.json`; harvest → `r2g_alpha_decision.json`.
- asdf: `tail /root/logs/r2_prefetch_asdf.log`; done → `r2_prefetch_asdf.done`.
- zeus chain: `tail /root/logs/r2_prefetch_zeus_after_asdf.log`; then `r2_prefetch_zeus.done`.
- sth chain: `tail /root/logs/r2_prefetch_sth_after_zeus.log`; then `r2_prefetch_sth.done`.

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

**Harvest R2g** → `r2g_alpha_decision.json`. Submit only if hr ≥ **1.5×**. If R2g fails: gate **R2i** on 441 Reason+; harvest BKN `chal00432_reason.json`; confirm asdf→zeus→sth DONE; pick next Reason+ queue parent or merge lane from harvest.
