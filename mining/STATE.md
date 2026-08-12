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
| miner burn | **$220.25/h** · floor $833/h · **gap −$613/h** |
| B300 stock | **0** free 8×B300/B200 (burst snatching) |
| Lium bal | ~$116,565 · floor $10k OK |
| submissions | 0 |
| R25 | **n80 LIVE** on R3 (~24/80) form-dec armed; vs guass |
| R22 | **TRAINING** crown golden-GRPO ~step 19 |
| R19 | train **DONE** → post_train re-serve chall `/tmp/r3_merged` (c=000) |
| R10 / R18 | **BLOCKED** sbs-v2 index **403** |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R22** golden-GRPO train |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R25 n80** gather (~24/80) |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R19** post_train re-serve |
| mine-r25-hitemp-1 | zesty-fox-bc | $40.00 | **REBOOT_FAILED** (SSH down) |
| host fleet-burst | pid**4116237** | — | **86400**-iter snatch next **R23** |
| host fleet-rent | pid**3373328** (**STOP**) | — | CONT if burst ends empty |
| host fleet-boot | pid**3852238** | — | POLL=5s |
| host p2248 dec-watch | pid**4107829** | — | await `r25_decision.json` |

SSH crown/R22: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4/R19: `ssh root@86.38.182.50 -p 40307` · R25: `ssh root@150.136.71.147 -p 20309` (down)
Burst: `tail -f experiments/fleet-rent/logs/burst_p2249.log`
R25 sim: `ssh … R3 'tail -f /root/logs/r25_sim.nohup'`
R25 dec: `tail -f experiments/r25-hitemp-grpo/artifacts/p2248_r25_decision_watch.log`

## Blocked
Under $833/h — need more 8×B300 (B200 fallback OK until B300 appears).
R10/R18 blocked on gated `ammazon/…-sbs-v2` (index 403).
R25 box still REBOOT_FAILED — tear after R25-on-R24 n80 lands if still dead.

## Operator directive 2026-08-12 — SUBMIT GATE = LIVE CROWN RULE
**Submit when:** paired margin > **live `k_sigma · SE`** (k=2.0) on a fresh
slice vs the **current** king. No 1.5×. No absolute margin>0.04 bar.

## Next action
1. Await R25 n80 → `r25_decision.json` (watch 4107829). If CLEAR → Stage-5.
2. R19: finish chall re-serve on r4 → n80 vs guass.
3. R22 train→merge→n80 on crown.
4. Burst snatch → bootstrap **R23**; tear dead R25 box when R25 decides.
