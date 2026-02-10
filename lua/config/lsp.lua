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
-- Enable servers
-- ========================
vim.lsp.enable({
  -- "pyright",
  "basedpyright",
  "rust_analyzer",
})

