# H98 / F1 — pass 362 king332 re-fire

**UTC:** 2026-08-08T19:42:36Z
**Pod:** mine-f1-1 brave-hawk-5a `86.38.238.54:40099`

## Prior failure
- Prior king332 @19:35:39Z aborted @19:41:50Z poll=35: Triton launcher ENOENT
  `…/h98_king_p332_1786217742_13900/WGUL55MZARPIFIN3W47CL7NHVRD7EG7VOWZO4F3UGFHXJ36ADSZQ/__triton_launcher….so`
- `:8001=000`; GPUs 2,3 free; teacher `:8000=200`; train_rl still on GPUs 6,7.

## Action
- Re-fired `king_recover_pass332.sh` (nohup pid=17737).
- Fresh isolated TCACHE `/root/.triton/isolated/h98_king_p332_1786218158_17737` util=0.72.
- King vLLM pid=17854 started @19:43:03Z on GPUs 2,3.
- Train pid=3188 left alone (TRAIN_OK).

## Next
- Await `:8001=200` + completions-promptable → continue post_train → merge → n80.
- Do not touch chall; do not rm pod.
