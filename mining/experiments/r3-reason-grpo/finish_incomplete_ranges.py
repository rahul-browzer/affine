#!/usr/bin/env python3
"""Rewrite incomplete HF blob ranges (stuck worker recovery), then stamp tok_init.done."""
from __future__ import annotations
import os, sys, time, threading
from pathlib import Path
import httpx
from huggingface_hub import hf_hub_url
from huggingface_hub.utils import build_hf_headers

REPO = "Tok331102/affine-5EqYW8McUc-af10"
REV = "eb8bf9a356a254f71faaa439e8abc3cfba572c53"
FNAME = "model-00002-of-00002.safetensors"
OUT = Path(
    "/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/blobs/"
    "da0b5fc3bc074ae0cda8599d4e1b96cfed5817518b87f82dc18393398123d9aa"
)
PART = OUT.with_suffix(OUT.suffix + ".partdata")
SNAP = Path(
    "/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/"
    "eb8bf9a356a254f71faaa439e8abc3cfba572c53"
)
SIZE = 35112732728
# Original 16-way layout; rewrite only ranges that look incomplete.
ORIG_N = 16
ORIG_CHUNK = (SIZE + ORIG_N - 1) // ORIG_N
# Force-rewrite w0 (observed stall); optional extra via env FORCE_RANGES=0,3
FORCE = os.environ.get("FORCE_RANGES", "0")
SUBWORK = int(os.environ.get("SUBWORK", "8"))
LOG = Path("/root/logs/finish_incomplete_ranges.log")


def log(msg: str) -> None:
    line = f"{time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())} {msg}"
    print(line, flush=True)
    LOG.parent.mkdir(parents=True, exist_ok=True)
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


def download_span(token: str, start: int, end: int) -> None:
    """Parallel sub-range rewrite of [start, end)."""
    cdn = resolve_url(token)
    length = end - start
    n = min(SUBWORK, max(1, length // (32 * 1024 * 1024)))
    sub = (length + n - 1) // n
    err: list[str] = []
    done = [0]
    lock = threading.Lock()
    t0 = time.time()

    def worker(i: int, a: int, b: int) -> None:
        url = cdn
        headers = {"Range": f"bytes={a}-{b - 1}"}
        try:
            with httpx.Client(
                timeout=httpx.Timeout(60.0, read=300.0), follow_redirects=True
            ) as c:
                for attempt in range(10):
                    try:
                        with c.stream("GET", url, headers=headers) as r:
                            if r.status_code in (401, 403, 404):
                                url = resolve_url(token)
                                headers = {"Range": f"bytes={a}-{b - 1}"}
                                continue
                            if r.status_code not in (200, 206):
                                raise RuntimeError(f"status {r.status_code}")
                            pos = a
                            with PART.open("r+b") as f:
                                f.seek(pos)
                                for chunk in r.iter_bytes(1024 * 1024):
                                    f.write(chunk)
                                    pos += len(chunk)
                                    with lock:
                                        done[0] += len(chunk)
                            if pos != b:
                                raise RuntimeError(f"short {pos - a} != {b - a}")
                        return
                    except Exception:
                        if attempt == 9:
                            raise
                        time.sleep(1 + attempt)
                        url = resolve_url(token)
                        headers = {"Range": f"bytes={a}-{b - 1}"}
        except Exception as e:
            err.append(f"sub{i}:{e}")

    threads = []
    for i in range(n):
        a = start + i * sub
        b = min(end, a + sub)
        if a >= end:
            break
        th = threading.Thread(target=worker, args=(i, a, b), daemon=True)
        th.start()
        threads.append(th)

    last = 0
    while any(t.is_alive() for t in threads):
        time.sleep(3)
        cur = done[0]
        rate = (cur - last) / 3 / 1e6
        log(
            f"span {start}-{end} {cur / 1e9:.2f}/{(end - start) / 1e9:.2f}GB "
            f"+{rate:.1f}MB/s"
        )
        last = cur
        if err:
            break
    for t in threads:
        t.join()
    if err:
        raise RuntimeError("; ".join(err))
    log(f"span DONE {start}-{end} in {time.time() - t0:.0f}s")


def finalize(token: str) -> None:
    if not PART.exists() or PART.stat().st_size != SIZE:
        raise RuntimeError(f"bad part size {PART.stat().st_size if PART.exists() else None}")
    PART.replace(OUT)
    link = SNAP / FNAME
    if not (link.is_symlink() or link.exists()):
        SNAP.mkdir(parents=True, exist_ok=True)
        link.symlink_to(os.path.relpath(OUT, SNAP))
    prep = SNAP / "preprocessor_config.json"
    if not prep.exists():
        src = SNAP / "processor_config.json"
        if src.exists():
            prep.write_bytes(src.read_bytes())
            log("wrote preprocessor_config.json")
    snap_path = str(SNAP)
    Path("/root/logs/tok_init.done").write_text(snap_path + "\n")
    Path("/root/logs/tok331102.done").write_text(snap_path + "\n")
    log(f"DONE tok_init -> {snap_path}")


def main() -> int:
    token = os.environ.get("HF_TOKEN") or ""
    if not token:
        log("FATAL no HF_TOKEN")
        return 2
    if OUT.exists() and not PART.exists():
        log(f"blob already final at {OUT}; stamping")
        finalize(token)
        return 0
    if not PART.exists():
        log(f"FATAL missing {PART}")
        return 1
    ranges = [int(x) for x in FORCE.split(",") if x.strip() != ""]
    log(f"rewriting ranges {ranges} SUBWORK={SUBWORK}")
    for wi in ranges:
        start = wi * ORIG_CHUNK
        end = min(SIZE, start + ORIG_CHUNK)
        download_span(token, start, end)
    finalize(token)
    return 0


if __name__ == "__main__":
    sys.exit(main())
