# F15 p436 — recover264 a203 rearm fix

- recover264 DONE @01:46:56Z rearmed `watch_n80_retry` → bare `retry_h110_n80.sh` (a203).
- Live d203first (pid 1003) had already FP'd d203 @01:43:34Z and launched e203 @01:45:55Z.
- p436: killed a203 watcher 26937; armed d203first watcher 27125; left e203 duel intact.
- Patched on-pod + local `relaunch_chall_pass264.sh` → d203first (also F10/F12/F13 templates).
