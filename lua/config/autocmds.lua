vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- open NvimTree only if Neovim was started without arguments
    if vim.fn.argc() == 0 then
      require("nvim-tree.api").tree.open()
    end
  end,
})
