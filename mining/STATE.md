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
| Lium balance | ~$123,825 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| board | duel phase · `chal-00440` (scan parents after R2e) |
| R1 LoRA n80 | **DONE** · `SIGNAL_POS_BELOW_3SE` · margin +0.0005 ≪ 3·SE 0.0147 |
| R1b n80 #2 | **DONE** · `REFUTE_R1_H64_BASELINE` · margin **−0.0135** · z=−2.45 |
| R1c n80 | **DONE** · `REFUTE_R1_H64_BASELINE` · margin **−0.0171** · z=−2.75 · hr=−0.92× |
| R2/R2b/R2c | **SKIPPED** (p1893) · Tok×awesome Δ≪0.01 · stubs headroom=0 |
| R2d pure awesome-v6 | **DONE** · `SIGNAL_POS_BELOW_3SE` · margin **+0.00223** · z=0.66 · hr=**0.22×** |
| R2e Talent×awesome | **n80 RUNNING** · sim **128291** · chall **124848** · Δ=**0.626** |
| R2f kevin×awesome | **SKIPPED** (p1898) · premerge Δ=**0.00899** ≪0.01 · stub hr=0 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | TK@65536 + R2e n80 |

- Engines 8000/8001/8002 all **200**; chall=`/tmp/r2e_alpha_merged` (Talent×awesome).
- R2e n80: `run_reason_sim.py` pid **128291** (waiter **104742**); block_hash `b91bfdcc50b50cfc…`.
- Check: `cat /root/affine_data/r2e_alpha_reason_progress.json`; harvest `r2e_alpha_decision.json`.
- R2d artifacts: `experiments/r2-multiking-merge/artifacts/r2d_awesome_{decision,reason_sim}.json`.

## Blocked

- Do **not** submit R1 / R1b / R1c / R2d — all fail submit bar (R2d hr 0.22×).
- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Never serve crown engines at `max_model_len=32768`.
- Never symlink `/usr/local/cuda`→cu13 on B300.
- Coldkey TAO is not convertible without a dated instruction.
- **unconst HF storage** — purge again before next ~65 GiB push if commit fails.
- Never `pkill -f` over SSH; kill by PID / pidfile only.
- R2 lane-free check must use **pidfile kill -0**, never `pgrep -af`.
- Published duel `margin` can still be S\* (Λ2+L1) — **recompute Reason from lpC fields**.
- Prefer R2e (Talent Δ=0.626) — pure awesome-v6 alone is not enough (R2d).
- King-init high-Reason SFT family (R1/R1b/R1c) is **closed** for this king — do not re-arm.

## Next action

**Harvest R2e** when `/root/affine_data/r2e_alpha_decision.json` exists. If headroom ≥ 1.5× → Stage-5. Else rescan `chal-00440+` for DL Reason+ parents and plan next merge (R2d/awesome alone insufficient).
