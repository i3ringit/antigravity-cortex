---
name: workflows:plan-analysis
description: Internal sub-workflow for the Plan Analysis phase. Executes research and context gathering.
argument-hint: "[feature description]"
---

<critical_rule>
This workflow is for RESEARCH ONLY. You must NOT execute code changes.
</critical_rule>

# Plan Analysis Sub-Workflow

## Input

<feature_description> #$ARGUMENTS </feature_description>

## Main Tasks

### 1. Parallel Research Execution

<thinking>
I need to understand the project's conventions and existing patterns.
I will run research agents in parallel to gather maximum context.
</thinking>

Run these agents in parallel:

- Task repo-research-analyst(#$ARGUMENTS)
- Task best-practices-researcher(#$ARGUMENTS)
- Task framework-docs-researcher(#$ARGUMENTS)
- Task spec-flow-analyzer(#$ARGUMENTS)

### 2. Output Generation

<thinking>
Synthesize the research findings into a structured JSON object.
This format is CRITICAL for the next step to parse correctly.
</thinking>

<output_format>
Return a JSON object with this structure:
```json
{
  "research_findings": [
    {
      "source": "repo-research-analyst",
      "summary": "...",
      "key_files": ["path/to/file"]
    },
    ...
  ],
  "spec_analysis": {
    "gaps": ["..."],
    "flows": ["..."]
  },
  "detected_context": {
    "frameworks": ["rails", "react"],
    "patterns": ["service_objects"]
  }
}
```
</output_format>

**Instructions:**
- Aggregate findings from all agents.
- Ensure valid JSON syntax.
- If an agent fails, note it in the summary but do not break the JSON.
