#!/usr/bin/env python3
"""Host-side Reason stamp bridge for chal-00467..471 + 480.

Crown pod often gets Cloudflare 403 on affine.io/api/v1/history (Lium egress),
so on-pod history fast-path silently no-ops and unservable verdicts never stamp.
This process polls history from the mining host (curl works) and scp-pushes
chal00XXX_reason.json + watch done lines onto mine-crown-1.

No GPU. No submit. Safe to overlap R2ag n80.
"""
from __future__ import annotations

import json
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent
ART = ROOT / "artifacts"
LOG = ROOT / "logs" / "host_history_stamp_bridge.log"
PIDF = ROOT / "logs" / "host_history_stamp_bridge.pid"

SSH_HOST = "root@95.133.253.90"
SSH_PORT = "40099"
SSH = [
    "ssh",
    "-o",
    "BatchMode=yes",
    "-o",
    "StrictHostKeyChecking=accept-new",
    "-o",
    "ConnectTimeout=15",
    "-p",
    SSH_PORT,
    SSH_HOST,
]
SCP = [
    "scp",
    "-o",
    "BatchMode=yes",
    "-o",
    "StrictHostKeyChecking=accept-new",
    "-o",
    "ConnectTimeout=15",
    "-P",
    SSH_PORT,
]

KING_REPO = "Tok331102/affine-5EqYW8McUc-af10"
KING_REV = "eb8bf9a356a254f71faaa439e8abc3cfba572c53"

# challenge_id → outstem (matches on-pod watchers / R2z–ad gates)
TARGETS = {
    "chal-00467": "chal00467",
    "chal-00468": "chal00468",
    "chal-00469": "chal00469",
    "chal-00470": "chal00470",
    "chal-00471": "chal00471",
    "chal-00480": "chal00480",  # queue ammazon sbs-v1 (p2011)
}


def log(msg: str) -> None:
    line = f"[host-hist] {time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())} {msg}"
    print(line, flush=True)
    LOG.parent.mkdir(parents=True, exist_ok=True)
    with LOG.open("a") as f:
        f.write(line + "\n")


def curl_json(url: str) -> dict:
    raw = subprocess.check_output(
        ["curl", "-sS", "-A", "mine-host-history-bridge/1", "--max-time", "30", url],
        text=True,
    )
    return json.loads(raw)


def stamp_from_item(chal: str, item: dict) -> dict | None:
    rej = item.get("rejection_reason") or ""
    if item.get("accepted") is False and rej and item.get("margin") is None and item.get("se") is None:
        utc = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
        return {
            "challenge_id": chal,
            "king_repo": KING_REPO,
            "king_revision": KING_REV,
            "challenger_repo": item.get("repo"),
            "challenger_revision": item.get("revision"),
            "published_margin": None,
            "published_z": None,
            "published_formula": None,
            "challenger_wins": False,
            "accepted": False,
            "rejection_reason": rej,
            "has_artifact": False,
            "reason_margin": None,
            "reason_se": None,
            "reason_z": None,
            "three_se": None,
            "headroom_vs_3se": None,
            "n_paired": 0,
            "king_match": True,
            "scored_at": utc,
            "source": "host_history_api_unservable",
            "source_url": "https://affine.io/api/v1/history",
            "note": "host bridge — pod CF-blocked on affine.io history",
        }
    margin, se = item.get("margin"), item.get("se")
    if margin is None or se is None:
        return None
    try:
        margin_f, se_f = float(margin), float(se)
    except (TypeError, ValueError):
        return None
    three_se = 3.0 * se_f
    hr = (margin_f / three_se) if three_se > 0 else None
    z = (margin_f / se_f) if se_f > 0 else None
    return {
        "challenge_id": chal,
        "king_repo": KING_REPO,
        "king_revision": KING_REV,
        "challenger_repo": item.get("repo"),
        "challenger_revision": item.get("revision"),
        "published_margin": margin_f,
        "published_z": item.get("z"),
        "published_formula": None,
        "challenger_wins": item.get("challenger_wins"),
        "accepted": item.get("accepted"),
        "rejection_reason": rej or None,
        "reason_margin": margin_f,
        "reason_se": se_f,
        "reason_z": z,
        "three_se": three_se,
        "headroom_vs_3se": hr,
        "n_paired": item.get("n_paired_turns"),
        "king_match": True,
        "scored_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "source": "host_history_api",
        "source_url": "https://affine.io/api/v1/history",
        "note": "host bridge — pod CF-blocked on affine.io history",
    }


