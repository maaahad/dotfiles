return {
  'rest-nvim/rest.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, 'http')
    end,
  },
  config = function()
    vim.keymap.set('n', '<leader>Rs', ':Rest run<CR>', { desc = '[S]end the request' })
    vim.keymap.set('n', '<leader>Rr', ':Rest open<CR>', { desc = 'Open the [R]esult pane' })
  end,
}
