---
name: ship
description: Securely ship code with security scans, local verification, and PR creation.
argument-hint: "None"
---

# Ship It - Secure Delivery Workflow

This workflow handles the safe delivery of code: committing, checking for secrets, pushing, and creating a PR.

## Workflow Steps

### 1. Create Commit

```bash
git add .
git status  # Review what's being committed
git diff --staged  # Check the changes

# Commit with conventional format
git commit -m "$(cat <<'EOF'
feat(scope): description of what and why

Brief explanation if needed.

🤖 Generated with [Antigravity](http://antigravity.google/)

Co-Authored-By: Antigravity <noreply@antigravity.google>
EOF
)"
```

### 2. Prepare Review Packet & Security Scan

**Security Check (Fail Fast):**
Before asking for review, scan for common secrets to prevent accidental leaks.

```bash
# Quick grep for obvious secrets (API keys, tokens)
if grep -rE "sk-[a-zA-Z0-9]{20,}|ghp_[a-zA-Z0-9]{20,}|xox[baprs]-[a-zA-Z0-9]{10,}" . --exclude-dir={.git,node_modules,vendor,tmp}; then
    echo "❌ CRITICAL: Possible secrets detected! Workflow aborted."
    echo "Please clean up the history/files before proceeding."
    exit 1
fi
```

**Capture Screenshots (Local Only):**
For UI changes, capture screenshots to a local directory.

```bash
mkdir -p tmp/screenshots
# If dev server is needed: bin/dev
# agent-browser open http://localhost:3000/...
# agent-browser screenshot tmp/screenshots/after.png
echo "Screenshots saved to $(pwd)/tmp/screenshots/"
```

### 3. Push & PR

**Security & Verification Passed. Shipping...**


### 4. Push & PR



```bash
git push -u origin HEAD

gh pr create --title "Feature: [Description from commit]" --body "$(cat <<'EOF'
## Summary
- What was built
- Why it was needed

## Testing
- Tests added/modified

## Verification
- Local screenshots passed verification
- Security scan passed

---

[![Antigravity Cortex](https://img.shields.io/badge/Antigravity-Cortex-6366f1)](https://github.com/i3ringit/antigravity-cortex) 🤖 Generated with [Antigravity](http://antigravity.google/)
EOF
)"
```

## Success
Notify the user that the PR is live.
