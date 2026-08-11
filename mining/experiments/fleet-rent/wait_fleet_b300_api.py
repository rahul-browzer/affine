#!/usr/bin/env python3
"""Fast fleet snatcher via Lium HTTP API (session-reused /executors).

One unfiltered GET /executors?gpu_count=8 per poll, then client-filter B300
(preferred) else B200. Avoids dual machine_names queries that 429 the key.

On stock: `lium up <executor_id> --name mine-* --ttl …` (keeps TTL/SSH path).
Never touches non-mine pods. Hard-stops if balance < $10k.

Critical: /pods API failure must NOT look like mine_count=0 (overshoots CAP).
"""
from __future__ import annotations

import configparser
import json
import os
import re
import subprocess
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

import requests

ROOT = Path("/home/const/subnet120")
EXP = ROOT / "mining/experiments/fleet-rent"
LOG = EXP / "logs/wait_fleet_b300.log"
PIDF = EXP / "logs/wait_fleet_b300.pid"
STAMP_DIR = EXP / "artifacts"

TTL = os.environ.get("TTL", "24h")
CAP = int(os.environ.get("MINE_CAP", "25"))
TARGET = int(os.environ.get("TARGET_MINES", "25"))
PARALLEL_N = int(os.environ.get("PARALLEL_N", "22"))
MAX_ITERS = int(os.environ.get("MAX_ITERS", "86400"))
PASS = int(os.environ.get("PASS", "2137"))
# Stay under Lium 429 while still beating CLI ls (~0.63s). 0.5s ≈ 2 Hz.
EMPTY_SLEEP = float(os.environ.get("EMPTY_SLEEP", "0.5"))
PODS_FAIL_SLEEP = float(os.environ.get("PODS_FAIL_SLEEP", "2.0"))

# Distinct axes (one pod each). Skip names already live.
QUEUE = [
    ("mine-r7-datafilt-1", "R7", "high-Reason data filter curriculum FT"),
    ("mine-r8-reinforce-1", "R8", "REINFORCE on Reason (full-rank / alt base)"),
    ("mine-r24-longctx-1", "R24", "Tok GRPO max_len=16384 max_new=1024 (≠ R3 6144/512)"),
    ("mine-r25-hitemp-1", "R25", "Tok GRPO temperature=1.2 (≠ R3 temp=0.8)"),
    ("mine-r26-lotemp-1", "R26", "Tok GRPO temperature=0.5 (≠ R3 0.8 / R25 1.2)"),
    ("mine-r27-bigg-1", "R27", "Tok GRPO group_size=16 (≠ R3 G=4 / R3b G=8+alt-lr)"),
    ("mine-r28-hilr-1", "R28", "Tok GRPO lr=2e-5 (≠ R3 5e-6; isolates LR vs R3b)"),
    ("mine-r29-hirank-1", "R29", "Tok GRPO lora_r=64 (≠ R3 r=16; isolates rank vs R3b)"),
    ("mine-r30-hialpha-1", "R30", "Tok GRPO lora_alpha=128 r=16 (≠ R3 α=32; isolates α vs R29)"),
    ("mine-r31-nodrop-1", "R31", "Tok GRPO lora_dropout=0.0 (≠ R3 0.05; isolates dropout)"),
    ("mine-r32-kl-1", "R32", "Tok GRPO kl_coef=0.02 vs base (≠ R3 kl=0; isolates KL)"),
    ("mine-r9-teacher-zc-1", "R9", "teacher-z_C imitation / format prior"),
    ("mine-r5-nonking-2", "R5b", "Talent/kevin non-king base FT"),
    ("mine-r10-merge-rl-1", "R10", "merge+RL hybrid Reason"),
    ("mine-r6-fmt-2", "R6b", "long-thought vs short-thought ablate"),
    ("mine-r11-odpo-1", "R11", "online DPO on live teacher Reason"),
    ("mine-r12-bon-1", "R12", "Best-of-N CE on live teacher Reason"),
    ("mine-r13-odpo-1", "R13", "offline DPO on duel Reason prefs"),
    ("mine-r14-kevin-rl-1", "R14", "kevin954-init REINFORCE on teacher Reason"),
    ("mine-r15-pandora-rl-1", "R15", "pandora-box-init REINFORCE on teacher Reason"),
    ("mine-r16-golden-rl-1", "R16", "golden-crown-init REINFORCE on teacher Reason"),
    ("mine-r17-coder-rl-1", "R17", "Qwen3-Coder base REINFORCE on teacher Reason"),
    ("mine-r18-sbs-grpo-1", "R18", "pure sbs-v2-init Reason-GRPO (≠ R3/R10)"),
    ("mine-r19-talent-grpo-1", "R19", "TalentPigs-init Reason-GRPO (≠ R3/R5b/R18)"),
    ("mine-r20-kevin-grpo-1", "R20", "kevin954-init Reason-GRPO (≠ R3/R14/R19)"),
    ("mine-r21-pandora-grpo-1", "R21", "pandora-box-init Reason-GRPO (≠ R3/R15/R20)"),
    ("mine-r22-golden-grpo-1", "R22", "golden-crown-init Reason-GRPO (≠ R3/R16/R18–R21)"),
    ("mine-r23-diane-grpo-1", "R23", "diane613-init Reason-GRPO (≠ R3/R16/R18–R22)"),
]

