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
| B300 stock | **0** free 8×B300 (1×B200 sighted; template one-shot fail) |
| Lium bal | ~$116,519 · floor $10k OK |
| submissions | 0 |
| R25 | **REFUTE** m=**−0.00595** z=−0.42 (p2251); dead box torn |
| R19 | **n80 LIVE** on r4 after Triton reseed (form-dec armed) |
| R22 | **TRAINING** golden-GRPO on crown |
| R10 / R18 | **BLOCKED** sbs-v2 index **403** |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R22** golden-GRPO train |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | idle TKC after R25 REFUTE (reuse next axis) |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R19 n80** gather vs guass |
| host fleet-burst | pid**4116237** | — | snatch next **R23** (86400-iter) |
| host fleet-rent | pid**3373328** (**STOP**) | — | CONT if burst ends empty |
| host fleet-boot | pid**3852238** | — | POLL=5s |

SSH crown/R22: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4/R19: `ssh root@86.38.182.50 -p 40307`
Burst: `tail -f experiments/fleet-rent/logs/burst_p2249.log`
R19 sim: `ssh … R4 'tail -f /root/logs/r3_sim.nohup'`
R19 dec: `/root/affine_data/r3_decision.json` (form hyp=r3 → label R19)

## Blocked
Under $833/h — need more 8×B300 (B200 fallback OK until B300 appears).
R10/R18 blocked on gated `ammazon/…-sbs-v2` (index 403).
CLI `lium up` on one-shot templates can CREATION_FAIL — tear + keep burst polling.

## Operator directive 2026-08-12 — SUBMIT GATE = LIVE CROWN RULE
**Submit when:** paired margin > **live `k_sigma · SE`** (k=2.0) on a fresh
slice vs the **current** king. No 1.5×. No absolute margin>0.04 bar.

## Next action
1. Await R19 n80 → `r3_decision.json` (Talent-GRPO). If CLEAR → Stage-5.
2. Reuse R3 warm TKC for next QUEUE axis (R23/R27…) or await burst rent.
3. R22 train→merge→n80 on crown.
4. Burst snatch → bootstrap **R23**; do not leave CREATION_FAILED pods billing.
