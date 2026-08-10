# R1 result log

## p1848 — crown bootstrap launched
- Pod: `mine-crown-1` / lunar-orbit-50 / `ssh root@86.38.182.50 -p 40300`
- Uploaded Triton tar sha `e55237b16dee…` + `restore_warm_stack.sh` + `/root/mine.env`
- `nohup` restore pid **1305** @ 2026-08-10T16:14:32Z
- Poll: `ssh … 'cat /root/logs/warm_stack_ready.done; curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8000/v1/models'` (expect READY + 200/200/200)
- Next: wait PROMPTABLE → wire Reason-only n80 sim vs Tok af10
