# H90 pass338 — merge → bare preempt → recover264 → n80 live

## Merge
- `merge_lora` DONE @ 2026-08-08T16:47:26Z; elapsed 406.9s
- `weight_identical=false`; vs tok_init + vs Tok king both `identical=false`
- visual restored: `model-visual-restored.safetensors` 852 MiB; phantom index 333 → extract 31 keys
- HF push background: `unconst/Affine-5czsc2fc98-h90-lora` + `…-h90-merged`

## Bare chall → preempt264
- post_train chall-only serve util=0.72 `TRITON_CACHE_DIR=/root/.triton/cache/chall` @16:48:02Z
- health=200 @16:54:20Z (torch.compile + multimodal warmup)
- preempt264 @16:54:27Z: BARE → `relaunch_chall_pass264.sh` pid=17786 (expected)

## recover264
- isolated TCACHE `/root/.triton/isolated/h90_chall_p260_a1_1786208110_17786`
- health=200 @ poll=33; diverse writable warmups → freeze n_so=22 mode=555
- triple-promptable; rearmed form pid=20773 + n80 watcher pid=20779 @17:02:15Z
- mid304 stayed up (pid=12615); entered watch loop when sim alive

## n80
- attempt 1/3 `block_hash=a203…` vs Tok331102@eb8bf9a; chall=`/root/h90/merged`
- t/k/c=200; sim pid=20948; mid304 watching
