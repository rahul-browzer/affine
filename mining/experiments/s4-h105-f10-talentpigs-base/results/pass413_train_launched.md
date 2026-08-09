# H105/F10 pass413 — TalentPigs DL done, train confirmed live

## Facts
- TalentPigs HF DL finished → snapshot
  `/root/hf/hub/models--TalentPigs--affine-5ekxlcg3fx-abc/snapshots/dbfbb3e2…`
- Train launched `2026-08-08T23:58:49Z` pid=2729
  `train_lora.py` thought-only lr=5e-6 r16/α32 · 1059 ex · GPUs 6,7
- Verified ~1m later: CUDA_VISIBLE_DEVICES=6,7; weight load in progress;
  GPU6/7 ~33.6 GiB each; `train_config.json` written; log shows loading.
- post_train waiting on `/root/h105/train/train.done`; d203first watcher armed.
- thought_mask_verify: 1059/1059 ok (mean thought 195 chars).

## Fleet (same pass)
- F4 n80 b203 ~33/80; F7 n80 e203 ~26/80; F9 n80 d203 1/6 (teacher sampling,
  no progress file yet; engines 200). Burn ~$151.5/h.

## Next
Await train→merge→chall→n80. Screen m>+0.015 → CONFIRM k=4.
