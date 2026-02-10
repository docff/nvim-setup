return {
	'nvim-telescope/telescope.nvim',
    tag = 'v0.2.0',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'dharmx/telescope-media.nvim'
    },

    config = function()
      require('telescope').setup({
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
