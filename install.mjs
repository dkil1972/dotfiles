import { readdirSync, lstatSync, readlinkSync, mkdirSync, rmSync, renameSync, symlinkSync } from "fs";
import { join, resolve, basename } from "path";
import { homedir } from "os";
import { createInterface } from "readline";

const DOTFILES_DIR = resolve(import.meta.dirname);
const HOME = homedir();
const BACKUP_DIR = join(HOME, ".dotfiles_backup");

const IS_WINDOWS = process.platform === "win32";

const SKIP = new Set([
  "install.mjs",
  "restore.mjs",
  "setup_zsh.sh",
  "setup_linux.sh",
  "README",
  "README.md",
  "README.rdoc",
  "LICENSE",
  "node_modules",
  "package.json",
  "ttf-bitstream-vera-1.10",
  "nvim_config",
  "claude_config",
  "windows",
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

  // Neovim config — different location on Windows vs *nix
  const nvimSource = join(DOTFILES_DIR, "nvim_config");
  if (IS_WINDOWS) {
    const nvimTarget = join(HOME, "AppData", "Local", "nvim");
    mkdirSync(join(HOME, "AppData", "Local"), { recursive: true });
    replaceAll = await handleLink(nvimSource, nvimTarget, "~/AppData/Local/nvim", replaceAll);
  } else {
    const configDir = join(HOME, ".config");
    const nvimTarget = join(configDir, "nvim");
    mkdirSync(configDir, { recursive: true });
    replaceAll = await handleLink(nvimSource, nvimTarget, "~/.config/nvim", replaceAll);
  }

  // Claude Code settings — symlink into ~/.claude/ (not the whole dir)
  const claudeSource = join(DOTFILES_DIR, "claude_config", "settings.json");
  const claudeDir = join(HOME, ".claude");
  mkdirSync(claudeDir, { recursive: true });
  const claudeTarget = join(claudeDir, "settings.json");
  replaceAll = await handleLink(claudeSource, claudeTarget, "~/.claude/settings.json", replaceAll);

  // Windows-specific configs
  if (IS_WINDOWS) {
    await installWindowsConfigs(replaceAll);
  }
}

async function installWindowsConfigs(replaceAll) {
  const windowsDir = join(DOTFILES_DIR, "windows");

  // Windows Terminal
  const terminalSource = join(windowsDir, "terminal", "settings.json");
  const terminalDir = findWindowsTerminalDir();
  if (terminalDir) {
    const terminalTarget = join(terminalDir, "settings.json");
    replaceAll = await handleLink(terminalSource, terminalTarget, "Windows Terminal settings.json", replaceAll);
  } else {
    console.log("skipping Windows Terminal (not found)");
  }

  // VS Code
  const vscodeSource = join(windowsDir, "vscode", "settings.json");
  const vscodeDir = join(process.env.APPDATA, "Code", "User");
  if (pathExists(vscodeDir)) {
    const vscodeTarget = join(vscodeDir, "settings.json");
    replaceAll = await handleLink(vscodeSource, vscodeTarget, "VS Code settings.json", replaceAll);
  } else {
    console.log("skipping VS Code (not found)");
  }
}

function findWindowsTerminalDir() {
  const packagesDir = join(process.env.LOCALAPPDATA, "Packages");
  if (!pathExists(packagesDir)) return null;
  try {
    const match = readdirSync(packagesDir).find((d) => d.startsWith("Microsoft.WindowsTerminal"));
    if (!match) return null;
    const dir = join(packagesDir, match, "LocalState");
    return pathExists(dir) ? dir : null;
  } catch {
    return null;
  }
}

installDotfiles();
