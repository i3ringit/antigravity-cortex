#!/usr/bin/env node

const { program } = require('commander');
const { install, update, doctor } = require('../lib/core');

// Use dynamic import for chalk since v5 is ESM-only
// Or use a wrapper. For simplicity in this script, we'll try standard require.
// If chalk v5+ is pure ESM, we might need to stick to chalk@4 or use dynamic import.
// Let's use dynamic import pattern or fix chalk version in package.json to ^4.1.2 if we want CommonJS.
// However, let's try to be modern. We'll wrap in an async IIFE.

(async () => {
    const chalk = (await import('chalk')).default;

    console.log(chalk.bold.blue('🔮 Antigravity Cortex CLI'));

    program
        .name('ag-cortex')
        .description('Manage Antigravity skills, rules, and workflows')
        .version('0.1.0');

    program
        .command('install')
        .description('Install Cortex assets into the current project')
        .action(async () => {
            try {
                await install();
            } catch (error) {
                console.error(chalk.red('Installation failed:'), error.message);
                process.exit(1);
            }
        });

    program
        .command('update')
        .description('Update Cortex assets and prune orphaned files')
        .action(async () => {
            try {
                await update();
            } catch (error) {
                console.error(chalk.red('Update failed:'), error.message);
                process.exit(1);
            }
        });

    program
        .command('doctor')
        .description('Verify installation and dependencies')
        .action(async () => {
            await doctor();
        });

    program.parse();
})();