def pod_already_stamped(outstem: str) -> bool:
    remote_out = f"/root/affine_data/{outstem}_reason.json"
    remote_done = f"/root/logs/watch_{outstem}_reason.done"
    try:
        subprocess.check_call(
            SSH + [f"test -f {remote_out} && test -f {remote_done}"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        return True
    except subprocess.CalledProcessError:
        return False


def push_stamp(outstem: str, stamp: dict) -> None:
    ART.mkdir(parents=True, exist_ok=True)
    local = ART / f"{outstem}_reason.json"
    local.write_text(json.dumps(stamp, indent=2) + "\n")
    hr = stamp.get("headroom_vs_3se")
    line = (
        f"OK {stamp['scored_at']} hr={hr} margin={stamp.get('reason_margin')} "
        f"n={stamp.get('n_paired')} repo={stamp.get('challenger_repo')} "
        f"src={stamp.get('source')}"
    )
    local_done = ART / f"watch_{outstem}_reason.done"
    local_done.write_text(line + "\n")

    remote_out = f"/root/affine_data/{outstem}_reason.json"
    remote_done = f"/root/logs/watch_{outstem}_reason.done"
    subprocess.check_call(SCP + [str(local), f"{SSH_HOST}:{remote_out}"])
    subprocess.check_call(SCP + [str(local_done), f"{SSH_HOST}:{remote_done}"])
    meta = {
        "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "outstem": outstem,
        "remote_out": remote_out,
        "headroom_vs_3se": hr,
        "challenger_repo": stamp.get("challenger_repo"),
        "source": stamp.get("source"),
    }
    (ART / f"host_hist_push_{outstem}.json").write_text(json.dumps(meta, indent=2) + "\n")
    log(f"PUSHED {outstem} hr={hr} repo={stamp.get('challenger_repo')}")


def poll_once(pending: set[str]) -> None:
    # Broad recent window — q= filter is nice-to-have; scan items.
    payload = curl_json("https://affine.io/api/v1/history?limit=40")
    by_chal: dict[str, dict] = {}
    for item in payload.get("items") or []:
        cid = item.get("challenge_id")
        if cid in pending and item.get("event") == "verdict" and cid not in by_chal:
            by_chal[cid] = item
    for chal, item in by_chal.items():
        outstem = TARGETS[chal]
        if pod_already_stamped(outstem):
            log(f"skip {chal}: pod already stamped")
            pending.discard(chal)
            continue
        stamp = stamp_from_item(chal, item)
        if stamp is None:
            log(f"skip {chal}: verdict without score/unservable shape")
            continue
        push_stamp(outstem, stamp)
        pending.discard(chal)


def main() -> int:
    import os

    LOG.parent.mkdir(parents=True, exist_ok=True)
    PIDF.write_text(f"{os.getpid()}\n")
    pending = set(TARGETS)
    # Drop already-stamped targets up front.
    for chal, outstem in list(TARGETS.items()):
        if pod_already_stamped(outstem):
            log(f"init skip {chal}: already on pod")
            pending.discard(chal)
    log(f"start pending={sorted(pending)}")
    if not pending:
        log("nothing to do")
        return 0
    for i in range(1, 2880):
        try:
            poll_once(pending)
        except Exception as e:
            if i % 6 == 0:
                log(f"iter={i} err={type(e).__name__}: {e}")
        if not pending:
            log("all targets stamped")
            return 0
        if i % 12 == 0:
            log(f"iter={i} still pending={sorted(pending)}")
        time.sleep(15)
    log("TIMEOUT")
    return 2


if __name__ == "__main__":
    sys.exit(main())
