-- lua/user/options.lua

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.wrap = false
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.updatetime = 250

if vim.fn.has("win32") == 1 then
  -- Launched from Git Bash, 'shell' is inherited from $SHELL, but the other
  -- shell options keep their cmd.exe defaults. Give bash the flags it expects,
  -- and forward slashes so it doesn't mangle temp file paths (:r !, :%!).
  if vim.o.shell:match("bash") then
    opt.shellslash = true
    opt.shellcmdflag = "-c"
    opt.shellquote = ""
    opt.shellxquote = ""
    opt.shellredir = ">%s 2>&1"
    opt.shellpipe = "2>&1 | tee"
  end

  -- With a sh-like 'shell', exepath()/executable() prefer extensionless shims
  -- (e.g. `npm`) over `npm.cmd`, which can't be spawned directly. Mason and
  -- vim.lsp resolve commands through these, so resolve them as cmd.exe would.
  local function resolve_as_cmd(fn)
    return function(...)
      local shell = vim.o.shell
      vim.o.shell = "cmd.exe"
      local ok, result = pcall(fn, ...)
      vim.o.shell = shell
      if not ok then
        error(result, 2)
      end
      return result
    end
  end
  vim.fn.exepath = resolve_as_cmd(vim.fn.exepath)
  vim.fn.executable = resolve_as_cmd(vim.fn.executable)
end

-- Disable unused providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

