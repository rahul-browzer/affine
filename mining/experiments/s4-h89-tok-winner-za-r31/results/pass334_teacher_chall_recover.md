# Pass 334 — H89 teacher re-fire + chall recover

- Teacher p332 launch died @16:24:46Z: Triton ENOENT
  `teacher_p332_…/6ARJ3DUS…/triton_poi_fused_mul_silu_slice_0.json`
  (ghost during inductor compile). King PROMPTABLE @16:26:38Z isolated.
- Orphan `VLLM::Worker` 18119/18120 (fds on nvidia0–3, 0 MiB) killed;
  teacher relaunched `relaunch_teacher_pass332.sh` → pid25820 loading.
- Side effect @16:31:56Z: chall EngineDead (`Executor failed`) on GPUs 4,5
  → fired `relaunch_chall_pass264.sh` as pass334 (pid26043). Leave king.
- Do not completions-probe during settle. Next: :8000+:8001+:8002
  promptable → n80 + arm mid304.
