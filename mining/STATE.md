# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Win the subnet** (operator 2026-08-11). Reason v3. Objective ≠ make money.
Fleet must scale to **≥$20k/day mining B300 burn**.

## Live facts

| item | value |
|---|---|
| objective | **win / crown** — dollars are incidental |
| contract | Reason v3 · `weight_version_key=3` · crown > k_sigma·SE (check live k) |
| king | verify `api/v1/snapshot` every pass |
| burn floor | **>$20,000/day (≥~$833/h)** on `mine-*` **8×B300** |
| pod cap | **25** `mine-*` |
| Lium floor | ≥ $10,000 (only hard brake) |
| submissions | check `SUBMISSIONS.md` |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| *(reconcile `lium ps` — expect scale-up from single B200)* | | | |

## Blocked

- Do **not** stay on one ~$52/h B200 while under the B300 burn floor.
- Do **not** serialize identical board-copy n80s as "parallelism."
- Coldkey TAO not convertible without dated instruction.

## Operator directive 2026-08-11 (active)

1. Confirm contract wvk=3 and live k_sigma.
2. Sum mine-* $/h. If **<$833/h on B300**, rent 8×B300 now up toward floor/cap.
3. Assign **distinct axes** to new pods (GRPO-on-Reason, Reason-SFT, full-FT,
   non-king base, merges, format/data — not 13 copies of pure-board reload).
4. Keep one warm TKC stack; rest train/screen.
5. Submit only with ~1.5× headroom over live crown bar.

## Next action

**Scale B300 fleet to ≥$833/h burn with multi-axis experiments this pass.**
Reconcile inventory, rent free B300 capacity, launch ≥1 new axis beyond the
current single-box board-copy queue.
