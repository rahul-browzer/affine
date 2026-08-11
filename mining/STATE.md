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
| Lium | ~$123,300 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| board | live duel **chal-00450** (sft3, scoring king ~16/80) |
| queue | 451 asdf → 452 zeus → 455 sth → 456 cp200 → **458 whoami** |
| disk | **~624 GiB free** on `/root` (65%) |
| R2d/e/f/h | 0.22× / REFUTE / SKIP / REFUTE −0.59× |
| **R2g/q/t** | Talent×saysth / pure saysth / saysth×Talent **REFUTE** |
| **R2s/u** | saysth×awesome/kevin **WEAK_SKIP** |
| **R2j/i/k** | BKN7 SKIP / thomp SKIP / **BKN6 SKIP** |
| R2l…p | Reason+ waiters armed (450/456/451/452/455) |
| **R2r** | Talent×whoami **ARMED** · after 458 hr>0 (+ R2v terminal) |
| **R2v** | pure sft3 **n80 RUNNING** · sim pid **194935** · ~12/80 @02:53Z · ETA~35m |
| **bridge** | `bridge_r2v_to_r2l` pid **196326** · local+ → unblock R2l; ≥1.5× → Stage-5 |
| gated+ | diane-new 0.54× / nvidia 0.45× / aurora 0.17× |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · **R2v n80** · bridge · R2l…p+R2r wait |

- Teacher/king/chall **200/200/200**; chall = pure sft3 (`/tmp/r2v_sft3`).
- R2v reload pid **189465** · sim **194935** · check `cat /root/affine_data/r2v_sft3_reason_progress.json`.
- Bridge: `cat /root/logs/bridge_r2v_to_r2l.done` / `r2v_stage5_ready.json`.
- R2l…p / R2r waiters alive; yield on R2v via wait-include / R2r wait-lane.

## Blocked

- No submit until sim hr ≥ **1.5×**. No S\* 0.04 gate / king-watch.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- Lane-free = **pidfile kill -0** only. Recompute Reason from lpC fields.
- No merge thomp/BKN6/BKN7/sft3/cp200/asdf/zeus/sth until Reason+. No re-n80 closed lanes.
- nvidia/diane-new/aurora weight-gated. R2r GPU only after **458 hr>0** (+ R2v terminal).
- saysth×kevin/awesome/Tok near-identical — do not re-α those pairs.
- saysth×Talent (both α directions) **REFUTED** — do not re-blend.
- Local R2v hr≤0 does **not** SKIP R2l (board may still be +; R2q precedent).

## Next action

**Harvest R2v** (`r2v_sft3_decision.json` + bridge done): hr≥1.5× → Stage-5 pure sft3; 0<hr<1.5× → confirm R2l proxy-stamp/premerge; hr≤0 → keep board 450 / R2r on 458.
