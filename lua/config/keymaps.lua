-- LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })
vim.keymap.set("n", "K",  vim.lsp.buf.hover, { desc = "Hover docs" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

-- Telescope
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, opts)
vim.keymap.set("n", "<leader>fg", builtin.live_grep, opts)
vim.keymap.set("n", "<leader>fb", builtin.buffers, opts)
vim.keymap.set("n", "<leader>fh", builtin.help_tags, opts)
vim.keymap.set("n", "<leader>fm", function()
  local cwd = vim.fn.expand("%:p:h")
  require("telescope").extensions.media.media({
    search_dirs = { cwd },
  })
end, { desc = "Find media in current directory", })

vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Git files" })
vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })

vim.keymap.set("n", "<leader>fp", function()
  builtin.find_files({ cwd = vim.fn.getcwd() })
end, { desc = "Find project files" })

-- LSP via Telescope
local tb = require("telescope.builtin")

vim.keymap.set("n", "gd", tb.lsp_definitions, { desc = "Definitions" })
vim.keymap.set("n", "gr", tb.lsp_references, { desc = "References" })
vim.keymap.set("n", "gi", tb.lsp_implementations, { desc = "Implementations" })
vim.keymap.set("n", "<leader>ds", tb.lsp_document_symbols, { desc = "Document symbols" })
vim.keymap.set("n", "<leader>ws", tb.lsp_workspace_symbols, { desc = "Workspace symbols" })

-- Oil
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open file explorer" })

-- nvim-tree
-- Store last editor window before jumping to nvim-tree
local last_editor_win = nil
vim.keymap.set("n", "<leader>e", function()
  local api = require("nvim-tree.api")
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_win_get_buf(current_win)

  -- Helper: check if a window is an editor window
  local function is_editor(win)
    local buf = vim.api.nvim_win_get_buf(win)
    return vim.bo[buf].filetype ~= "NvimTree"
  end

  -- Case 1: tree not open → open & focus, remember editor
  if not api.tree.is_visible() then
    if is_editor(current_win) then
      last_editor_win = current_win
    end
    api.tree.open({ focus = true })
    return
  end

  -- Case 2: tree is focused → jump back to last editor
  if vim.bo[current_buf].filetype == "NvimTree" then
    if last_editor_win and vim.api.nvim_win_is_valid(last_editor_win) then
      vim.api.nvim_set_current_win(last_editor_win)
    else
      -- fallback: first available editor window
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if is_editor(win) then
          vim.api.nvim_set_current_win(win)
          break
        end
      end
    end
    return
  end

  -- Case 3: editor focused → remember it, jump to tree
  last_editor_win = current_win
  api.tree.focus()
end, { desc = "Smart focus toggle: nvim-tree ↔ last editor" })

-- Diagnostics
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })
-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

vim.diagnostic.config({
  float = { border = "rounded" },
})

-- Lines
vim.keymap.set("n", "<leader>ln", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle relative numbers" })

-- Eagle
-- vim.keymap.set('n', '<Tab>', ':EagleWin<CR>', { noremap = true, silent = true })
