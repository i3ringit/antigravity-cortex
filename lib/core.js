const fs = require('fs-extra');
const path = require('path');
const { execSync } = require('child_process');

// Paths
const PKG_ROOT = path.resolve(__dirname, '..');
const SOURCE_ASSETS_DIR = path.join(PKG_ROOT, '.agent');
// When installed in a user project, we assume we are running from node_modules, 
// so the target project root is likely process.cwd()
const TARGET_ROOT = process.cwd();
const TARGET_AGENT_DIR = path.join(TARGET_ROOT, '.agent');
const MANIFEST_FILE = path.join(TARGET_AGENT_DIR, '.ag-cortex-manifest.json');

/**
 * Get all files in a directory recursively, returning paths relative to the base dir.
 */
async function walk(dir, baseDir = dir) {
    let results = [];
    try {
        const list = await fs.readdir(dir);
        for (const file of list) {
            const filePath = path.join(dir, file);
            const stat = await fs.stat(filePath);
            if (stat && stat.isDirectory()) {
                results = results.concat(await walk(filePath, baseDir));
            } else {
                results.push(path.relative(baseDir, filePath));
            }
        }
    } catch (e) {
        if (e.code === 'ENOENT') return [];
        if (e.code === 'EACCES') {
            console.error(chalk.red(`   ❌ Permission error accessing: ${dir}`));
        }
        throw e;
    }
    return results;
}

async function install() {
    const chalk = (await import('chalk')).default;
    console.log(chalk.blue(`📦 Installing Cortex assets to ${TARGET_AGENT_DIR}...`));

    // 1. Ensure source exists
    if (!await fs.pathExists(SOURCE_ASSETS_DIR)) {
        throw new Error(`Source assets not found at ${SOURCE_ASSETS_DIR}. Are you running from the package?`);
    }

    // 2. Get list of assets to install
    const sourceFiles = await walk(SOURCE_ASSETS_DIR);

    // 3. Prepare Manifest
    const newManifest = {
        files: sourceFiles,
        updatedAt: new Date().toISOString(),
        version: require('../package.json').version
    };

    // 4. Copy Files
    for (const file of sourceFiles) {
        const srcPath = path.join(SOURCE_ASSETS_DIR, file);
        const destPath = path.join(TARGET_AGENT_DIR, file);

        await fs.ensureDir(path.dirname(destPath));
        await fs.copy(srcPath, destPath, { overwrite: true });
    }
    console.log(chalk.green(`   ✅ Installed ${sourceFiles.length} files.`));

    console.log(chalk.green(`   ✅ Installed ${sourceFiles.length} files.`));

    // 5. Write Manifest
    await fs.writeJson(MANIFEST_FILE, newManifest, { spaces: 2 });
    console.log(chalk.blue(`   📄 Manifest written to ${MANIFEST_FILE}`));

    // 6. Setup Agent Browser
    const os = require('os');
    console.log(chalk.blue(`🌐 Setting up Agent Browser...`));

    const isLinux = os.platform() === 'linux';

    try {
        if (isLinux) {
            console.log(chalk.yellow(`   🐧 Linux detected: Attempting to install system dependencies...`));
            console.log(chalk.gray(`      (If this fails, you may need to run with sudo)`));
            execSync('npx agent-browser install --with-deps', { stdio: 'inherit', cwd: TARGET_ROOT });
        } else {
            execSync('npx agent-browser install', { stdio: 'inherit', cwd: TARGET_ROOT });
        }
        console.log(chalk.green(`   ✅ Agent Browser installed.`));
    } catch (e) {
        if (isLinux) {
            console.warn(chalk.yellow(`   ⚠️  Automatic setup failed. You likely need sudo for system dependencies.`));
            console.warn(chalk.bold(`       Please run: sudo npx agent-browser install --with-deps`));
        } else {
            console.warn(chalk.yellow(`   ⚠️  Agent Browser setup had issues. Try running: npx agent-browser install --with-deps`));
        }
    }
}

async function update() {
    const chalk = (await import('chalk')).default;
    console.log(chalk.blue(`🔄 Updating Cortex assets...`));

    // 1. Load Old Manifest
    let oldManifest = { files: [] };
    if (await fs.pathExists(MANIFEST_FILE)) {
        try {
            oldManifest = await fs.readJson(MANIFEST_FILE);
            console.log(chalk.gray(`   Found existing manifest (${oldManifest.files.length} tracked files)`));
        } catch (e) {
            console.warn(chalk.yellow(`   Warning: Could not read manifest. Assuming clean slate.`));
        }
    } else {
        console.log(chalk.yellow(`   No manifest found. Treating as clean install (no pruning).`));
    }

    // 2. Get New Assets List
    if (!await fs.pathExists(SOURCE_ASSETS_DIR)) throw new Error('Source assets missing.');
    const newFiles = await walk(SOURCE_ASSETS_DIR);
    const newFilesSet = new Set(newFiles);

    // 3. Prune Orphans
    // Orphan = File in oldManifest BUT NOT in newFiles
    let prunedCount = 0;
    for (const oldFile of oldManifest.files) {
        if (!newFilesSet.has(oldFile)) {
            // SECURITY: Prevent path traversal
            if (oldFile.includes('..') || path.isAbsolute(oldFile)) {
                console.warn(chalk.red(`   ⚠️ Security Warning: Skipping pruning of unsafe path: ${oldFile}`));
                continue;
            }

            const orphanPath = path.join(TARGET_AGENT_DIR, oldFile);
            if (await fs.pathExists(orphanPath)) {
                await fs.remove(orphanPath);
                console.log(chalk.red(`   🗑️  Pruned: ${oldFile}`));
                prunedCount++;
            }
        }
    }
    if (prunedCount > 0) console.log(chalk.green(`   ✅ Pruned ${prunedCount} orphaned files.`));

    // 4. Install/Update (Overwrite)
    // Run install to handle the copy and manifest update
    await install();
}

async function doctor() {
    const chalk = (await import('chalk')).default;
    console.log(chalk.bold('🩺 Cortex Doctor'));

    // Check agent-browser
    try {
        const packageJson = require('../package.json');
        const browserVersion = packageJson.dependencies['agent-browser'] || 'unknown';
        console.log(`   ✅ agent-browser dependency: ${browserVersion}`);
    } catch (e) {
        console.log(chalk.red(`   ❌ agent-browser check failed: ${e.message}`));
    }

    console.log(`   ✅ Environment: Node ${process.version}`);
    console.log(`   ✅ Package Source: ${PKG_ROOT}`);
}

module.exports = { install, update, doctor };
