# Antigravity Cortex

The central "brain" and standard library for Antigravity-powered agents. This repository hosts shared Skills, Workflows, and Rules that are injected into project workspaces (Kastor, Warforged) to ensure consistent, high-quality engineering.

## Architecture

This repository is designed to be included as a **Git Submodule** in your active projects.

*   **Skills** (`.agent/skills`): Capabilities the agent can pull in on demand.
*   **Workflows** (`.agent/workflows`): Step-by-step guides for specific tasks.
*   **Rules** (`.agent/rules`): Persistent context and formatting rules.

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

## Contributing

To update the brain:
1.  Make changes inside `.agent/cortex/` within your project.
2.  Commit and push from there.
3.  Pull the updates in your other projects.

---
*Forked from [Compound Engineering Plugin](https://github.com/EveryInc/compound-engineering-plugin)*
