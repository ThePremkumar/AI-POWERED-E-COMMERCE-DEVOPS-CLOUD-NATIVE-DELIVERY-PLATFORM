#!/usr/bin/env python3
# =============================================================================
# ai/incident_analyzer.py – AI-Assisted DevOps Incident Analysis
# AI-Powered E-Commerce DevOps & Cloud-Native Delivery Platform
# =============================================================================
"""
Analyses log files / error output and returns:
  - Error classification
  - Incident severity (LOW / MEDIUM / HIGH / CRITICAL)
  - Possible root-cause identification
  - Suggested investigation steps
  - Suggested remediation actions

Requires: pip install openai python-dotenv
Set OPENAI_API_KEY in your environment (or .env file).
"""

import os
import sys
import json
import textwrap
from datetime import datetime
from pathlib import Path

try:
    from openai import OpenAI
    from dotenv import load_dotenv
except ImportError:
    print("Missing dependencies – run: pip install openai python-dotenv")
    sys.exit(1)

load_dotenv()

# ── Configuration ──────────────────────────────────────────────
OPENAI_API_KEY  = os.getenv("OPENAI_API_KEY")
OPENAI_MODEL    = os.getenv("AI_MODEL", "gpt-4o-mini")
OUTPUT_DIR      = Path("ai/reports")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

SYSTEM_PROMPT = textwrap.dedent("""
    You are an expert DevOps Site Reliability Engineer (SRE) with deep experience in:
    - Kubernetes, Docker, and container orchestration
    - CI/CD pipelines (Jenkins, GitHub Actions)
    - Cloud infrastructure (AWS, GCP, Azure)
    - Monitoring (Prometheus, Grafana) and logging (ELK stack)
    - Application performance and reliability

    When given log output or error messages, you MUST respond ONLY with valid JSON
    in the following structure:
    {
        "error_classification": "<type of error>",
        "severity": "<LOW|MEDIUM|HIGH|CRITICAL>",
        "summary": "<one-sentence summary>",
        "root_cause_candidates": ["<candidate 1>", "<candidate 2>"],
        "investigation_steps": ["<step 1>", "<step 2>", "<step 3>"],
        "remediation_actions": ["<action 1>", "<action 2>"],
        "additional_notes": "<optional extra context>"
    }
""").strip()


def analyze_incident(log_content: str, context: str = "") -> dict:
    """Send log content to OpenAI and return structured analysis."""
    if not OPENAI_API_KEY:
        return {
            "error_classification": "Configuration Error",
            "severity": "LOW",
            "summary": "OPENAI_API_KEY is not set. Set it in your .env file.",
            "root_cause_candidates": ["Missing API key"],
            "investigation_steps": ["Set OPENAI_API_KEY in .env"],
            "remediation_actions": ["export OPENAI_API_KEY=your_key_here"],
            "additional_notes": ""
        }

    client = OpenAI(api_key=OPENAI_API_KEY)

    user_message = f"Context: {context}\n\nLog/Error Output:\n```\n{log_content}\n```" if context \
        else f"Log/Error Output:\n```\n{log_content}\n```"

    response = client.chat.completions.create(
        model=OPENAI_MODEL,
        messages=[
            {"role": "system",  "content": SYSTEM_PROMPT},
            {"role": "user",    "content": user_message}
        ],
        temperature=0.2,
        max_tokens=1024,
        response_format={"type": "json_object"}
    )

    return json.loads(response.choices[0].message.content)


def format_report(analysis: dict, source: str) -> str:
    """Pretty-print analysis report."""
    severity_icons = {"LOW": "🟢", "MEDIUM": "🟡", "HIGH": "🟠", "CRITICAL": "🔴"}
    sev = analysis.get("severity", "UNKNOWN")
    icon = severity_icons.get(sev, "⚪")

    lines = [
        "=" * 70,
        f"  AI INCIDENT ANALYSIS REPORT",
        f"  Source   : {source}",
        f"  Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
        "=" * 70,
        f"  {icon}  SEVERITY: {sev}",
        f"  📋 Classification: {analysis.get('error_classification', 'N/A')}",
        f"  📝 Summary: {analysis.get('summary', 'N/A')}",
        "",
        "  Root Cause Candidates:",
    ]
    for i, c in enumerate(analysis.get("root_cause_candidates", []), 1):
        lines.append(f"    {i}. {c}")
    lines += ["", "  Investigation Steps:"]
    for i, s in enumerate(analysis.get("investigation_steps", []), 1):
        lines.append(f"    {i}. {s}")
    lines += ["", "  Remediation Actions:"]
    for i, a in enumerate(analysis.get("remediation_actions", []), 1):
        lines.append(f"    {i}. {a}")
    if analysis.get("additional_notes"):
        lines += ["", f"  Notes: {analysis['additional_notes']}"]
    lines.append("=" * 70)
    return "\n".join(lines)


def main():
    import argparse
    parser = argparse.ArgumentParser(
        description="AI-Assisted DevOps Incident Analyzer"
    )
    parser.add_argument("--log-file",  "-f", help="Path to log file to analyze")
    parser.add_argument("--log-text",  "-t", help="Log text to analyze (inline)")
    parser.add_argument("--context",   "-c", help="Additional context about the incident", default="")
    parser.add_argument("--output",    "-o", help="Save JSON report to file", default="")
    args = parser.parse_args()

    if args.log_file:
        log_content = Path(args.log_file).read_text(encoding="utf-8")
        source = args.log_file
    elif args.log_text:
        log_content = args.log_text
        source = "inline"
    else:
        print("Reading log from stdin (Ctrl+D to end)...")
        log_content = sys.stdin.read()
        source = "stdin"

    print(f"\n🔍 Analyzing incident (model: {OPENAI_MODEL})...\n")
    analysis = analyze_incident(log_content, args.context)
    report   = format_report(analysis, source)
    print(report)

    # Save report
    timestamp   = datetime.now().strftime("%Y%m%d_%H%M%S")
    output_path = args.output or str(OUTPUT_DIR / f"incident_{timestamp}.json")
    Path(output_path).write_text(json.dumps(analysis, indent=2), encoding="utf-8")
    print(f"\n💾 JSON report saved: {output_path}")


if __name__ == "__main__":
    main()
