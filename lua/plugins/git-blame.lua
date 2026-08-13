return {
  "f-person/git-blame.nvim",
  event = "VeryLazy",
  opts = {
    enabled = true, -- toggle off on demand with <leader>gB
    message_template = "  <author> • <date> • <summary>",
    date_format = "%r",
    virtual_text_column = 1,
  },
  keys = {
    { "<leader>gB", "<cmd>GitBlameToggle<cr>",       desc = "Git blame toggle" },
    { "<leader>gO", "<cmd>GitBlameOpenCommitURL<cr>", desc = "Git blame open commit URL" },
    { "<leader>gY", "<cmd>GitBlameCopySHA<cr>",       desc = "Git blame copy SHA" },
  },
}