BASE = os.environ.get("LIUM_BASE_URL", "https://lium.io/api")


def log(msg: str) -> None:
    line = f"[fleet-rent] {time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())} {msg}"
    print(line, flush=True)


def api_key() -> str:
    env = os.environ.get("LIUM_API_KEY")
    if env:
        return env
    cfg = configparser.ConfigParser()
    cfg.read(str(Path.home() / ".lium/config.ini"))
    key = cfg.get("api", "api_key", fallback=cfg.get("default", "api_key", fallback=""))
    if not key:
        raise SystemExit("no Lium API key")
    return key


def make_session() -> requests.Session:
    s = requests.Session()
    s.headers.update(
        {
            "X-API-KEY": api_key(),
            "X-Source": "fleet-api",
            "X-Lium-Client-Version": "0.0.32",
        }
    )
    return s


def _get_json(sess: requests.Session, path: str, params: dict | None = None, retries: int = 6):
    """GET JSON with 429/5xx backoff. Returns parsed body or None on hard fail."""
    url = f"{BASE}{path}"
    backoff = 0.5
    for attempt in range(retries):
        try:
            r = sess.get(url, params=params, timeout=30)
        except requests.RequestException as e:
            log(f"GET {path} neterr attempt={attempt+1}: {e}")
            time.sleep(backoff)
            backoff = min(backoff * 2, 8.0)
            continue
        if r.status_code == 429 or 500 <= r.status_code < 600:
            ra = r.headers.get("Retry-After")
            try:
                wait = float(ra) if ra else backoff
            except ValueError:
                wait = backoff
            wait = max(wait, backoff)
            log(f"GET {path} http={r.status_code} backoff={wait:.2f}s attempt={attempt+1}")
            time.sleep(wait)
            backoff = min(backoff * 2, 8.0)
            continue
        if not r.ok:
            log(f"GET {path} http={r.status_code} body={r.text[:160]}")
            return None
        try:
            return r.json()
        except Exception as e:
            log(f"GET {path} jsonerr: {e}")
            return None
    return None


def _is_b300(machine: str) -> bool:
    return "B300" in (machine or "").upper()


def _is_b200(machine: str) -> bool:
    u = (machine or "").upper()
    return "B200" in u and "B300" not in u


def list_b300_b200_nodes(sess: requests.Session) -> tuple[str, list[dict]] | tuple[None, None]:
    """One unfiltered 8× poll; prefer B300, else B200. None,None = API fail."""
    data = _get_json(
        sess,
        "/executors",
        params={
            "size": 1000,
            "gpu_count_gte": 8,
            "gpu_count_lte": 8,
        },
    )
    if not isinstance(data, list):
        return None, None
    b300: list[dict] = []
    b200: list[dict] = []
    for n in data:
        if not isinstance(n, dict):
            continue
        if n.get("has_no_pending_rental") is False:
            continue
        if not n.get("id"):
            continue
        mn = n.get("machine_name") or ""
        if _is_b300(mn):
            b300.append(n)
        elif _is_b200(mn):
            b200.append(n)
    if b300:
        return "B300", b300
    if b200:
        return "B200", b200
    return "", []


