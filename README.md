# Antigravity Cortex

The central "brain" and standard library for Antigravity-powered agents. This package distributes shared **Skills**, **Workflows**, and **Rules** that are injected into project workspaces to ensure consistent, high-quality engineering.

## Architecture

This package manages the `.agent/` directory in your project using a **Manifest-based Sync** system.

*   **Skills** (`.agent/skills/`): Capabilities the agent can pull in on demand (e.g., `git-worktree`, `data-migration-expert`).
*   **Workflows** (`.agent/workflows/`): Step-by-step guides for specific tasks (e.g., `/deploy`, `/plan`).
*   **Rules** (`.agent/rules/`): Persistent context and formatting rules (e.g., `00-constitution.md`).
*   **Browser Agent**: Includes `agent-browser` as a native dependency.

## Installation

To add Antigravity Cortex to your project:

```bash
# 1. Install the package (Dev Dependency recommended)
npm install -D ag-cortex

# 2. Initialize the brain
# This copies the assets to your .agent/ directory and creates a tracking manifest.
npx ag-cortex install
```

## Usage

### Updating Assets
When a new version of `ag-cortex` is released, update your local assets safely:

```bash
# 1. Update the package
npm install -D ag-cortex@latest

# 2. Sync the assets
# This will update modified files and prune orphaned files (keeping your custom files safe).
npx ag-cortex update
```

### Checking Status
Verify your installation and dependencies:

```bash
npx ag-cortex doctor
```

---
*Forked from [Compound Engineering Plugin](https://github.com/EveryInc/compound-engineering-plugin)*.
