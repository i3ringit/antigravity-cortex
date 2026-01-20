---
name: workflows:review
description: Perform exhaustive code reviews using multi-agent analysis, ultra-thinking, and worktrees
argument-hint: "[PR number, GitHub URL, branch name, or latest]"
---

# Review Command - Orchestrator

<command_purpose> Coordinator for exhaustive code reviews. Delegates analysis and synthesis to sub-workflows. </command_purpose>

## Introduction

<role>Senior Code Review Architect</role>

## Prerequisites

<requirements>
- Git repository with GitHub CLI (`gh`) installed
- Clean main/master branch
- Proper permissions
</requirements>

## Main Tasks

### 1. Determine Review Target & Setup

<review_target> #$ARGUMENTS </review_target>

<thinking>
Determine review target and ensure environment is ready.
</thinking>

#### Actions:

- [ ] **Identify Target**:
    - PR number / URL / File path / Empty (current branch)
- [ ] **Check Branch**:
    - If ALREADY on PR branch → proceed.
    - If DIFFERENT branch → offer `skill: git-worktree` for isolation.
- [ ] **Fetch Metadata**:
    - `gh pr view --json title,body,files,headRefName`
- [ ] **Checkout**:
    - Ensure we are on the correct branch/worktree.

**Verification:**
Execute `git status` and `gh pr view` to confirm we are inspecting the correct code.

### 2. Perform Comprehensive Analysis

<thinking>
Delegate deep analysis to the Analysis Sub-Workflow.
Passing arguments: #$ARGUMENTS
</thinking>

Call /workflows:review-analysis(#$ARGUMENTS)

### 3. Synthesize and Report

<thinking>
Delegate synthesis, artifact creation, and reporting to the Synthesis Sub-Workflow.
Passing arguments: #$ARGUMENTS
</thinking>

Call /workflows:review-synthesis(#$ARGUMENTS)
