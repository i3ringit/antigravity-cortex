---
name: plan_review
description: Have multiple specialized agents review a plan in parallel
argument-hint: "[plan file path or plan content]"
---

# Plan Review

## Context
Plan Path: <plan_path> #$ARGUMENTS </plan_path>

## Execution

<thinking>
Launch parallel review agents to critique the plan from multiple perspectives.
</thinking>

Run the following tasks in parallel:

Task simplicity-review: "You have the code-simplicity-reviewer skill. Review the plan at <plan_path>. Focus on: Is this the simplest possible solution? Are we over-engineering?"

Task architecture-review: "You have the architecture-strategist skill. Review the plan at <plan_path>. Focus on: Is this the right architectural pattern for the problem?"

Task security-review: "You have the security-sentinel skill. Review the plan at <plan_path>. Focus on: Are there any security risks?"

Task frontend-review: "You have the frontend-design skill. Review the plan at <plan_path>. Focus on: Is the design approach distinct and high-quality?"

## Synthesis

Wait for all reviews to complete.

Present the feedback to the user and ask:
"Based on these reviews, would you like to update the plan or proceed to implementation?"
