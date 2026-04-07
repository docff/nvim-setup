return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown" },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function(ev)
        vim.keymap.set("n", "<C-p>", "<cmd>RenderMarkdown buf_toggle<CR>", {
          buffer = ev.buf,
          desc = "Toggle Markdown render",
        })
      end,
    })
  end,
}
