# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage
**Stage 4 — beat the king; parallel axes.** Reason v3 · win the subnet.
Burn floor **≥$833/h** on mine-* 8×B300 (operator 2026-08-11).

## Live facts

| item | value |
|---|---|
| contract | wvk=**3** · `k_sigma=2.0` · reason_only · n_turns=2080 |
| king | `ttttxxxxsada/Affine-5guassq3tu` @ `e86758f5…` **reign 6** |
| challenge | live `chal-00533` |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 (API `gpu_count_gte=8` empty) |
| Lium bal | ~$116,430 · floor $10k OK |
| HF headroom | **purged ~281 GiB** REFUTE/below merges (r19/r24/r25/r33) |
| submissions | 0 |
| R22 | **TRAINING** golden-GRPO step **~101**/200 on crown |
| R23 | **TRAINING** diane-GRPO step **~11**/200 on R3 |
| R27 | **TRAINING** BigG G=16 step **~2**/200 on R4 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R22** golden-GRPO train |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R23** diane-GRPO train |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R27** BigG-GRPO G=16 |
| host fleet-burst | pid**4176223** | — | snatch next **R28** (SKIP_PID_LOCK) |
| host fleet-rent | pid**3373328** (**STOP**) | — | CONT if burst ends empty |
| host fleet-boot | pid**3852238** | — | POLL=5s |

SSH crown/R22: `ssh root@95.133.253.90 -p 40099` · R3/R23: `ssh root@204.9.206.245 -p 40051`
SSH R4/R27: `ssh root@86.38.182.50 -p 40307`
Burst: `tail -f experiments/fleet-rent/logs/burst_p2253.log`
Crown T/K live guass; C:8002 down until post_train merge (GPUs 4–5 reserved).

## Blocked
Under $833/h — need more 8×B300 (B200 fallback OK until B300 appears).
R10/R18 blocked on gated `ammazon/…-sbs-v2` (index 403).

## Operator directive 2026-08-12 — SUBMIT GATE = LIVE CROWN RULE
**Submit when:** paired margin > **live `k_sigma · SE`** (k=2.0) on a fresh
slice vs the **current** king. No 1.5×. No absolute margin>0.04 bar.

## Next action
1. Burst snatch → bootstrap **R28+**; tear any CREATION_FAILED immediately.
2. Await R22 train→merge→n80 → form-dec vs guass (k=2.0).
3. Await R23 / R27 same path; Stage-5 if margin > 2·SE.
