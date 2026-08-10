# SUBMISSIONS — every hotkey we register / burn

**Check this file before every submit.** One eval slot per hotkey, ever. Slot burns at enqueue.

## Hotkeys

| hotkey name | ss58 | registered block | burn τ | repo | revision | submit check output | verdict | slot |
|---|---|---|---|---|---|---|---|---|
| default | `5G1sKqsDSMEktjGvXAt8BRyon8Lkug6eRt5ETmWxbgSPVQrj` | not on SN120 | — | — | — | — | — | unused |

## Identity tokens (repo naming)

- coldkey `5CZscRf3nZmGspyqs2ZvFXSjnnondpjNU5QbJWVFFT92FC98` → token `5czsc2fc98`
- hotkey `5G1sKqsDSMEktjGvXAt8BRyon8Lkug6eRt5ETmWxbgSPVQrj` → token `5g1skpvqrj`
- Example repo: `unconst/Affine-5czsc2fc98-<name>`

## Rules (Reason v3)

- Fresh registered hotkey per submission.
- Simulated paired **Reason** margin over current king **> ~1.5 × (3·SE)** before submit (slice headroom). Old S\* gate 0.04 is retired.
- Always `submit.py --check` first; paste output into the experiment log.
- Never resubmit a content revision that has ever been submitted by anyone.
- Confirm `weight_version_key == 3` on contract before enqueue.
