#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const colors = {
  reset: "\x1b[0m",
  green: "\x1b[32m",
  blue: "\x1b[34m",
  red: "\x1b[31m",
  yellow: "\x1b[33m",
};

function log(color, message) {
  console.log(`${color}${message}${colors.reset}`);
}

const sourceDir = path.join(__dirname, "..");
const targetDir = process.cwd();

const itemsToCopy = [".claude", ".kira", ".mcp.json"];

async function install() {
  log(colors.blue, "🚀 SGT Claude Kit Installer");
  log(colors.blue, "================================");

  for (const item of itemsToCopy) {
    const src = path.join(sourceDir, item);
    const dest = path.join(targetDir, item);

    if (!fs.existsSync(src)) {
      log(colors.red, `⚠️  Warning: ${item} not found in package.`);
      continue;
    }

    if (fs.existsSync(dest)) {
      log(colors.yellow, `⚠️  ${item} already exists. Skipping...`);
      continue;
    }

    try {
      if (fs.lstatSync(src).isDirectory()) {
        fs.cpSync(src, dest, { recursive: true });
      } else {
        fs.copyFileSync(src, dest);
      }
      log(colors.green, `✓ ${item} installed`);
    } catch (err) {
      log(colors.red, `❌ Error installing ${item}: ${err.message}`);
    }
  }

  log(colors.blue, "================================");
  log(colors.green, "✅ Installation complete!");
  console.log("\n👉 Run \x1b[32mclaude\x1b[0m to start using SGT!\n");
}

install().catch((err) => {
  console.error(err);
  process.exit(1);
});
