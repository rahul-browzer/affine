# p494 — F37 train_rl_l2 launched

- Teacher :8000=200 @07:21:02Z (CUDA graphs done); bootstrap saw up at iter=25.
- `TRAIN_LAUNCHED` pid=11123 @07:21:35Z; BOOTSTRAP_DONE train=11123 post=11129.
- Config: reinforce_teacher_l2, lr=5e-6, r=16/α32, G=2, max_steps=200, GPUs 6,7.
- Data: kept=189/406 (`winner_za_high_l1.jsonl`); teacher_model=zai-org/GLM-4.5-Air-FP8.
- @07:22Z: loading Tok base weights (~12% in log); GPU6/7 ~33.5 GiB; king also loading GPUs2,3.
- Next: wait `trainer_state.json` global_step>0 / reward lines in `h132_train.nohup`.
