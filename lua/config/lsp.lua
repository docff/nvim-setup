-- ========================
-- LSP capabilities for completion
-- ========================
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- ========================
-- Python (pyright)
-- ========================
-- vim.lsp.config.pyright = {
vim.lsp.config.basedpyright = {
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
      },
    },
  },
}

-- ========================
-- Rust (rust-analyzer)
-- ========================
vim.lsp.config.rust_analyzer = {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = true,
    },
  },
}

-- ========================
-- Swift (sourcekit-lsp)
-- ========================
vim.lsp.config.sourcekit = {
  capabilities = capabilities,
  cmd = { "sourcekit-lsp" },
  filetypes = { "swift", "objc", "objcpp" },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local util = vim.fs
    -- Walk up looking for SwiftPM, then any .xcworkspace/.xcodeproj, then .git
    local root = util.root(fname, { "Package.swift", "buildServer.json", "compile_commands.json" })
    if not root then
      local dir = vim.fs.dirname(fname)
      for parent in vim.fs.parents(fname) do
        local matches = vim.fn.glob(parent .. "/*.xcworkspace", false, true)
        if #matches == 0 then
          matches = vim.fn.glob(parent .. "/*.xcodeproj", false, true)
        end
        if #matches > 0 then
          root = parent
          break
        end
      end
      if not root then
        root = util.root(fname, { ".git" }) or dir
      end
    end
    on_dir(root)
  end,
}

-- ========================
-- Enable servers
-- ========================
vim.lsp.enable({
  -- "pyright",
  "basedpyright",
  "rust_analyzer",
  "sourcekit",
})

