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
| Lium balance | ~$123,780 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| board | duel phase · `chal-00440` `saysth/…-v9a` @ `6e13f365…` (**load_challenger**) |
| R1 family | **CLOSED** (R1/R1b/R1c all fail / hurt) |
| R2d pure awesome-v6 | **DONE** · hr **0.22×** · `SIGNAL_POS_BELOW_3SE` |
| R2e Talent×awesome | **n80 RUNNING** · ~37/80 · sim **128291** · Δ=**0.626** |
| R2f kevin×awesome | **SKIPPED** · Δ=0.00899 |
| R2g Talent×saysth | premerge **130003** + reload→n80 **130835** (R2h-aware) |
| R2h Tok×Talent×kevin | **ARMED** pid **130845** · Δ=**0.277** · never n80'd (p1893 stub was Tok×awesome) |
| saysth prefetch | **DONE** · cached @ HF snapshot `6e13f365…` |
| chal-00440 watch | pid **129745** → `/root/affine_data/chal00440_reason.json` |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | TK@65536 + R2e n80 + 440/R2g/R2h chain |

- Engines 8000/8001/8002 all **200**; chall=`/tmp/r2e_alpha_merged` (Talent×awesome).
- R2e n80: `run_reason_sim.py` pid **128291**; parent reload **104742**; block_hash `b91bfdcc50b50cfc…`.
- Check: `cat /root/affine_data/r2e_alpha_reason_progress.json`; harvest `r2e_alpha_decision.json`.
- R2g: waits 440 Reason+ then Talent×saysth; lane also waits R2h pidfile.
- R2h: after R2e below-bar, takes GPU if R2g still waiting Reason (else after R2g); → `r2h_ttk_decision.json`.

## Blocked

- Do **not** submit R1 / R1b / R1c / R2d — all fail submit bar.
- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Never serve crown engines at `max_model_len=32768`.
- Never symlink `/usr/local/cuda`→cu13 on B300.
- Coldkey TAO is not convertible without a dated instruction.
- **unconst HF storage** — purge again before next ~65 GiB push if commit fails.
- Never `pkill -f` over SSH; kill by PID / pidfile only.
- R2 lane-free check must use **pidfile kill -0**, never `pgrep -af`.
- Published duel `margin` can still be S\* (Λ2+L1) — **recompute Reason from lpC fields**.
- King-init high-Reason SFT family (R1/R1b/R1c) is **closed** for this king.
- Do **not** merge saysth until `chal00440_reason.json` shows Reason+ headroom (R2g waiter enforces).
- `r2_alpha_decision.json` SKIP_WEAK stub is **Tok×awesome**, not TTK — do not treat TTK as weak-Δ.

## Next action

**Harvest R2e** when `/root/affine_data/r2e_alpha_decision.json` exists. If headroom ≥ 1.5× → Stage-5. Else follow chain: R2h takes GPU while 440 pending (or after R2g SKIP) → `r2h_ttk_decision.json`; R2g runs if saysth Reason+. If all below bar → rescan new completed evals for Reason+ parents.
