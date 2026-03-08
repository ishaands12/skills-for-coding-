#!/usr/bin/env python3
"""
Scaffolds a new 3-layer agent project (directives / orchestration / execution).

Usage:
    python init_project.py --name <project-name> --parent <parent-directory>
"""

import argparse
import os
import shutil
import subprocess
import sys
from pathlib import Path

AGENTS_MD_SOURCE = Path("/Users/ishaan/.claude/skills/AGENTS.md")

GITIGNORE = """\
# Intermediates — always regenerated, never committed
.tmp/

# Secrets
.env
credentials.json
token.json

# Python
.venv/
__pycache__/
*.pyc
*.pyo
*.egg-info/
dist/
build/

# OS
.DS_Store
Thumbs.db
"""

ENV_TEMPLATE = """\
# Environment variables for this project
# Fill in your API keys and secrets here. Never commit this file.

# Example:
# OPENAI_API_KEY=sk-...
# ANTHROPIC_API_KEY=sk-ant-...
# GOOGLE_APPLICATION_CREDENTIALS=credentials.json
"""

REQUIREMENTS_TXT = """\
# Add your project dependencies here.
# Install with: pip install -r requirements.txt

# Common picks for agent projects:
# anthropic
# openai
# requests
# python-dotenv
"""

DIRECTIVES_README = """\
# Directives

This folder contains SOPs (Standard Operating Procedures) written in Markdown.

Each directive tells the AI what to do for a specific workflow:
- What the goal is
- What inputs to expect
- Which execution script(s) to call
- What the output should look like
- Known edge cases and gotchas

**Example**: `directives/scrape_website.md` might describe how to scrape a site,
what inputs the scraper expects, and where to store results.

Create one `.md` file per workflow.
"""

EXECUTION_README = """\
# Execution

This folder contains deterministic Python scripts — the "Layer 3" of the system.

Scripts here do the actual work: API calls, data processing, file operations,
database interactions. They should be:
- **Deterministic**: same input → same output
- **Testable**: can be run independently
- **Well-commented**: explain the why, not just the what

The AI (Layer 2) reads directives and calls these scripts in the right order.
It does NOT write ad-hoc code — it uses what's here.

**Naming convention**: `verb_noun.py` (e.g., `scrape_site.py`, `export_sheet.py`)
"""


def run(cmd: list[str], cwd: Path | None = None) -> None:
    result = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"  Warning: {' '.join(cmd)} failed: {result.stderr.strip()}", file=sys.stderr)


def create_project(name: str, parent: Path) -> Path:
    project = parent / name

    if project.exists():
        print(f"Error: '{project}' already exists.", file=sys.stderr)
        sys.exit(1)

    print(f"\nCreating project at: {project}\n")

    # --- Directories ---
    for d in ["directives", "execution", ".tmp"]:
        (project / d).mkdir(parents=True)
        print(f"  [dir]  {d}/")

    # --- Mirror AGENTS.md ---
    if AGENTS_MD_SOURCE.exists():
        content = AGENTS_MD_SOURCE.read_text()
        for fname in ["AGENTS.md", "CLAUDE.md", "GEMINI.md"]:
            (project / fname).write_text(content)
            print(f"  [file] {fname}")
    else:
        print(f"  Warning: AGENTS.md source not found at {AGENTS_MD_SOURCE} — skipping mirror.")

    # --- .gitignore ---
    (project / ".gitignore").write_text(GITIGNORE)
    print("  [file] .gitignore")

    # --- .env ---
    (project / ".env").write_text(ENV_TEMPLATE)
    print("  [file] .env")

    # --- requirements.txt ---
    (project / "requirements.txt").write_text(REQUIREMENTS_TXT)
    print("  [file] requirements.txt")

    # --- READMEs in subdirs ---
    (project / "directives" / "README.md").write_text(DIRECTIVES_README)
    (project / "execution" / "README.md").write_text(EXECUTION_README)
    print("  [file] directives/README.md")
    print("  [file] execution/README.md")

    # --- Git init ---
    print("\n  Initializing git repo...")
    run(["git", "init"], cwd=project)
    run(["git", "add", "AGENTS.md", "CLAUDE.md", "GEMINI.md",
         ".gitignore", "requirements.txt",
         "directives/README.md", "execution/README.md"], cwd=project)
    run(["git", "commit", "-m", "chore: init project scaffold"], cwd=project)
    print("  [git]  initialized + initial commit")

    # --- Python venv ---
    print("\n  Creating Python virtual environment (.venv)...")
    result = subprocess.run(
        [sys.executable, "-m", "venv", ".venv"],
        cwd=project, capture_output=True, text=True
    )
    if result.returncode == 0:
        print("  [venv] .venv/ created")
    else:
        print(f"  Warning: venv creation failed: {result.stderr.strip()}", file=sys.stderr)

    return project


def main():
    parser = argparse.ArgumentParser(description="Scaffold a new 3-layer agent project.")
    parser.add_argument("--name", required=True, help="Project name (becomes the directory name)")
    parser.add_argument("--parent", required=True, help="Parent directory to create the project in")
    args = parser.parse_args()

    parent = Path(args.parent).expanduser().resolve()
    if not parent.exists():
        print(f"Error: Parent directory '{parent}' does not exist.", file=sys.stderr)
        sys.exit(1)

    project_path = create_project(args.name, parent)

    print(f"""
Done! Your project is ready at:
  {project_path}

Next steps:
  cd {project_path}
  source .venv/bin/activate
  # Fill in your API keys in .env
  # Write your first directive in directives/
""")


if __name__ == "__main__":
    main()
