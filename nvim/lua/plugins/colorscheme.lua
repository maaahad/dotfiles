return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight-day")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		-- config = function(_, opts)
		-- 	require("catppuccin").setup(opts)
		-- 	vim.cmd.colorscheme("catppuccin-latte")
		-- end,
	},
	{
		"maxmx03/solarized.nvim",
		priority = 1000,
		opts = {
			-- "spring" | "summer" | "autumn" | "winter" (default)
			variant = "spring",
		},
		config = function(_, opts)
			vim.o.termguicolors = true
			vim.o.background = "light"
			-- vim.o.background = "dark"

			require("solarized").setup(opts)
			-- vim.cmd.colorscheme("solarized")
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		config = function(opts)
			require("kanagawa").setup(opts)
		end,
	},
	{
		"andersevenrud/nordic.nvim",
		config = function()
			require("nordic").colorscheme({
				underline_option = "none",
				-- italic = true,
				italic_comments = false,
				minimal_mode = false,
				alternate_backgrounds = false,
			})
		end,
	},
}
