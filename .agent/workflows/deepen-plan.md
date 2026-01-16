---
Description: Enhance a plan with parallel research agents for each section to add depth, best practices, and implementation details
---

# Deepen Plan - Power Enhancement Mode

## Introduction

**Note: The current year is 2026.** Use this when searching for recent documentation and best practices.

This command takes an existing plan (from `/workflows:plan`) and enhances each section with parallel research agents. Each major element gets its own dedicated research sub-agent to find:
- Best practices and industry patterns
- Performance optimizations
- UI/UX improvements (if applicable)
- Quality enhancements and edge cases
- Real-world implementation examples

The result is a deeply grounded, production-ready plan with concrete implementation details.

## Phase 1: Setup

<plan_path> #$ARGUMENTS </plan_path>

**Validation Step:**
1. **Analyze Input:**
    - If `<plan_path>` is provided, verify that file exists.
    - If `<plan_path>` is EMPTY, perform a sequential check:

        **A. Check Active Context (Priority):**
        - Check your conversation metadata for an active `implementation_plan` artifact.
        - If found, **extract its ABSOLUTE FILE PATH** (from your system reminders) and use that specifically as the `<plan_path>`.
       
        **B. Search Local Files:**
        - If no active artifact is found, run: `find . -maxdepth 3 -name "*plan*.md" -not -path "*/.*"`

2. **User Interaction:**
    - If you are using an **Active Plan Artifact**, log this action in your internal thought process or Task Status, but **DO NOT stop to notify the user**. Proceed immediately to Phase 2.
    - If you found local files, list them and ask: "Which of these plans would you like to deepen?"
    - If nothing is found, ask for a path manually.

3. **Critical Check:**
    - Do not proceed until `<plan_path>` points to a valid file on disk.

## Phase 2: Research Execution

### Execute Research Phase

Call `/deepen-plan-research` with the argument `<plan_path>`.

*Wait for the research phase to complete.*

## Phase 3: Synthesis Execution

### Execute Synthesis Phase

Call `/deepen-plan-synthesis` with the argument `<plan_path>`.

*Wait for the synthesis phase to complete.*

## Phase 4: Post-Enhancement Options

After writing the enhanced plan, use the **workflows:ask-user-question** to present these options:

**Question:** "Plan deepened at `[plan_path]`. What would you like to do next?"

**Options:**
1. **View diff** - Show what was added/changed
2. **Run `/plan_review`** - Get feedback from reviewers on enhanced plan
3. **Start `/workflows:work`** - Begin implementing this enhanced plan
4. **Deepen further** - Run another round of research on specific sections
5. **Revert** - Restore original plan (if backup exists)

Based on selection:
- **View diff** → Run `git diff [plan_path]` or show before/after
- **`/plan_review`** → Call the /plan_review command with the plan file path
- **`/workflows:work`** → Call the /workflows:work command with the plan file path
- **Deepen further** → Ask which sections need more research, then re-run those agents
- **Revert** → Restore from git or backup