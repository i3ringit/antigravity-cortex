# Cortex Lab Project Rules

This file documents the project's rules, conventions, and workflows. It was migrated from `CLAUDE.md`.

## Commands

- **`/release-docs`**: Run the release-docs command to update all documentation pages.
- **`/review`**: Run the review command to perform exhaustive code reviews.
- **`/test-browser`**: Run browser tests using Playwright.
- **`/xcode-test`**: Run iOS tests using Xcode simulator.

## Project Structure

```
cortex/
├── .agent/
│   ├── rules/          # Project rules and conventions
│   ├── skills/         # Specialized agent skills
│   └── workflows/      # Automated workflows
├── docs/               # Documentation site (HTML/CSS)
├── plugins/            # Plugin source code
└── ...
```

## Documentation

The documentation site is at `/docs` in the repository root.

### Keeping Docs Up-to-Date

After ANY change to agents, commands, skills, or MCP servers, update documentation.

## Commit Conventions

Follow these patterns for commit messages:

- `Add [agent/command name]` - Adding new functionality
- `Remove [agent/command name]` - Removing functionality
- `Update [file] to [what changed]` - Updating existing files
- `Fix [issue]` - Bug fixes
- `Simplify [component] to [improvement]` - Refactoring

## Key Learnings

### 2024-11-22: Added gemini-imagegen skill and fixed component counts
Always count actual files before updating descriptions.

### 2024-10-09: Simplified marketplace.json to match official spec
Stick to the official spec. Custom fields may confuse users.
