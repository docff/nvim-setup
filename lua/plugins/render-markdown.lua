return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "master",
      lazy = false,
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "markdown", "markdown_inline" },
          auto_install = true,
          highlight = { enable = true },
        })
      end,
    },
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
