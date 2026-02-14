import { readdirSync, lstatSync, readlinkSync, mkdirSync, rmSync, renameSync } from "fs";
import { join, resolve, basename } from "path";
import { homedir } from "os";
import { createInterface } from "readline";

const HOME = homedir();
const BACKUP_DIR = join(HOME, ".dotfiles_backup");
const CONFIG_DIR = join(HOME, ".config");

function prompt(question) {
  const rl = createInterface({ input: process.stdin, output: process.stdout });
  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      rl.close();
      resolve(answer.trim().toLowerCase());
    });
  });
}

function pathExists(p) {
  return lstatSync(p, { throwIfNoEntry: false }) !== undefined;
}

async function restore() {
  if (!pathExists(BACKUP_DIR)) {
    console.log("No backups found at " + BACKUP_DIR);
    process.exit(0);
  }

  const backups = readdirSync(BACKUP_DIR);
  if (backups.length === 0) {
    console.log("Backup directory is empty, nothing to restore.");
    process.exit(0);
  }

  console.log(`Found ${backups.length} backup(s) in ${BACKUP_DIR}:\n`);
  for (const file of backups) {
    console.log(`  ${file}`);
  }
  console.log();

  const answer = await prompt("Restore all backups? [y/n] ");
  if (answer !== "y") {
    console.log("Aborted.");
    process.exit(0);
  }

  for (const file of backups) {
    const backup = join(BACKUP_DIR, file);

    // Determine restore target — "nvim" goes to ~/.config/nvim, others to ~/.<file>
    const target = file === "nvim"
      ? join(CONFIG_DIR, "nvim")
      : join(HOME, file.startsWith(".") ? file : `.${file}`);

    if (pathExists(target)) {
      rmSync(target, { recursive: true, force: true });
      console.log(`removed ${target}`);
    }

    renameSync(backup, target);
    console.log(`restored ${target}`);
  }

  // Clean up empty backup directory
  rmSync(BACKUP_DIR, { recursive: true, force: true });
  console.log(`\nRemoved ${BACKUP_DIR}`);
  console.log("Restore complete.");
}

restore();
