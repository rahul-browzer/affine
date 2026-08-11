#!/usr/bin/env python3
"""Multi-connection range download into HF blob path; stamp tok_init.done."""
from __future__ import annotations
import os, sys, time, threading
from pathlib import Path
import httpx
from huggingface_hub import hf_hub_url
from huggingface_hub.utils import build_hf_headers

REPO = "Tok331102/affine-5EqYW8McUc-af10"
REV = "eb8bf9a356a254f71faaa439e8abc3cfba572c53"
FNAME = "model-00002-of-00002.safetensors"
OUT = Path("/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/blobs/da0b5fc3bc074ae0cda8599d4e1b96cfed5817518b87f82dc18393398123d9aa")
SNAP = Path("/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53")
NWORK = int(os.environ.get("NWORK", "16"))
SIZE = 35112732728  # from HEAD x-linked-size
LOG = Path("/root/logs/fast_range_dl.log")

def log(msg: str) -> None:
    line = f"{time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())} {msg}"
    print(line, flush=True)
    with LOG.open("a") as f:
        f.write(line + "\n")

def resolve_url(token: str) -> str:
    url = hf_hub_url(repo_id=REPO, filename=FNAME, revision=REV)
    headers = build_hf_headers(token=token)
    with httpx.Client(follow_redirects=False, timeout=60) as c:
        r = c.head(url, headers=headers)
        if r.status_code in (301, 302, 303, 307, 308):
            return r.headers["location"]
        r.raise_for_status()
        return url

def main() -> int:
    token = os.environ.get("HF_TOKEN") or ""
    if not token:
        log("FATAL no HF_TOKEN")
        return 2
    OUT.parent.mkdir(parents=True, exist_ok=True)
    part = OUT.with_suffix(OUT.suffix + ".partdata")
    # preallocate
    if not part.exists() or part.stat().st_size != SIZE:
        log(f"preallocate {part} size={SIZE}")
        with part.open("wb") as f:
            f.truncate(SIZE)
    cdn = resolve_url(token)
    log(f"cdn={cdn[:120]}... nwork={NWORK}")
    chunk = (SIZE + NWORK - 1) // NWORK
    err: list[str] = []
    done = [0]
    lock = threading.Lock()
    t0 = time.time()

    def worker(i: int, start: int, end: int) -> None:
        try:
            # refresh URL periodically via shared; use initial + retry
            url = cdn
            headers = {"Range": f"bytes={start}-{end-1}"}
            # CDN signed URLs usually don't need auth
            with httpx.Client(timeout=httpx.Timeout(60.0, read=300.0), follow_redirects=True) as c:
                for attempt in range(8):
                    try:
                        with c.stream("GET", url, headers=headers) as r:
                            if r.status_code in (401, 403, 404):
                                url = resolve_url(token)
                                headers = {"Range": f"bytes={start}-{end-1}"}
                                continue
                            if r.status_code not in (200, 206):
                                raise RuntimeError(f"status {r.status_code}")
                            pos = start
                            with part.open("r+b") as f:
                                f.seek(pos)
                                for b in r.iter_bytes(1024 * 1024):
                                    f.write(b)
                                    pos += len(b)
                                    with lock:
                                        done[0] += len(b)
                            if pos != end:
                                raise RuntimeError(f"short {pos-start} != {end-start}")
                        return
                    except Exception as e:
                        if attempt == 7:
                            raise
                        time.sleep(2 + attempt)
                        url = resolve_url(token)
                        headers = {"Range": f"bytes={start}-{end-1}"}
        except Exception as e:
            err.append(f"w{i}:{e}")

    threads = []
    for i in range(NWORK):
        start = i * chunk
        end = min(SIZE, start + chunk)
        if start >= SIZE:
            break
        th = threading.Thread(target=worker, args=(i, start, end), daemon=True)
        th.start()
        threads.append(th)

    last = 0
    while any(t.is_alive() for t in threads):
        time.sleep(5)
        cur = done[0]
        dt = time.time() - t0
        rate = (cur - last) / 5 / 1e6
        tot_rate = cur / max(dt, 1) / 1e6
        log(f"progress {cur/1e9:.2f}/{SIZE/1e9:.2f}GB +{rate:.1f}MB/s avg={tot_rate:.1f}MB/s")
        last = cur
        if err:
            break
    for t in threads:
        t.join()
    if err:
        log("FATAL " + "; ".join(err))
        return 1
    if part.stat().st_size != SIZE:
        log(f"FATAL size {part.stat().st_size} != {SIZE}")
        return 1
    part.replace(OUT)
    # ensure snapshot link
    link = SNAP / FNAME
    if link.is_symlink() or link.exists():
        pass
    else:
        link.symlink_to(os.path.relpath(OUT, SNAP))
    # preprocessor if missing (Tok af10)
    prep = SNAP / "preprocessor_config.json"
    if not prep.exists():
        src = SNAP / "processor_config.json"
        if src.exists():
            prep.write_bytes(src.read_bytes())
            log("wrote preprocessor_config.json from processor_config.json")
    snap_path = str(SNAP)
    Path("/root/logs/tok_init.done").write_text(snap_path + "\n")
    Path("/root/logs/tok331102.done").write_text(snap_path + "\n")
    log(f"DONE tok_init -> {snap_path} elapsed={time.time()-t0:.0f}s")
    return 0

if __name__ == "__main__":
    sys.exit(main())
