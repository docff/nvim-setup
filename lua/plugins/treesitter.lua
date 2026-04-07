return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local ok, ts = pcall(require, "nvim-treesitter")
    if not ok then
      return
    end

    ts.setup({})
    ts.install({
      "python",
      "rust",
      "lua",
      "javascript",
      "typescript",
      "json",
      "yaml",
      "toml",
      "html",
      "css",
      "bash",
      "markdown",
      "markdown_inline",
      "vim",
      "vimdoc",
      "regex",
    })
  end,
}
