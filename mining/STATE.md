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
| challenge | queue empty (latest stamped chal-00525) |
| miner burn | **$220.25/h** · floor $833/h · **gap −$613/h** |
| B300 stock | **0** free 8×B300/B200 (burst snatching) |
| Lium bal | ~$117,121 · floor $10k OK |
| submissions | 0 |
| R10 / R18 | **BLOCKED** sbs-v2 index **403** |
| R21 | **REFUTE** vs guass n80 m=**−0.00568** z=**−0.55** (p2235) |
| R26 | **SIGNAL_POS_BELOW** vs guass m=**+0.00192** z=**0.19** (p2235) — no submit |
| R24 | train~**145**/200; post_train waiter live |
| R25 | train~**129**/200; post_train waiter live |
| R33 | **warm-armed** on crown (guass-init GRPO train pid364476) |
| R5b | **warm-armed** on r4 (Talent full-FT DL→train) |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R33** guass-init GRPO train + T/K warm |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R24** train + guass + tmax + n80-gate |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R5b** Talent full-FT bootstrap |
| mine-r25-hitemp-1 | zesty-fox-bc | $40.00 | **R25** train + guass |
| host fleet-burst | pid**3888146** | — | **86400**-iter snatch next **R19** |
| host fleet-rent | pid**3373328** (**STOP**) | — | CONT if burst ends empty |
| host fleet-boot | pid**3852238** | — | POLL=5s (R33/R5b already warm) |

SSH crown/R33: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4/R5b: `ssh root@86.38.182.50 -p 40307` · R25: `ssh root@150.136.71.147 -p 20309`
Burst: `tail -f experiments/fleet-rent/logs/burst_p2235.log`
R33: `tail -f /root/logs/r3_train.nohup` on crown · R5b: `tail -f /root/logs/bootstrap_h122.log`
Crown Removal **2026-08-13T02:35Z**. R3 **04:29Z**. R4 **08:57Z**. R25 **08:46Z**.

## Blocked
Under $833/h — need more 8×B300 (B200 fallback OK until B300 appears).
R10/R18 blocked on gated `ammazon/…-sbs-v2` (index 403).

## Operator directive 2026-08-12 — SUBMIT GATE = LIVE CROWN RULE
**Submit when:** paired margin > **live `k_sigma · SE`** (k=2.0) on a fresh
slice vs the **current** king. No 1.5×. No absolute margin>0.04 bar.
Re-sim WEAK_CLEAR vs **guass** before submit (not stale ckp333).

## Next action
1. Watch R33 train→merge→n80 vs **guass**; any clear → Stage-5.
2. Watch R5b Talent full-FT → n80 vs guass; R24/R25 → merge when train.done.
3. Keep burst snatching (R19→…); stock empty this pass.
