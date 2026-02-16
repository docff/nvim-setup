vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- open NvimTree only if Neovim was started without arguments
    if vim.fn.argc() == 0 then
      require("nvim-tree.api").tree.open()
    end
  end,
})

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  callback = function()
    local ft = vim.bo.filetype
    vim.schedule(function()
      if ft == "NvimTree" then
        return
      elseif ft == "oil" then
        local bufname = vim.api.nvim_buf_get_name(0)
        local path = bufname:gsub("^oil://", "")
        path = vim.fn.fnamemodify(path, ":~")
        vim.wo.winbar = "%=%#WinBar#  " .. path .. " "
      else
        local dir = vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":~")
        vim.wo.winbar = "%=%#WinBar#  " .. dir .. " "
      end
    end)
  end,
})
