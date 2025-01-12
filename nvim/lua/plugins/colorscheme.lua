-- kanagawa
return {
	{
		"maxmx03/solarized.nvim",
		-- lazy = false,
		priority = 1000,
		opts = {
			-- "spring" | "summer" | "autumn" | "winter" (default)
			variant = "spring",
		},
		config = function(_, opts)
			vim.o.termguicolors = true
			-- vim.o.background = "light"
			vim.o.background = "dark"

			-- Setting solarized as default colorscheme
			require("solarized").setup(opts)
			vim.cmd.colorscheme("solarized")
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		config = function(opts)
			require("kanagawa").setup(opts)
		end,
	},
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
}
