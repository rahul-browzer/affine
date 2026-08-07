# H18 dud pod (zesty-hawk-bc) — 2026-08-07T14:57Z

- Rented as `mine-h18-1` @$5.66/h labeled 8×H200 (`gpu_count:8` in API).
- `nvidia-smi -L` showed **2** H200s. King/chall on CUDA 2–5 died:
  `NVMLError_InvalidArgument` → `Qwen3_5MoeForConditionalGeneration failed to be inspected`.
- Merge completed on dud (`/root/merges/h18-tp75`, OK_NON_IDENTICAL) but unusable.
- Spent ~$2.05; `lium rm mine-h18-1` (confirmed name prefix).
- Replaced with `golden-comet-e1` @$28/h; verified COUNT=8 before upload.
- Pipeline relaunched 2026-08-07T14:58:15Z via `upload_and_launch.sh`.
