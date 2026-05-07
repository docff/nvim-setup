return {
	'nvim-telescope/telescope.nvim',
    tag = 'v0.2.0',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'dharmx/telescope-media.nvim'
    },

    config = function()
      require('telescope').setup({
        defaults = {
          layout_strategy = 'flex',
          layout_config = {
            flex = { flip_columns = 140 },
            horizontal = {
              prompt_position = 'bottom',
              preview_width = 0.55,
              width = 0.9,
              height = 0.85,
            },
            vertical = {
              prompt_position = 'bottom',
              preview_height = 0.5,
              width = 0.9,
              height = 0.9,
              mirror = false,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
        extensions = {
          media = {
            backend = 'viu',
            flags = {
              viu = {
                move = true,
              },
            },
            cache_path = vim.fn.stdpath('cache') .. '/telescope-media',
          },
        },
      })
      -- Important: load the extension
      require('telescope').load_extension('media')
    end,
}
