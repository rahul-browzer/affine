"""Follow the live SSE event stream: phase changes, intake events, verdicts.

Usage: python examples/watch_stream.py
"""

import json

import requests

STREAM_URL = "https://www.affine.io/api/v1/stream"


def main() -> None:
    with requests.get(
        STREAM_URL,
        headers={"Accept": "text/event-stream"},
        stream=True,
        timeout=(10, None),
    ) as resp:
        resp.raise_for_status()
        print(f"Connected to {STREAM_URL}; waiting for events (Ctrl-C to stop)")
        for raw in resp.iter_lines(decode_unicode=True):
            if not raw or not raw.startswith("data:"):
                continue
            payload = raw[len("data:"):].strip()
            try:
                event = json.loads(payload)
            except json.JSONDecodeError:
                print(payload)
                continue
            print(json.dumps(event)[:200])


if __name__ == "__main__":
    main()
