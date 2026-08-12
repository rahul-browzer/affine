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
| B300 stock | **0** free 8×B300/B200 (burst polling) |
| Lium bal | ~$116,453 · floor $10k OK |
| submissions | 0 |
| R19 | **SIGNAL_POS_BELOW** (archived on R4; slot→R27) |
| R27 | **TRAINING** BigG G=16 on R4 (pid**177775**) |
| R23 | **WARM** on R3 — diane DL→train |
| R22 | **TRAINING** golden-GRPO on crown (~step 68) |
| R10 / R18 | **BLOCKED** sbs-v2 index **403** |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R22** golden-GRPO train |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R23** diane DL→GRPO |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R27** BigG-GRPO G=16 |
| host fleet-burst | pid**4176223** | — | snatch next **R28** (SKIP_PID_LOCK) |
| host fleet-rent | pid**3373328** (**STOP**) | — | CONT if burst ends empty |
| host fleet-boot | pid**3852238** | — | POLL=5s |

SSH crown/R22: `ssh root@95.133.253.90 -p 40099` · R3/R23: `ssh root@204.9.206.245 -p 40051`
SSH R4/R27: `ssh root@86.38.182.50 -p 40307`
Burst: `tail -f experiments/fleet-rent/logs/burst_p2253.log`
R27: `ssh … R4 'tail -f /root/logs/r3_train.nohup'`
R23: `ssh … R3 'tail -f /root/logs/r23_lean_warm.log'`

## Blocked
Under $833/h — need more 8×B300 (B200 fallback OK until B300 appears).
R10/R18 blocked on gated `ammazon/…-sbs-v2` (index 403).
CLI `lium up` on one-shot templates can CREATION_FAIL — tear + keep burst polling.

## Operator directive 2026-08-12 — SUBMIT GATE = LIVE CROWN RULE
**Submit when:** paired margin > **live `k_sigma · SE`** (k=2.0) on a fresh
slice vs the **current** king. No 1.5×. No absolute margin>0.04 bar.

## Next action
1. Await R27 train→merge→n80 on R4; form-dec vs guass (k=2.0).
2. Confirm R23 train+post_train after diane DL; await n80 → decision.
3. R22 train→merge→n80 on crown.
4. Burst snatch → bootstrap **R28+**; do not leave CREATION_FAILED pods billing.
