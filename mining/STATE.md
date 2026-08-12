# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage
**Stage 4 — beat the king; parallel axes.** Reason v3 · win the subnet.
Burn floor **≥$833/h** on mine-* 8×B300 (operator 2026-08-11).

## Live facts

| item | value |
|---|---|
| contract | wvk=**3** · `k_sigma=2.0` · reason_only · n_turns=2080 |
| king | `tolegend/Affine-5fqbxvz29b-ckp333` @ `24c137e8…` **reign 5** |
| challenge | chal-**00520** |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 (burst_p2194 still empty) |
| Lium bal | ~$118,296 · floor $10k OK |
| submissions | 0 |
| R14 | **REFUTE** n80 m=**−0.0215** z=−1.14 (p2194) |
| R15 | **training** pandora-REINFORCE on mine-r3 ~step **95**/200 |
| R16 | merge+HF push **DONE** · chall:8002 **loading** → n80 vs ckp333 |
| R20 | **training** kevin-GRPO on mine-r4 ~step **16**/200 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R16** chall reload→n80 (TKC warm) |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R15** pandora-REINFORCE |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R20** kevin-GRPO |
| host fleet-rent | pid**3373328** (STOP till burst) | — | api-POST-rent; next=**R24** |
| host burst p2194 | pid**3400683** | — | 1500-iter SKIP_PID_LOCK |
| host fleet-boot | pid**2756348** | — | POLL=5s |
| host hist bridge | pid**3174953** | — | +chal-00525 |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307`
R15: `tail -f /root/logs/h135_train.nohup` · R16: `tail -f /root/logs/r16_post_train.nohup`
R20: `tail -f /root/logs/r3_train.nohup` · Fleet: `tail -f experiments/fleet-rent/logs/burst_p2194.log`
HF R16: `unconst/Affine-5czsc2fc98-r16-golden-rl` @ `51033cdf…` (salvage; not submit)
Crown Removal **2026-08-13T02:35:59Z** (Soft **01:35Z** / Dead **02:05Z**).
R3 Removal **2026-08-12T16:29Z**. R4 Removal **2026-08-12T20:57Z**.

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.
R10: need Hub access to `ammazon/…-sbs-v2` (or public merge parent).

## Next action
**Rent:** wait burst_p2194 → CONT waiter **3373328**; snatch **R24** on first 8×.
**R16:** wait chall:8002 ready → n80 vs ckp333 (hr≥1.5×) → Stage-5 if ADVANCE.
**R15/R20:** wait train→merge→n80. **Fleet next:** R25… then R5b/R10/R17…
