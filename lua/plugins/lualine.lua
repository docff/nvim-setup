return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      extensions = { 'nvim-tree' },
      options = {
        -- You can change this to "catppuccin" since I see you have that theme installed!
        theme = "auto",
      },
      sections = {
        lualine_a = { "mode" },
        -- "branch" is the component that shows your git branch
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" }
      },
    })
  end,
}
