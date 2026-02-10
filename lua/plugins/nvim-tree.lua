return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      actions = {
        open_file = {
          quit_on_open = false,
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        dotfiles = false,
        custom = {},
        exclude = {},
      },
      view = {
        adaptive_size = true,
      },
      live_filter = {
        always_show_folders = false,
      },
      on_attach = function (bufnr)
        local api = require("nvim-tree.api")
        local preview = require("utils.media_preview")
        local function opts(desc)
          return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
          }
        end
        vim.keymap.set("n", "<C-p>", function()
          local node = api.tree.get_node_under_cursor()
          if node and node.absolute_path then
            preview.preview(node.absolute_path)
          end
        end, opts("Preview media"))

        vim.keymap.set("n", "<CR>", function()
          local node = api.tree.get_node_under_cursor()
          if node.type == "directory" then
            api.node.open.edit()
          elseif node.type == "file" then
            api.node.open.vertical()
          end
        end, opts("Open directory / file (vertical split)"))

        -- vim.keymap.set("n", "o", api.fs.create, opts("Create"))
        -- vim.keymap.set("n", "ce", api.fs.rename, opts("Rename"))
        -- vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
        -- vim.keymap.set("n", "v", api.fs.paste, opts("Paste"))
        -- vim.keymap.set("n", "d", api.fs.trash, opts("Trash"))
        -- vim.keymap.set("n", "D", api.fs.remove, opts("Delete"))
        -- vim.keymap.set("n", "g.", api.tree.toggle_hidden_filter, opts("Dotfiles"))
      end,
    })
  end
}

