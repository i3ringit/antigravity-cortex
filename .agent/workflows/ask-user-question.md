---
description: Pauses execution to ask the user a question and wait for their response. Use this when you need a decision before proceeding (e.g., "Next steps?", "Approve deployment?").
---

# Ask User Question

To use this tool, simply output the question options to the user and **STOP GENERATING**.

## Usage
When the workflow instructs you to use `AskUserQuestion`:
1. Format the question and options clearly (e.g., numbered list).
2. Explicitly state: "Waiting for user input..."
3. **TERMINATE THE TURN.** (Do not simulate the user's answer).

## Example
User: "Run the build."
Agent: "Build complete. What would you like to do next?
1. Deploy to Staging
2. Run Tests
3. Exit"
[Agent Stops]