-- Tabbing
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smartindent = true

-- Ensure external CLIs (like tree-sitter) are visible in GUI/non-login sessions.
local path = vim.env.PATH or ""
if not path:find("/opt/homebrew/bin", 1, true) then
  vim.env.PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:" .. path
end

-- Cursor Color
vim.opt.guicursor= {
  "n-v-c:block",
  "i-ci-ve:ver25",
  "r-cr:hor20",
  "o:hor50"
}

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.termguicolors = true
vim.opt.modifiable = true

