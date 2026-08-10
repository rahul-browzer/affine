# R1 — Reason distill / crown bootstrap

## Goal
Raise paired Reason margin vs live king Tok af10 above 3·SE (~1.5× headroom).

## Stage 3 gate (this pod)
`mine-crown-1` serves teacher + king + challenger; n=80 Reason duel sim emits
paired margin + SE.

## Bootstrap (p1848)
- Restore warm stack: teacher GLM-Air :8000, Tok af10 :8001, H64 chall :8002
- Script: `experiments/warm-stack/restore_warm_stack.sh` + Triton tar p539
- Poll: `/root/logs/warm_stack_ready.done` and engines 200/200/200

## Decision rule (pre-register before n80)
Submit only if paired mean(Reason_c − Reason_k) > **1.5 × (3·SE)** on a fresh
slice. Absolute Reason alone is not enough.
