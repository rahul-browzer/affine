#!/usr/bin/env python3
"""Parallel HF snapshot_download for Tok af10 + GLM teacher on mine-r3-grpo-1."""
from __future__ import annotations

import os
import sys
import time
import traceback
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

from huggingface_hub import snapshot_download

os.environ.setdefault("HF_HUB_ENABLE_HF_TRANSFER", "1")
os.environ.setdefault("HF_XET_HIGH_PERFORMANCE", "1")

token = os.environ["HF_TOKEN"]
log_path = Path("/root/logs/parallel_dl.log")
log_path.parent.mkdir(parents=True, exist_ok=True)
log = open(log_path, "a", buffering=1)


def ts() -> str:
    return time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())


def dl(name: str, repo: str, rev: str | None = None) -> tuple[str, str]:
    print(f"[{ts()}] DOWNLOAD {name} start {repo} {rev or ''}", file=log, flush=True)
    kwargs: dict = {"repo_id": repo, "token": token}
    if rev:
        kwargs["revision"] = rev
    path = snapshot_download(**kwargs)
    print(f"[{ts()}] DOWNLOAD {name} done -> {path}", file=log, flush=True)
    return name, path


def main() -> int:
    jobs = [
        (
            "tok-init",
            "Tok331102/affine-5EqYW8McUc-af10",
            "eb8bf9a356a254f71faaa439e8abc3cfba572c53",
        ),
        ("teacher", "zai-org/GLM-4.5-Air-FP8", None),
    ]
    ok: dict[str, str] = {}
    errs: list[tuple[str, str]] = []
    with ThreadPoolExecutor(max_workers=2) as ex:
        futs = {ex.submit(dl, n, r, rev): n for n, r, rev in jobs}
        for fut in as_completed(futs):
            name = futs[fut]
            try:
                n, path = fut.result()
                ok[n] = path
            except Exception as e:
                errs.append((name, repr(e)))
                print(
                    f"[{ts()}] DOWNLOAD {name} FAIL {type(e).__name__}: {e}",
                    file=log,
                    flush=True,
                )
                traceback.print_exc(file=log)

    if "tok-init" in ok:
        Path("/root/logs/tok_init.done").write_text(ok["tok-init"] + "\n")
        Path("/root/logs/tok331102.done").write_text(ok["tok-init"] + "\n")
    if "teacher" in ok:
        Path("/root/logs/teacher.done").write_text(ok["teacher"] + "\n")

    if errs or set(ok) != {"tok-init", "teacher"}:
        print(f"[{ts()}] PARALLEL_DL_FAIL ok={list(ok)} errs={errs}", file=log, flush=True)
        return 1

    print(
        f"[{ts()}] ALL_DOWNLOADS_OK tok={ok['tok-init']} teacher={ok['teacher']}",
        file=log,
        flush=True,
    )
    Path("/root/logs/crown_stage_done.stamp").write_text(ts() + " hf_parallel_dl\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
