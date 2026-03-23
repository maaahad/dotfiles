return {
  {
    "armannikoyan/rusty",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      italic_comments = true,
      underline_current_line = true,
      colors = {
        foreground = "#c5c8c6",
        background = "#1d1f21",
        selection = "#373b41",
        line = "#282a2e",
        comment = "#969896",
        red = "#cc6666",
        orange = "#de935f",
        yellow = "#f0c674",
        green = "#b5bd68",
        aqua = "#8abeb7",
        blue = "#81a2be",
        purple = "#b294bb",
        window = "#4d5057",
      },
    },
    config = function(_, opts)
      require("rusty").setup(opts)
      -- vim.cmd("colorscheme rusty")
    end,
  },
  {
    "neanias/everforest-nvim",
  },
  {
    "shaunsingh/nord.nvim",
  },
  {
    "smit4k/shale.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme("shale")
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      vim.cmd("colorscheme rose-pine")
    end,
  },
}
