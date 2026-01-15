# Antigravity Cortex

The central "brain" and standard library for Antigravity-powered agents. This repository hosts shared Skills, Workflows, and Rules that are injected into project workspaces (Kastor, Warforged) to ensure consistent, high-quality engineering.

## Architecture

This repository is designed to be included as a **Git Submodule** in your active projects.

*   **Skills** (`.agent/skills/`): Capabilities the agent can pull in on demand.
    *   Example: `git-worktree`, `data-migration-expert`, `react-architect`
*   **Workflows** (`.agent/workflows/`): Step-by-step guides for specific tasks.
    *   Example: `deploy-docs.md`, `sync-upstream.md`
*   **Rules** (`.agent/rules/`): Persistent context and formatting rules.
    *   Example: `00-constitution.md`

## Installation

To add the Antigravity Cortex to a project:

```bash
# 1. Add as submodule
git submodule add https://github.com/i3ringit/antigravity-cortex.git .agent/cortex

# 2. Symlink the brain (Run from project root)
mkdir -p .agent/workflows .agent/skills .agent/rules

# Link content from Cortex to your local agent folder
ln -s ../cortex/.agent/workflows/* .agent/workflows/
ln -s ../cortex/.agent/skills/* .agent/skills/
ln -s ../cortex/.agent/rules/* .agent/rules/
```

## Maintenance

### Syncing Updates

To pull the latest skills from the community (upstream):

```bash
claude /sync-upstream
```

This will fetch changes from `EveryInc/compound-engineering-plugin` and automatically restructure them into the Antigravity format.

---
*Forked from [Compound Engineering Plugin](https://github.com/EveryInc/compound-engineering-plugin)*
