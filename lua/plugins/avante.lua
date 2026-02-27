return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Always use latest
  build = "make",
  opts = {
    provider = "claude",
    tokenizer = "tiktoken",
    providers = {
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-6",
        extra_request_body = {
          temperature = 0,
          max_tokens = 8096,
        },
      },
    },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    {
      "stevearc/dressing.nvim",
      opts = {
        select = {
          enabled = false,
        },
      },
    },
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = { insert_mode = true },
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = { file_types = { "markdown", "Avante" } },
      ft = { "markdown", "Avante" },
    },
  },
}
