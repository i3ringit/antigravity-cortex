# `ag-cortex` Release & Usage Guide

## 1. How to Use (Consumer)
In any project where you want to use Antigravity Cortex skills:

```bash
# 1. Install    - **Action**: `npm install -D ag-cortex`.
    - **NO SUBMODULE**. No git friction.
    - **Update**: Run `npx ag-cortex update`. It pulls the latest assets from your package into the project's `.agent/` folder safely.x update
```

## 2. How to Develop & Publish (The Forge)

The `antigravity-cortex` repository is the "Forge". Changes flow from here to NPM.

### A. Automatic Logic (Sync from Upstream)
Most changes come from the upstream `compound-engineering-plugin`.

1.  **Sync**: Run your `sync-upstream` workflow in `cortex-lab`.
    - This updates files in `cortex/.agent/`.
2.  **Commit**: Go to `cortex/` submodule and commit changes.
    ```bash
    cd cortex
    git add .
    git commit -m "feat: sync from upstream"
    ```

### B. Publish to NPM
NPM does **not** auto-update from GitHub. You must publish manually.

1.  **Bump Version**: You *must* update the `version` in `package.json`. NPM does not allow overwriting versions.
    ```bash
    npm version patch  # 0.1.0 -> 0.1.1
    # OR
    npm version minor  # 0.1.0 -> 0.2.0
    ```
2.  **Login (First time only)**:
    ```bash
    npm login
    ```
3.  **Publish**:
    ```bash
    npm publish
    ```

## 3. Lifecycle Diagram

```
[Upstream (EveryInc)]
       ⬇️ (workflows:sync-upstream)
[The Forge (cortex-lab/cortex)] --( git push )--> [GitHub Repo]
       ⬇️ (npm publish)
[NPM Registry (@latest)]
       ⬇️ (npm install -D)
[Your Project]
```
