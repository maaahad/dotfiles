return {
  'renerocksai/telekasten.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('telekasten').setup {
      home = vim.fn.expand '~/zettelkasten', -- your notes folder

      -- Optional template settings
      template_new_note = 'templates/note.md',
      template_new_daily = 'templates/daily.md',

      -- Optional key mappings
      take_over_my_home = true, -- map all default bindings
      auto_set_filetype = false, -- if you use ftplugins manually

      -- Optional extensions
      dailies = '~/zettelkasten/daily',
      weeklies = '~/zettelkasten/weekly',
      image_subdir = 'images', -- subfolder for pasted images
      extension = '.md', -- file extension

      -- Customize how notes are linked
      new_note_filename = 'title',
      uuid_type = 'rand', -- or "datetime", "incremental"

      -- Telescope options
      telescope_args = {
        layout_config = {
          width = 0.9,
          height = 0.8,
        },
      },
    }
  end,
}
