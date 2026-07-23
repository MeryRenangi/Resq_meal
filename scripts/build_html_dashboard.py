#!/usr/bin/env python3
"""Build a static HTML dashboard summarizing E2E test reports."""

from __future__ import annotations

import argparse
import json
import sys
from datetime import datetime
from pathlib import Path

HTML_TEMPLATE = """<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>ResQ Meal — E2E Test Report</title>
  <style>
    :root {{ --green: #1b5e20; --light: #e8f5e9; --red: #c62828; }}
    * {{ box-sizing: border-box; }}
    body {{ font-family:Segoe UI,system-ui,sans-serif; margin:0; background:#f5f5f5; color:#212121; }}
    header {{ background:var(--green); color:#fff; padding:24px 32px; }}
    header h1 {{ margin:0 0 8px; font-size:1.6rem; }}
    main {{ max-width:1100px; margin:24px auto; padding:0 16px 48px; }}
    .cards {{ display:grid; grid-template-columns:repeat(auto-fit,minmax(240px,1fr)); gap:16px; margin-bottom:32px; }}
    .card {{ background:#fff; border-radius:10px; padding:20px; box-shadow:0 2px 8px rgba(0,0,0,.08); }}
    .card h2 {{ margin:0 0 4px; font-size:.85rem; text-transform:uppercase; color:#666; }}
    .card .value {{ font-size:2rem; font-weight:700; color:var(--green); }}
    .card .sub {{ color:#888; font-size:.9rem; }}
    table {{ width:100%; border-collapse:collapse; background:#fff; border-radius:10px; overflow:hidden; box-shadow:0 2px 8px rgba(0,0,0,.08); }}
    th {{ background:var(--green); color:#fff; text-align:left; padding:12px 14px; }}
    td {{ padding:10px 14px; border-bottom:1px solid #eee; }}
    tr:last-child td {{ border-bottom:none; }}
    .pass {{ color:var(--green); font-weight:600; }}
    .fail {{ color:var(--red); font-weight:600; }}
    .downloads {{ margin-top:24px; }}
    .downloads a {{ display:inline-block; margin-right:12px; padding:10px 16px; background:var(--green); color:#fff; text-decoration:none; border-radius:6px; }}
    footer {{ text-align:center; color:#888; padding:24px; font-size:.85rem; }}
  </style>
</head>
<body>
  <header>
    <h1>ResQ Meal — E2E Test Report</h1>
    <p>1800 automated test cases · Selenium · Appium · API · Validation · Deployment · Load</p>
  </header>
  <main>
    <div class="cards">
      <div class="card"><h2>Total Cases</h2><div class="value">{total_cases}</div><div class="sub">Across all 6 suites</div></div>
      <div class="card"><h2>Passed</h2><div class="value">{total_passed}</div><div class="sub">{pass_rate}% pass rate</div></div>
      <div class="card"><h2>Failed</h2><div class="value">{total_failed}</div><div class="sub">Requires review</div></div>
      <div class="card"><h2>Generated</h2><div class="value" style="font-size:1rem;padding-top:8px;">{generated_at}</div></div>
    </div>
    <table>
      <thead><tr><th>Suite</th><th>Runner</th><th>Device</th><th>Total</th><th>Passed</th><th>Failed</th><th>Pass Rate</th></tr></thead>
      <tbody>{rows}</tbody>
    </table>
    <div class="downloads">
      <p><strong>Download Excel reports:</strong></p>
      <a href="full-e2e-report.xlsx">Full E2E Report (.xlsx)</a>
      <a href="selenium-web-report.xlsx">Web Report (.xlsx)</a>
      <a href="appium-android-report.xlsx">Mobile Report (.xlsx)</a>
      <a href="unit-test-report.xlsx">API Report (.xlsx)</a>
      <a href="validation-test-report.xlsx">Validation Report (.xlsx)</a>
      <a href="deployment-test-report.xlsx">Deployment Report (.xlsx)</a>
      <a href="load-test-report.xlsx">Load Report (.xlsx)</a>
    </div>
  </main>
  <footer>ResQ Meal CI · GitHub Actions</footer>
</body>
</html>
"""

# All 6 report JSON files produced by generate_test_results.py
REPORT_FILES = [
    "selenium-web-report.json",
    "appium-android-report.json",
    "unit-test-report.json",
    "validation-test-report.json",
    "deployment-test-report.json",
    "load-test-report.json",
]


def _load_reports(reports_dir: Path) -> list[dict]:
    reports = []
    for name in REPORT_FILES:
        path = reports_dir / name
        if path.exists():
            reports.append(json.loads(path.read_text(encoding="utf-8")))
        else:
            print(f"[warn] Report not found, skipping: {path}", file=sys.stderr)
    return reports


def build_dashboard(reports_dir: Path, output_dir: Path) -> None:
    reports = _load_reports(reports_dir)
    if not reports:
        print("No JSON reports found in reports directory.", file=sys.stderr)
        sys.exit(1)

    total_cases = sum(r["total_cases"] for r in reports)
    total_passed = sum(r["passed"] for r in reports)
    total_failed = sum(r["failed"] for r in reports)
    pass_rate = round(total_passed / total_cases * 100, 2) if total_cases else 0

    rows = []
    for r in reports:
        fail_class = "fail" if r["failed"] > 0 else "pass"
        rows.append(
            f"<tr>"
            f"<td>{r['platform'].title()} — {r['runner']}</td>"
            f"<td>{r['runner']}</td>"
            f"<td>{r['device']}</td>"
            f"<td>{r['total_cases']}</td>"
            f"<td class='pass'>{r['passed']}</td>"
            f"<td class='{fail_class}'>{r['failed']}</td>"
            f"<td>{r['pass_rate']}%</td>"
            f"</tr>"
        )

    html = HTML_TEMPLATE.format(
        total_cases=total_cases,
        total_passed=total_passed,
        total_failed=total_failed,
        pass_rate=pass_rate,
        generated_at=datetime.utcnow().strftime("%Y-%m-%d %H:%M UTC"),
        rows="\n      ".join(rows),
    )

    output_dir.mkdir(parents=True, exist_ok=True)
    (output_dir / "index.html").write_text(html, encoding="utf-8")

    # Copy Excel files into site for download links
    for xlsx in reports_dir.glob("*.xlsx"):
        (output_dir / xlsx.name).write_bytes(xlsx.read_bytes())

    print(f"Dashboard written -> {output_dir / 'index.html'} ({len(reports)} suites, {total_cases} cases, {pass_rate}% pass rate)")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--reports-dir", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args()
    build_dashboard(args.reports_dir, args.output_dir)
    return 0


if __name__ == "__main__":
    sys.exit(main())
