return {
  "stevearc/oil.nvim",
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function ()
    local preview = require("utils.media_preview")
    require("oil").setup({
      -- keymaps = {
      --   ["g?"] = { "actions.show_help", mode = "n" },
      --   ["<CR>"] = "actions.select",
      --   ["<C-s>"] = { "actions.select", opts = { vertical = true } },
      --   ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
      --   ["<C-t>"] = { "actions.select", opts = { tab = true } },
      --   ["<C-p>"] = "actions.preview",
      --   ["<C-c>"] = { "actions.close", mode = "n" },
      --   ["<C-l>"] = "actions.refresh",
      --   ["-"] = { "actions.parent", mode = "n" },
      --   ["_"] = { "actions.open_cwd", mode = "n" },
      --   ["`"] = { "actions.cd", mode = "n" },
      --   ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
      --   ["gs"] = { "actions.change_sort", mode = "n" },
      --   ["gx"] = "actions.open_external",
      --   ["g."] = { "actions.toggle_hidden", mode = "n" },
      --   ["g\\"] = { "actions.toggle_trash", mode = "n" },
      -- },
      case_insensitive = false,
      natural_order = "fast",

      -- keymaps = {
      --   ["p"] = function()
      --     local entry = require("oil").get_cursor_entry()
      --     if not entry then return end
      --
      --     local path = require("oil").get_current_dir() .. entry.name
      --     preview.preview(path)
      --   end,
      -- },    -- Force oil to open in a left vertical split
      columns = {
        "permissions",
        "icon",
        -- "size",
        -- "mtime",
      },
      constrain_cursor = "editable",
      -- use_default_keymaps = true,
      watch_for_changes = true,

      window = {
        width = 30,
      },
      preview = {
        open_cmd = "botright vsplit",
      },
    })
    -- local api = require("oil").api
    -- vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
    --   pattern = "*",
    --   callback = function()
    --     if vim.bo.filetype == "oil" then
    --       local ok, oil = pcall(require, "oil")
    --       if ok and oil and oil.api then
    --         api.refresh()
    --       end
    --     end
    --   end,
    -- })
  end,
}

