import { readdirSync, lstatSync, readlinkSync, mkdirSync, rmSync, renameSync, symlinkSync } from "fs";
import { join, resolve, basename } from "path";
import { homedir } from "os";
import { createInterface } from "readline";

const DOTFILES_DIR = resolve(import.meta.dirname);
const HOME = homedir();
const BACKUP_DIR = join(HOME, ".dotfiles_backup");

const SKIP = new Set([
  "install.mjs",
  "restore.mjs",
  "setup_zsh.sh",
  "README",
  "README.md",
  "README.rdoc",
  "LICENSE",
  "node_modules",
  "package.json",
  "ttf-bitstream-vera-1.10",
  "nvim_config",
]);

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

function isIdenticalSymlink(target, source) {
  const stat = lstatSync(target, { throwIfNoEntry: false });
  return stat?.isSymbolicLink() && readlinkSync(target) === source;
}

function linkFile(source, target) {
  console.log(`linking ${target}`);
  symlinkSync(source, target);
}

function backupFile(target) {
  mkdirSync(BACKUP_DIR, { recursive: true });
  const dest = join(BACKUP_DIR, basename(target));
  // If a previous backup exists, remove it first
  rmSync(dest, { recursive: true, force: true });
  renameSync(target, dest);
  console.log(`backed up ${target} -> ${dest}`);
}

function replaceFile(source, target) {
  backupFile(target);
  linkFile(source, target);
}

async function handleLink(source, target, label, replaceAll) {
  if (!pathExists(target)) {
    linkFile(source, target);
    return replaceAll;
  }

  if (isIdenticalSymlink(target, source)) {
    console.log(`identical ${label}`);
    return replaceAll;
  }

  if (replaceAll) {
    replaceFile(source, target);
    return replaceAll;
  }

  const answer = await prompt(`overwrite ${label}? [ynaq] `);
  switch (answer) {
    case "a":
      replaceFile(source, target);
      return true;
    case "y":
      replaceFile(source, target);
      return replaceAll;
    case "q":
      process.exit(0);
    default:
      console.log(`skipping ${label}`);
      return replaceAll;
  }
}

async function installDotfiles() {
  const entries = readdirSync(DOTFILES_DIR);
  let replaceAll = false;

  for (const file of entries) {
    if (SKIP.has(file) || file.startsWith(".")) continue;

    const source = join(DOTFILES_DIR, file);
    const target = join(HOME, `.${file}`);
    replaceAll = await handleLink(source, target, `~/.${file}`, replaceAll);
  }

  // Neovim config setup
  const nvimSource = join(DOTFILES_DIR, "nvim_config");
  const configDir = join(HOME, ".config");
  const nvimTarget = join(configDir, "nvim");

  mkdirSync(configDir, { recursive: true });
  await handleLink(nvimSource, nvimTarget, "~/.config/nvim", replaceAll);
}

installDotfiles();
