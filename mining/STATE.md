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
| Lium bal | ~$116,614 · floor $10k OK |
| submissions | 0 |
| R24 | n80 DONE vs guass m=+0.00828 z=0.68 → SIGNAL_POS_BELOW |
| R25 | on R3: HF **16/16** @ `/root/r25_from_hf` (66G); chall vLLM **loading** :8002; n80 armed |
| R19 | Talent-GRPO train (r4) |
| R33 | guass-init GRPO train (crown) |
| R10 / R18 | **BLOCKED** sbs-v2 index **403** |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R33** guass-init GRPO |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R25-on-R24** chall load→n80 |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R19** Talent-GRPO train |
| mine-r25-hitemp-1 | zesty-fox-bc | $40.00 | **REBOOT_FAILED** (SSH down) |
| host fleet-burst | pid**3962156** | — | **86400**-iter snatch next **R22** |
| host fleet-rent | pid**3373328** (**STOP**) | — | CONT if burst ends empty |
| host fleet-boot | pid**3852238** | — | POLL=5s |
| host p2247 reboot-watch | pid**4091485** | — | R25 post-reboot (SSH still down) |
| host p2248 dec-watch | pid**4107829** | — | await `r25_decision.json` |

SSH crown/R33: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4/R19: `ssh root@86.38.182.50 -p 40307` · R25: `ssh root@150.136.71.147 -p 20309` (down)
Burst: `tail -f experiments/fleet-rent/logs/burst_p2241.log`
R25 dec: `tail -f experiments/r25-hitemp-grpo/artifacts/p2248_r25_decision_watch.log`

## Blocked
Under $833/h — need more 8×B300 (B200 fallback OK until B300 appears).
R10/R18 blocked on gated `ammazon/…-sbs-v2` (index 403).
R25 box still REBOOT_FAILED — tear after R25-on-R24 n80 lands if still dead.

## Operator directive 2026-08-12 — SUBMIT GATE = LIVE CROWN RULE
**Submit when:** paired margin > **live `k_sigma · SE`** (k=2.0) on a fresh
slice vs the **current** king. No 1.5×. No absolute margin>0.04 bar.

## Next action
1. Await R25-on-R24 n80 → `r25_decision.json` (host watch pid**4107829**).
2. If CLEAR → Stage-5; if SIGNAL_POS_BELOW → mark + free/reuse R3 slot.
3. If R25 still REBOOT_FAILED after n80 → `lium rm mine-r25-hitemp-1`.
4. Burst snatch → bootstrap R22; R19/R33 continue GRPO.
