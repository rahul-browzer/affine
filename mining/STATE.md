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
| Lium | ~$123,289 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| board | live duel **chal-00450** (sft3, scoring; gzip 404) |
| queue | 451 asdf → 452 zeus → 455 sth → 456 cp200 → **458 whoami** |
| disk | **~624 GiB free** on `/root` (65%) |
| R2d/e/f/h | 0.22× / REFUTE / SKIP / REFUTE −0.59× |
| **R2g/q/t** | Talent×saysth / pure saysth / saysth×Talent **REFUTE** |
| **R2s/u** | saysth×awesome/kevin **WEAK_SKIP** |
| **R2j/i/k** | BKN7 SKIP / thomp SKIP / **BKN6 SKIP** |
| R2l…p | Reason+ waiters armed (450/456/451/452/455) |
| **R2r** | Talent×whoami **ARMED** · after 458 hr>0 (+ R2v/R2w terminal) |
| **R2v** | pure sft3 **n80 RUNNING** · sim pid **194935** · ~32/80 @03:01Z · ETA~25m |
| **bridge-v** | `bridge_r2v_to_r2l` pid **196326** · local+ → unblock R2l; ≥1.5× → Stage-5 |
| **stage5-push** | `watch_r2v_stage5_push` pid **198235** · on Stage-5 → HF push (no submit) |
| **R2w** | pure asdf **ARMED** · pid **197123** · waits R2v+bridge-v · **asdf_chall READY** |
| **bridge-w** | `bridge_r2w_to_r2n` pid **197133** · local+ → unblock R2n; ≥1.5× → Stage-5 |
| gated+ | diane-new 0.54× / nvidia 0.45× / aurora 0.17× |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · **R2v n80** · stage5-push · bridges · R2w · R2l…p+R2r |

- Teacher/king/chall **200/200/200**; chall = pure sft3 (`/tmp/r2v_sft3`).
- R2v sim **194935** · check `cat /root/affine_data/r2v_sft3_reason_progress.json`.
- Bridge-v: `cat /root/logs/bridge_r2v_to_r2l.done` / `r2v_stage5_ready.json`.
- Stage5-push: `cat /root/logs/watch_r2v_stage5_push.done` / `r2v_stage5_hf_push.json`.
- R2w: `tail /root/logs/r2w_asdf_reload.log` · chall dir `/root/r2_out/asdf_chall` pre-staged.
- Bridge-w: `cat /root/logs/bridge_r2w_to_r2n.done` / `r2w_stage5_ready.json`.

## Blocked

- No submit until sim hr ≥ **1.5×**. No S\* 0.04 gate / king-watch.
- Stage5-push uploads HF only — next pass must register fresh hotkey + `submit.py --check`.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- Lane-free = **pidfile kill -0** only. Recompute Reason from lpC fields.
- No merge thomp/BKN6/BKN7/sft3/cp200/asdf/zeus/sth until Reason+. No re-n80 closed lanes.
- nvidia/diane-new/aurora weight-gated. R2r GPU only after **458 hr>0** (+ R2v/R2w terminal).
- saysth×kevin/awesome/Tok near-identical — do not re-α those pairs.
- saysth×Talent (both α directions) **REFUTED** — do not re-blend.
- Local pure-parent hr≤0 does **not** SKIP Talent×parent (board may still be +).

## Next action

**Harvest R2v** (`r2v_sft3_decision.json` + bridge-v done): hr≥1.5× → confirm Stage5 HF push meta then Stage-5 register+`--check`+submit; 0<hr<1.5× → R2l proxy merge; hr≤0 → confirm **R2w** takes chall (asdf_chall ready) without idle GPU.
