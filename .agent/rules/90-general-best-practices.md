# General Engineering Standards

These are the baseline operating procedures for this project. They are designed to keep velocity high and technical debt low.

## 1. Documentation
Code is read more often than it is written.
- **Update Docs with Code**: Never ship a feature without updating the relevant documentation (README, API docs, or inline comments).
- **Why > What**: Comments should explain *why* a complex decision was made, not just *what* the code does.

## 2. Testing
Unverified code is broken code.
- **Verification First**: Before marking a task as "Done", verify it.
- **Reproducible**: If you fix a bug, try to add a test case or a reproduction script to prevent regression.

## 3. Commit Conventions
Keep history clean and searchable.
- `feat: ...` for new features
- `fix: ...` for bug fixes
- `refactor: ...` for code structure changes
- `docs: ...` for documentation updates
- `chore: ...` for maintenance tasks

## 4. Workflows
Leverage the agents to scale your output.
- Use `/plan` before starting complex features.
- Use `/review` to catch issues early.
- Use `/compound` to save knowledge for the next developer.
