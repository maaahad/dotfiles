return {
  'rebelot/kanagawa.nvim', 
  config = function()
    require('kanagawa').setup({})

    -- setting up kanagawa as default colorscheme
    vim.cmd("colorscheme kanagawa")
  end
}
