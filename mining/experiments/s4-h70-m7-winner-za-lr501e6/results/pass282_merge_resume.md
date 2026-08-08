# Pass 282 — H70 merge salvage + chall relaunch

## Finding
`post_train_pipeline.sh` completed merge (shards+visual, `weight_identical=false`,
finished 10:08:37Z) then aborted `rc=127` with
`line 134: --out: command not found` — never wrote `h70_merge.done` /
`chall_serve.done`. Root cause: pass279 `retarget_king_pass279.sh` **sed-patched
the running** `post_train_pipeline.sh` at 09:59Z (bash offset; LESSONS already
forbids editing a live script).

## Actions (pod cosmic-raven-9e)
1. Wrote `/root/logs/h70_merge.done`; cleared `h70_pipeline.aborted`.
2. Identity: vs m7 base + Tok king both `identical=false` →
   `/root/affine_data/h70_identity.json`.
3. HF salvage push: adapter `unconst/Affine-5czsc2fc98-h70-lora` + merged
   `unconst/Affine-5czsc2fc98-h70-merged` (TTL insurance, not submission).
4. `nohup relaunch_chall_pass264.sh` pid=14467 (attempt1 settle→serve).
5. Retarget279 pid=11353 still waiting on `chall_serve.done` → will swap
   :8001 TalentPigs→Tok331102@eb8bf9a after chall is promptable.

## Next
chall_serve.done → Tok king promptable → n80 vs Tok → `h70_decision.json`.
