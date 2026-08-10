# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Reason v3 crown push** (operator 2026-08-10). King-watch **revoked**.
S\* v2 memory archived → `archive/legacy-sstar-v2/`.
`weight_version_key` must be **3**. Score = mean Reason (Λ2 only).

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · `weight_version_key=3` · crown = margin > 3·SE |
| king (verify) | check `api/v1/snapshot` every pass — Tok af10 was pre-fork king |
| Lium floor | ≥ $10,000 · daily mining ≤ $833/h |
| fleet | tear `mine-watch-1` → rent `mine-crown-1` 8×B300 (else 8×B200) |
| submissions | 0 · hotkey `default` unused |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| *(reconcile `lium ps` — expect tear watch, then crown pod)* | | | | |

## Blocked

- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Do **not** treat telemetry gates (r, bank, baseline, causality) as crown blockers.
- HF: `unconst` public storage may still be full — verify before push.
- Coldkey TAO is not convertible without a dated instruction.

## Operator directive 2026-08-10 (active)

1. Confirm `api/v1/contract` → `weight_version_key == 3`.
2. `lium rm` `mine-watch-1` only (name-check first).
3. Rent `mine-crown-1` 8×B300-class, TTL 12–24h, COUNT=8, update INVENTORY+LEDGER.
4. Bootstrap teacher+king+challenger; Reason-only sim from `score.py`.
5. Stage 0→3 this run; chase crown. Parallel ≤5 only after sim works.

## Next action

**Tear watch pod → rent `mine-crown-1` (8×B300 preferred) → Stage 0/3 Reason sim.**