def mine_pods_or_none(sess: requests.Session) -> list[dict] | None:
    """Return mine-* pods, or None if /pods failed (do NOT treat as empty)."""
    data = _get_json(sess, "/pods")
    if not isinstance(data, list):
        return None
    mines = []
    for p in data:
        if not isinstance(p, dict):
            continue
        name = p.get("pod_name") or p.get("name") or ""
        if isinstance(name, str) and name.startswith("mine-"):
            p = dict(p)
            p["name"] = name
            mines.append(p)
    return mines


def mine_names_cli_fallback() -> set[str] | None:
    """Last-resort live mine names via `lium ps` when /pods is 429'd."""
    try:
        raw = subprocess.check_output(
            ["lium", "ps", "--format", "json"], text=True, timeout=60
        )
        pods = json.loads(raw)
        if isinstance(pods, dict):
            pods = pods.get("pods") or pods.get("data") or []
        if not isinstance(pods, list):
            return None
        out = set()
        for p in pods:
            if not isinstance(p, dict):
                continue
            name = p.get("name") or p.get("pod_name") or ""
            if isinstance(name, str) and name.startswith("mine-"):
                out.add(name)
        return out
    except Exception as e:
        log(f"lium ps fallback fail: {e}")
        return None


def resolve_live(sess: requests.Session) -> set[str] | None:
    pods = mine_pods_or_none(sess)
    if pods is not None:
        return {p["name"] for p in pods}
    log("/pods failed — trying lium ps fallback before any rent")
    return mine_names_cli_fallback()


def balance_ok() -> bool:
    try:
        raw = subprocess.check_output(["lium", "balance"], text=True, timeout=30)
    except Exception:
        return True
    m = re.search(r"([0-9]+(?:\.[0-9]+)?)", raw.replace(",", ""))
    if not m:
        return True
    return float(m.group(1)) >= 10000.0


def next_slots(live: set[str], want: int) -> list[tuple[str, str, str]]:
    out: list[tuple[str, str, str]] = []
    for name, axis, note in QUEUE:
        if name in live:
            continue
        out.append((name, axis, note))
        if len(out) >= want:
            break
    return out


def try_rent_node(node_id: str, name: str) -> bool:
    if not name.startswith("mine-"):
        log(f"REFUSE non-mine name={name}")
        return False
    cmd = [
        "lium",
        "up",
        node_id,
        "--name",
        name,
        "--ttl",
        TTL,
        "--no-ssh",
        "-y",
    ]
    log(f"attempting {' '.join(cmd)}")
    try:
        r = subprocess.run(cmd, timeout=180)
        return r.returncode == 0
    except Exception as e:
        log(f"rent fail name={name} err={e}")
        return False


def write_stamp(name: str, axis: str, gpu: str, note: str, sess: requests.Session) -> None:
    STAMP_DIR.mkdir(parents=True, exist_ok=True)
    path = STAMP_DIR / f"rented_{name.replace('/', '_')}.json"
    pods = mine_pods_or_none(sess)
    ps = json.dumps(pods)[:4000] if pods is not None else "pods_unavailable"
    path.write_text(
        json.dumps(
            {
                "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
                "pass": PASS,
                "name": name,
                "axis": axis,
                "gpu": gpu,
                "note": note,
                "ttl": TTL,
                "mode": "api-unfiltered-8x-then-lium-up",
                "ps_json": ps,
            },
            indent=2,
        )
        + "\n"
    )
    log(f"STAMP_OK {path}")


