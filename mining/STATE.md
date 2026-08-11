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
| Lium | ~$123,266 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| **board 450** | sft3 **hr 0.37×** (margin +0.0046, z=1.11, n=80) — Reason+ no crown |
| queue | 451 asdf → 452 zeus → 455 sth → 456 cp200 → **458 whoami** |
| disk | **~624 GiB free** on `/root` (65%) |
| R2d/e/f/h | 0.22× / REFUTE / SKIP / REFUTE −0.59× |
| **R2g/q/t** | Talent×saysth / pure saysth / saysth×Talent **REFUTE** |
| **R2s/u** | saysth×awesome/kevin **WEAK_SKIP** |
| **R2j/i/k** | BKN7 SKIP / thomp SKIP / **BKN6 SKIP** |
| **R2l** | Talent×sft3 **CPU merging** (board hr>0) · shards in flight |
| R2m…p+R2r | Reason+ waiters armed (456/451/452/455 + whoami) |
| **R2v** | pure sft3 **n80 ~53/80** · sim pid **194935** · ETA~10m |
| **bridge-v** | waits R2v dec · board stamp already present → OK_BOARD_FIRST |
| **stage5-push** | armed · HF pre-purged +140 GiB · only if local ≥1.5× |
| **R2w** | pure asdf **re-armed** pid **200437** · **yields mid-R2l** (p1950 fix) |
| **bridge-w** | →R2n still armed (pid 197133) |
| gated+ | diane-new 0.54× / nvidia 0.45× / aurora 0.17× |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · R2v n80 · R2l merge · R2w yield · stage5 |

- R2v: `cat /root/affine_data/r2v_sft3_reason_progress.json` · decision → `r2v_sft3_decision.json`
- R2l: `tail /root/logs/r2l_premerge.log` · out `/root/r2_out/alpha_talent_sft3_skew`
- R2w: yields while `r2l_premerge.pid` alive or board 450 hr>0; then asdf chall
- Board stamp: `artifacts/chal00450_reason.json` (hr 0.37×)

## Blocked

- No submit until sim hr ≥ **1.5×**. Board 450 is only 0.37× — need R2l/R2w/local.
- Stage5-push = HF only; next pass still register fresh hotkey + `submit.py --check`.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- R2w must not steal chall mid-R2l blend (fixed p1950).
- No re-n80 closed lanes; no saysth×Talent / near-identical α pairs.

## Next action

**Harvest R2v** then confirm order: R2l finishes blend → chall reload n80 (R2w waits); if R2v≥1.5× confirm Stage5 HF push meta then Stage-5 register+`--check`+submit; if R2v hr≤0 still let R2l own GPU before asdf.
