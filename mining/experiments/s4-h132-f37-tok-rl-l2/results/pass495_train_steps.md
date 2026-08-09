# pass495 — F37 REINFORCE steps confirmed

UTC: 2026-08-09T07:25–07:27Z · mine-f37-1 · train pid11123

## Evidence
- Weight load finished 693/693 (~1m57s).
- LoRA: trainable 8,355,840 / 34,668,966,528 (0.0241%).
- Teacher `:8000` = 200 throughout; train on CUDA 6,7 (~37 GiB each).
- Live reward logs (`/root/logs/h132_train.nohup`):

| step | mean_r | rewards | loss |
|---|---|---|---|
| 1 | 0.01992 | 0.01988, 0.01995 | −9.5e-5 |
| 2 | 0.02419 | 0.02460, 0.02378 | 7.9e-4 |
| 3 | 0.00332 | 0.00351, 0.00313 | 2.8e-4 |
| 5 | 0.02090 | 0.02271, 0.01909 | 1.6e-3 |

## Verdict
Teacher-Λ2 reward path is **live** (not stuck on weight load). Continue to max_steps=200 → merge → n80.
No decision yet.
