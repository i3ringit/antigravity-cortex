---
description: Pull updates from upstream Compound Engineering Plugin
---

# Sync Upstream

This workflow pulls changes from `EveryInc/compound-engineering-plugin` and automatically reorganizes new files into the Antigravity Cortex structure.

## 1. Fetch Upstream

```bash
git fetch upstream main
git checkout upstream-mirror
git merge upstream/main
git checkout main
git merge upstream-mirror
```

## 2. Auto-Restructure

Run the following commands to move any new upstream files to their correct Antigravity locations.

```bash
# Move new Agents -> Skills
find plugins/compound-engineering/agents -name "*.md" 2>/dev/null | while read file; do
    agent_name=$(basename "$file" .md)
    mkdir -p ".agent/skills/$agent_name"
    git mv "$file" ".agent/skills/$agent_name/SKILL.md"
done

# Move new Commands -> Workflows
find plugins/compound-engineering/commands -name "*.md" 2>/dev/null | while read file; do
     filename=$(basename "$file")
     # Normalize underscore to dash if needed
     new_filename=${filename//_/-}
     git mv "$file" ".agent/workflows/$new_filename"
done

# Move new Skills
find plugins/compound-engineering/skills -maxdepth 1 -mindepth 1 -type d 2>/dev/null | while read dir; do
    git mv "$dir" ".agent/skills/"
done

# Clean up empty dirs
rmdir plugins/compound-engineering/agents 2>/dev/null || true
rmdir plugins/compound-engineering/commands 2>/dev/null || true
rmdir plugins/compound-engineering/skills 2>/dev/null || true
```

## 3. Verify and Commit

```bash
git status
# If clean, everything is good. If renaming occurred, commit it.
git commit -am "Sync: Update from upstream and restructure" || echo "Nothing to commit"
```