def main() -> int:
    EXP.joinpath("logs").mkdir(parents=True, exist_ok=True)
    STAMP_DIR.mkdir(parents=True, exist_ok=True)
    PIDF.write_text(str(os.getpid()) + "\n")

    log_f = open(LOG, "a", buffering=1)

    class Tee:
        def write(self, s):
            sys.__stdout__.write(s)
            log_f.write(s)

        def flush(self):
            sys.__stdout__.flush()
            log_f.flush()

    sys.stdout = Tee()  # type: ignore
    sys.stderr = sys.stdout  # type: ignore

    sess = make_session()
    log(
        f"start target={TARGET} cap={CAP} empty_sleep={EMPTY_SLEEP}s "
        f"parallel={PARALLEL_N} max_iters={MAX_ITERS} pass={PASS} "
        f"mode=api-unfiltered-8x"
    )

    live = resolve_live(sess)
    if live is None:
        log("ABORT cannot resolve live mine-* at start (/pods + lium ps failed)")
        return 5
    log(f"live_mines={' '.join(sorted(live))}|count={len(live)}")

    for i in range(1, MAX_ITERS + 1):
        if i == 1 or i % 40 == 0:
            if not balance_ok():
                log("ABORT balance below $10k floor")
                return 4
            live = resolve_live(sess)
            if live is None:
                log(f"iter={i} live-resolve FAIL — skip rent, sleep {PODS_FAIL_SLEEP}s")
                time.sleep(PODS_FAIL_SLEEP)
                continue
            n = len(live)
            if n >= TARGET:
                log(f"TARGET reached mine_count={n} >= {TARGET} — exit")
                return 0
            if n >= CAP:
                log(f"ABORT at cap mine_count={n} >= {CAP}")
                return 3

        gpu_label, nodes = list_b300_b200_nodes(sess)
        if gpu_label is None:
            if i % 40 == 1:
                log(f"iter={i} /executors FAIL — backoff sleep")
            time.sleep(max(EMPTY_SLEEP, PODS_FAIL_SLEEP))
            continue

        if not nodes:
            if i % 40 == 1:
                live = resolve_live(sess)
                if live is None:
                    log(f"iter={i} api-empty but live-resolve FAIL")
                    time.sleep(PODS_FAIL_SLEEP)
                    continue
                slots = next_slots(live, 6)
                try:
                    bal = subprocess.check_output(
                        ["lium", "balance"], text=True, timeout=30
                    ).strip()
                except Exception:
                    bal = "?"
                log(
                    f"iter={i} api-empty B300/B200×8; mine={len(live)}/{TARGET} "
                    f"(cap {CAP}) next={' '.join(s[0] for s in slots)}… bal={bal}"
                )
            time.sleep(EMPTY_SLEEP)
            continue

        # STOCK — must know live count before claiming (never assume 0 on API fail).
        live = resolve_live(sess)
        if live is None:
            log(
                f"STOCK {gpu_label}×8 n={len(nodes)} but live-resolve FAIL — "
                f"NO RENT (cap protect); sleep {PODS_FAIL_SLEEP}s"
            )
            time.sleep(PODS_FAIL_SLEEP)
            continue

        n = len(live)
        if n >= TARGET:
            log(f"TARGET reached mine_count={n} >= {TARGET} — exit")
            return 0
        remain = CAP - n
        if remain < 1:
            log(f"ABORT at cap mine_count={n} >= {CAP}")
            return 3
        want = min(PARALLEL_N, remain, len(nodes))
        slots = next_slots(live, want)
        if not slots:
            log(f"QUEUE exhausted with mine_count={n} < target={TARGET} — exit")
            return 0

        n_claim = min(len(nodes), len(slots))
        log(
            f"STOCK {gpu_label}×8 n={len(nodes)} — claiming {n_claim} axes: "
            f"{' '.join(s[0] for s in slots[:n_claim])}"
        )

        rented: dict[str, tuple[str, str, str]] = {}
        with ThreadPoolExecutor(max_workers=n_claim) as pool:
            futs = {}
            for j in range(n_claim):
                name, axis, note = slots[j]
                node_id = nodes[j]["id"]
                futs[pool.submit(try_rent_node, node_id, name)] = (name, axis, note)
            for fut in as_completed(futs):
                name, axis, note = futs[fut]
                ok = False
                try:
                    ok = fut.result()
                except Exception as e:
                    log(f"rent future err name={name} err={e}")
                if ok:
                    rented[name] = (axis, note, gpu_label)

        if not rented:
            log(
                f"iter={i} STOCK sighting but 0 rents ({gpu_label} n={len(nodes)}) "
                "— keep polling"
            )
            time.sleep(EMPTY_SLEEP)
            continue

        time.sleep(8)
        live = resolve_live(sess) or set()
        for name, (axis, note, gpu) in rented.items():
            if name in live:
                log(f"RENTED ok gpu={gpu} name={name} axis={axis}")
                write_stamp(name, axis, gpu, note, sess)
            else:
                log(f"up rc=0 but {name} not in ps — keep polling")

    live_final = resolve_live(sess) or set()
    log(f"TIMEOUT after {MAX_ITERS} iters — mine_count={len(live_final)}")
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
