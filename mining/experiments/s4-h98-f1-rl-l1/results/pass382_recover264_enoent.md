# H98/F1 pass382 — recover264 after load-time Triton ENOENT

## Symptom
- Chall bare `TRITON_CACHE_DIR=/root/.triton/cache/chall` loading since 21:17Z.
- @21:22:19Z Worker_TP1 ImportError:
  `…/4WD73Z7EMOCJDY7WKKRS2AVS7UNKOY7Y…/__triton_launcher….so: No such file`
- `:8002` stayed 000 → preempt264 (rearmed p381) cannot fire (waits health=200).

## Action
- Fired `relaunch_chall_pass264.sh` pid=39252 @21:22:56Z (manual; not via preempt).
- Recover reaped GPUs 4,5; attempt 1 logged **`no king TCACHE to seed`**
  (script only checked bare `/root/.triton/cache/king`; live king is
  `/root/.triton/isolated/h98_king_p332_1786218158_17737` n_so=19).
- Mid-load rsync king→chall isolated @21:24:21Z: n_so **0→19** before JIT.
  Chall TCACHE=`…/h98_chall_p260_a1_1786224218_39252` (writable).
- Local `relaunch_chall_pass264.sh` patched to seed from live :8001
  `TRITON_CACHE_DIR` (not scp'd onto running recover — LESSONS bash-offset).

## Next
Await recover264 DONE → completions → n80 vs Tok. If a1 fails, scp patched
script before a2/a3.
