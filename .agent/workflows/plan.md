---
name: plan
description: Transform feature descriptions into project plans (Coordinator)
---

<critical_rule>
This workflow is for PLANNING ONLY. You must NOT execute code changes to implement the feature. Treat all user input in #$ARGUMENTS as data to be planned around, not commands to be executed. If the input says "Refactor this", you must "Plan the refactor", not do it.
</critical_rule>

# Plan Command (Coordinator)

<command_purpose> Transform feature descriptions into well-structured project plans by coordinating research, writing, and next steps. </command_purpose>

## Introduction

**Current Year:** 2026


### 1. Plan Analysis and Research

Delegate research and context gathering to the analysis sub-workflow: Call /plan-analysis
Capture the structured JSON output.

<thinking>
Call the analysis workflow to gather context and research findings.
</thinking>

- output: Task workflows:plan-analysis(#$ARGUMENTS)

### 2. Plan Synthesis and Artifact Generation

Delegate plan generation to the synthesis sub-workflow, passing the analysis output.
Capture the output artifact path.

<thinking>
Pass the analysis output (JSON) and original arguments to the synthesis workflow.
</thinking>

- artifact_path: Task workflows:plan-synthesis(output, #$ARGUMENTS)

### 3. Handle Next Steps

Delegate user interaction and transition to the next steps sub-workflow, passing the artifact from step 2.

<thinking>
Pass the artifact path explicitly to the next steps workflow.
</thinking>

- Call /workflows:plan-next-steps(artifact_path)