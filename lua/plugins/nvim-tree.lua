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
      git = {
        enable = true,
        ignore = false,
      },
      renderer = {
        highlight_git = "name",
        icons = {
          show = {
            git = true,
          },
        },
      },
      view = {
        adaptive_size = false,
        width = 30,
        preserve_window_proportions = true,
      },
      live_filter = {
        always_show_folders = false,
      },
      on_attach = function (bufnr)
        local api = require("nvim-tree.api")
        local preview = require("utils.media_preview")

        api.map.on_attach.default(bufnr)

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

        vim.keymap.set("n", "o", api.fs.create, opts("Create file/directory"))
      end,
    })
  end
}

