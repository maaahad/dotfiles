return {
  {
    "ellisonleao/gruvbox.nvim",
    config = function()
      require("gruvbox").setup()
      vim.o.background = "light"
      vim.cmd("colorscheme gruvbox")
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    config = function()
      require("nightfox").setup()
    end,
  },
}
