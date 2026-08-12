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
| Lium bal | ~$116,497 · floor $10k OK |
| submissions | 0 |
| R19 | **SIGNAL_POS_BELOW** m=**+0.00673** z=0.75 hr**0.38×** (p2252) |
| R23 | **WARM** on R3 — diane DL→train GPUs 6–7 |
| R22 | **TRAINING** golden-GRPO on crown |
| R10 / R18 | **BLOCKED** sbs-v2 index **403** |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R22** golden-GRPO train |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R23** diane DL→GRPO (lean 122037) |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | idle TKC post-R19 (reuse next) |
| host fleet-burst | pid**4156282** | — | snatch next **R27** (SKIP_PID_LOCK) |
| host fleet-rent | pid**3373328** (**STOP**) | — | CONT if burst ends empty |
| host fleet-boot | pid**3852238** | — | POLL=5s |

SSH crown/R22: `ssh root@95.133.253.90 -p 40099` · R3/R23: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307`
Burst: `tail -f experiments/fleet-rent/logs/burst_p2252.log`
R23: `ssh … R3 'tail -f /root/logs/r23_lean_warm.log'`
R19 art: `experiments/r19-talent-grpo/artifacts/p2252_r19_*.json`

## Blocked
Under $833/h — need more 8×B300 (B200 fallback OK until B300 appears).
R10/R18 blocked on gated `ammazon/…-sbs-v2` (index 403).
CLI `lium up` on one-shot templates can CREATION_FAIL — tear + keep burst polling.

## Operator directive 2026-08-12 — SUBMIT GATE = LIVE CROWN RULE
**Submit when:** paired margin > **live `k_sigma · SE`** (k=2.0) on a fresh
slice vs the **current** king. No 1.5×. No absolute margin>0.04 bar.

## Next action
1. Confirm R23 train+post_train after diane DL; await n80 → decision.
2. Warm next QUEUE axis (**R27** BigG) on idle R4 TKC (or await burst rent).
3. R22 train→merge→n80 on crown.
4. Burst snatch → bootstrap R27+; do not leave CREATION_FAILED pods billing.
