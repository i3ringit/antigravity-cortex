# Antigravity Codex

This is the central "brain" for Antigravity-powered agents. It defines the core primitives—Skills, Workflows, and Rules—and how they should be used to maintain a high standard of engineering.

## Core Primitives

| Primitive | Definition | Activation | Analogy | Directory |
| :--- | :--- | :--- | :--- | :--- |
| **Skills** | Capabilities the agent "knows" how to do. Discovered automatically. | **Auto-detected** (Pull) | **Toolbelt** | `.agent/skills/` |
| **Workflows** | Standard Operating Procedures (SOPs) for linear processes. | **User-Invoked** (Push) | **Runbook** | `.agent/workflows/` |
| **Rules** | Constraints, persona definitions, and "constitution" files. | **Context** (Always On) | **Identity** | `.agent/rules/` |

## Repository Structure

```
antigravity-cortex/
├── .agent/
│   ├── rules/          # Context & Identity (e.g., specific engineering personas)
│   ├── skills/         # Capabilities (formerly plugins)
│   ├── workflows/      # Step-by-step procedures (formerly plans/workflows)
│   └── templates/      # Templates for plans and documents
└── README.md
```

## Philosophy: Compounding Engineering

**Each unit of engineering work should make subsequent units of work easier—not harder.**

1.  **Plan** → Stop and architect before coding.
2.  **Work** → Execute the code using your Skills.
3.  **Review** → Verify against Rules and standards.
4.  **Compound** → Save lessons learned into Rules or Skills so mistakes aren't repeated.

## Maintenance

### Updating Skills
Skills are folders in `.agent/skills/` containing a `SKILL.md`. When adding a new capability (e.g., a new language or framework tool), add it here.

### Updating Workflows
Workflows are `.md` files in `.agent/workflows/`. These are for processes you explicitly trigger (e.g., `prepare-pr`, `deploy`).

### Updating Rules
Rules are loaded into context. Use these for broad directives (e.g., "Always use TypeScript", "Act as a Principal Engineer").

---
*Generated for Antigravity Cortex*
