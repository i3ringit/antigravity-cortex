---
name: lfg
description: Full autonomous engineering workflow
argument-hint: "[feature description]"
---

Run these slash commands in order.

> **Note**: Autonomy engine (`ralph-loop`) missing. Run steps manually.

1. `<!-- /ralph-loop "finish all slash commands" --completion-promise "DONE" -->`
2. `/workflows:plan $ARGUMENTS`
3. `/deepen-plan`
4. `/workflows:work`
5. `/workflows:review`
6. `/resolve-todo-parallel`
7. `/test-browser`
8. `/feature-video`
9. Output `<promise>DONE</promise>` when video is in PR

Start with step 1 now.
