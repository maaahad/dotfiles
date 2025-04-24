-- Test with neotest, (golang and vitest)
return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'marilari88/neotest-vitest',
    'fredrikaverpil/neotest-golang',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-vitest' {
          -- Filter directories when searching for test files. Useful in large projects
          fioter_dir = function(name, rel_path, _root)
            return name ~= 'node_modules'
          end,
        },
        require 'neotest-golang',
      },
    }
  end,
}
