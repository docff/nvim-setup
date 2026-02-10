require('config.lazy')
require('config.keymaps')
require('config.lsp')
require('config.cmp')
require('config.options')
require('config.autocmds')

vim.o.background = 'dark'
vim.o.mousemoveevent = true

vim.cmd.colorscheme 'kanagawa'
-- vim.cmd.colorscheme "catppuccin-macchiato"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.winbar = "%=%#WinBar# %P "
