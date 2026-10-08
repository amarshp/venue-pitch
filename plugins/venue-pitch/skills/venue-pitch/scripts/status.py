"""Progress of a venue's arms: elapsed minutes, tool calls, skill calls, commits, final cost when done.

Usage: python status.py <slug> <tag> <arm,arm,...>
"""
import datetime as dt
import json
import os
import subprocess
import sys

slug, tag, arms = sys.argv[1], sys.argv[2], sys.argv[3].split(",")
ws = os.path.join(os.environ.get("VP_ROOT", "C:/vp"), slug)
for arm in arms:
    try:
        lines = open(f"{ws}/runs/{tag}-{arm}/transcript.jsonl", encoding="utf-8-sig", errors="replace").read().splitlines()
    except FileNotFoundError:
        print(f"== {arm}: not started")
        continue
    first = last = None
    tools = 0
    skills = []
    recent = []
    results = []
    for line in lines:
        try:
            e = json.loads(line)
        except ValueError:
            continue
        ts = e.get("timestamp")
        if ts:
            first = first or ts
            last = ts
        if e.get("type") == "assistant":
            for c in e["message"].get("content", []):
                if c.get("type") == "tool_use":
                    tools += 1
                    inp = c.get("input", {})
                    if c["name"] == "Skill":
                        skills.append(inp.get("skill", "?"))
                    recent.append(f'{c["name"]}: {str(inp.get("command") or inp.get("file_path") or inp.get("skill") or inp.get("url") or "")[:90]}')
        if e.get("type") == "result":
            results.append(e)
    mins = 0
    if first and last:
        mins = (dt.datetime.fromisoformat(last.replace("Z", "+00:00")) - dt.datetime.fromisoformat(first.replace("Z", "+00:00"))).seconds / 60
    commits = subprocess.run(["git", "-C", f"{ws}/{arm}", "log", "--oneline"], capture_output=True, text=True).stdout.splitlines()
    print(f"== {arm}: {mins:.0f} min, {tools} tool calls, skills used {skills or 'none'}, {len(commits)} commits (latest: {commits[0] if commits else '-'})")
    if results:
        # A run that waits on its own background agents emits several result events; the last one is final.
        r = results[-1]
        print(f"   result: {r.get('subtype')}, cost ${r.get('total_cost_usd', 0):.2f}, {len(results)} result event(s)")
    for item in recent[-4:]:
        print("   ", item.encode("ascii", "replace").decode())
