#!/usr/bin/env node
// Claude Code status line: <model> · <branch>[*] · ctx <pct>% · $<cost>
const { execSync } = require('child_process');

const RESET = '\x1b[0m';
const BOLD = '\x1b[1m';
const CYAN = '\x1b[36m';
const GREEN = '\x1b[32m';
const YELLOW = '\x1b[33m';
const RED = '\x1b[31m';
const style = (code, s) => `${BOLD}${code}${s}${RESET}`;

let input = '';
process.stdin.on('data', (d) => (input += d));
process.stdin.on('end', () => {
  let data;
  try {
    data = JSON.parse(input);
  } catch {
    data = {};
  }

  const model = data?.model?.display_name || data?.model?.id || 'unknown';
  const cwd = data?.workspace?.current_dir || data?.cwd || '.';

  let branchPart = '';
  try {
    const branch = execSync('git --no-optional-locks rev-parse --abbrev-ref HEAD', {
      cwd,
      stdio: ['ignore', 'pipe', 'ignore'],
    })
      .toString()
      .trim();
    if (branch) {
      let dirty = false;
      try {
        execSync('git --no-optional-locks diff --quiet', { cwd, stdio: 'ignore' });
      } catch {
        dirty = true;
      }
      if (!dirty) {
        try {
          execSync('git --no-optional-locks diff --cached --quiet', { cwd, stdio: 'ignore' });
        } catch {
          dirty = true;
        }
      }
      if (!dirty) {
        const untracked = execSync('git --no-optional-locks ls-files --others --exclude-standard', {
          cwd,
          stdio: ['ignore', 'pipe', 'ignore'],
        })
          .toString()
          .trim();
        if (untracked) dirty = true;
      }
      const branchLabel = `${branch}${dirty ? '*' : ''}`;
      branchPart = ` · ${style(dirty ? YELLOW : GREEN, branchLabel)}`;
    }
  } catch {
    // not a git repo; omit branch section
  }

  let ctxPart = '';
  const ctxPct = data?.context_window?.used_percentage ?? data?.context?.usage;
  if (ctxPct !== undefined && ctxPct !== null) {
    const pct = Math.round(Number(ctxPct));
    const ctxColor = pct >= 80 ? RED : pct >= 50 ? YELLOW : GREEN;
    ctxPart = ` · ${style(ctxColor, `ctx ${pct}%`)}`;
  }

  const cost = Number(data?.cost?.total_cost_usd ?? 0);
  const costPart = ` · ${style(CYAN, `$${cost.toFixed(2)}`)}`;

  process.stdout.write(`${style(CYAN, model)}${branchPart}${ctxPart}${costPart}\n`);
});
