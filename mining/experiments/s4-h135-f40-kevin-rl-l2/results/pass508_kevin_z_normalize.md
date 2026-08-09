# H135/F40 pass508 — kevin empty-z was normalize bug, not dead teacher

## Symptom
- p507 killed train for `mean_r=0` + `z0=""` (teacher `:8000` dead).
- p508: teacher recover → `:8000=200` + completions smoke OK; retrain still
  logged `mean_r=0` / `z0=""` through step 20.

## Root cause
- Offline generate on kevin954: first tokens are
  `</think>\nTHOUGHT: …\n```bash`.
- `_sample_thought` cut at `THINK_CLOSE` offset 0 → text=`</think>`.
- `_normalize_z` then `partition(</think>)` → empty latent → teacher Λ2 of
  empty vs empty = 0. Same signature as dead teacher.

## Fix (deployed + relaunched)
- Prefer ```bash cut; only cut at `</think>` when `i_close > 0`.
- Leading-`</think>` path: keep body after close, strip `THOUGHT:` prefix.
- Unit: `</think>\nTHOUGHT: I see bottle.py\n\n```bash` → `I see bottle.py`.
- Fresh train pid=22903 @08:54:01Z; confirm non-zero `mean_r` + non-empty `z0`.

## Lesson
- `mean_r=0` + empty `z0` ≠ only dead teacher. Check one offline generate
  decode before blaming `:8000`.
