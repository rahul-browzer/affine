# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F2/F3 **REFUTE**.
**F1+F4+F6+F7+F8+F9 live**. No submit. Best vs Tok: H81 +0.0088.
King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$184,003** · cum ~$13,315 · **avail ~$174.0k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$213/h** (6 mine-*) ≪ $833/h · free slots **14** |
| F1 | n80 vs Tok **9/80** (engines 200) |
| F4 | Tok Range shard2 ~75%; teacher 200; king killed |
| F6 | recover a2 mid-load; peer-seeded 19 so from F7 |
| F7 | n80 vs Tok **live** (engines 200; recover DONE) |
| F8 | RL train live (~step60+/200) |
| F9 | kevin DL ~68 GiB (11/12; hub1.27 incomplete) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f1-1 | brave-hawk-5a | 86.38.238.54:40099 | ~07:05Z+1d | F1 n80 vs Tok |
| mine-f4-1 | calm-wolf-30 | 204.9.206.243:40099 | ~07:18Z+1d | F4 Tok Range→serve |
| mine-f6-1 | noble-shark-14 | 152.236.142.237:40300 | ~08:42Z+1d | F6 a2 seed→n80 |
| mine-f7-1 | lunar-shark-87 | 152.236.142.232:40311 | ~08:52Z+1d | F7 n80 vs Tok |
| mine-f8-1 | brave-matrix-d8 | 152.236.142.236:40309 | ~09:04Z+1d | H103 RL train |
| mine-f9-1 | lunar-fox-0a | 38.255.28.18:20099 | ~09:12Z+1d | H104 kevin DL |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP×ks/m7×ks/union/lr/ep≥2/winner-zA/−0.004/Tok r9–31/**F2**/**F3**/king-init refs.
Open: H98/F1, H100/F4, H101/F6, H102/F7, H103/F8, H104/F9.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28; never `pkill -f`.
recover264=chall; king-only relaunch; seed chall from live king TCACHE.
**F4:** await `tok331102.done` → king util=0.72 + chall → n80.
**F6:** a1 ghost ENOENT on `6YKNXZRS…` (absent from 16-so seed); a2 peer-seeded 19.
**F1/F7:** n80 live — do not second-launch recover.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F6** await a2 :8002=200 → warm/freeze → n80 (re-seed if a3).
2. **F1/F7** await n80 margins vs Tok.
3. **F4** await `tok331102.done` → king+chall re-serve → n80.
4. **F8** RL→merge→n80; **F9** kevin DL→train→merge→n80.
