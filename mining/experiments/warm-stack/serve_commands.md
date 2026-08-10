# warm-stack serve commands (mine-f45-1 @ 2026-08-09T12:04Z)

Captured from live `/proc/<pid>/cmdline` + environ. Engines **200/200/200**.
H64 chall swap DONE p541 (`/root/logs/h64_chall_swap.done`).

## Layout
| role | port | GPUs | util | TRITON_CACHE_DIR | model |
|---|---|---|---|---|---|
| teacher | 8000 | 0,1 | 0.80 | `/root/.triton/cache/teacher` | `zai-org/GLM-4.5-Air-FP8` |
| king | 8001 | 2,3 | 0.80 | `/root/.triton/cache/king` | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a254f71faaa439e8abc3cfba572c53` |
| chall | 8002 | 4,5 | **0.72** | `/root/.triton/cache/chall` | `/tmp/h64_merged` ← `unconst/Affine-5czsc2fc98-h64-merged@4ebe10443f7f` |

Common env (do **not** bake secrets into scripts; use `/root/mine.env`):
`VLLM_USE_DEEP_GEMM=0 VLLM_USE_FLASHINFER_SAMPLER=0 VLLM_ALLREDUCE_USE_FLASHINFER=0 VLLM_MOE_USE_DEEP_GEMM=0 VLLM_USE_FLASHINFER_MOE_FP16=0 VLLM_USE_FLASHINFER_MOE_FP4=0 VLLM_USE_FLASHINFER_MOE_FP8=0 HF_HUB_ENABLE_HF_TRANSFER=1 HF_XET_HIGH_PERFORMANCE=1 HF_HOME=/root/hf CUDA_HOME=/root/venv/lib/python3.12/site-packages/nvidia/cu13 CUDA_PATH=$CUDA_HOME`

## Exact argv

```bash
# teacher
CUDA_VISIBLE_DEVICES=0,1 TRITON_CACHE_DIR=/root/.triton/cache/teacher \
  /root/venv/bin/vllm serve zai-org/GLM-4.5-Air-FP8 \
  --port 8000 --tensor-parallel-size 2 --max-model-len 65536 \
  --gpu-memory-utilization 0.80 --max-num-batched-tokens 8192 \
  --attention-backend FLASH_ATTN --attention-config.use_trtllm_attention 0 \
  --compilation-config.pass_config.fuse_allreduce_rms false \
  --moe-backend triton \
  --additional-config '{"gdn_prefill_backend": "triton"}'

# king
CUDA_VISIBLE_DEVICES=2,3 TRITON_CACHE_DIR=/root/.triton/cache/king \
  /root/venv/bin/vllm serve Tok331102/affine-5EqYW8McUc-af10 \
  --port 8001 --tensor-parallel-size 2 --max-model-len 65536 \
  --gpu-memory-utilization 0.80 --max-num-batched-tokens 8192 \
  --attention-backend FLASH_ATTN --attention-config.use_trtllm_attention 0 \
  --compilation-config.pass_config.fuse_allreduce_rms false \
  --moe-backend triton \
  --additional-config '{"gdn_prefill_backend": "triton"}' \
  --revision eb8bf9a356a254f71faaa439e8abc3cfba572c53

# chall = H64 r=18 merged (util 0.72)
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  /root/venv/bin/vllm serve /tmp/h64_merged \
  --port 8002 --tensor-parallel-size 2 --max-model-len 65536 \
  --gpu-memory-utilization 0.72 --max-num-batched-tokens 8192 \
  --attention-backend FLASH_ATTN --attention-config.use_trtllm_attention 0 \
  --compilation-config.pass_config.fuse_allreduce_rms false \
  --moe-backend triton \
  --additional-config '{"gdn_prefill_backend": "triton"}'
```

## Restore Triton cache on a fresh pod

```bash
mkdir -p /root/.triton
tar -C /root/.triton -xzf warm_stack_triton_cache_p539.tar.gz
# expect: cache/{teacher,king,chall} with n_so ≈ 8/24/24
# p541 H64 swap left chall n_so=24 — no re-tar needed
```

## Notes
- Chall is H64 winner-zA r=18 merged at `/tmp/h64_merged` (HF sha `4ebe10443f7f`).
- No isolated TCACHE dirs; bare role dirs under `/root/.triton/cache/`.
- Template: `daturaai/pytorch` · 8×H200 · venv at `/root/venv`.
