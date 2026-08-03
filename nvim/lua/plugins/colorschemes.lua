-- =========================================================
-- Colorschemes: Cursor Dark Midnight (DEFAULT), Oxocarbon,
--               Rusty, Material, Catppuccin, Nord, Dracula,
--               IntelliJ Light
-- Switch anytime with <leader>uC (colorscheme picker)
-- =========================================================
return {
	{
		-- Faithful port of Cursor's default dark themes
		-- variants: cursor-dark | cursor-dark-midnight
		"ydkulks/cursor-dark.nvim",
		lazy = false,
		priority = 1000,
		opts = { transparent = false },
	},
	{
		"armannikoyan/rusty", -- "rusty" — Tomorrow Night–inspired, easy on the eyes
		lazy = true,
		opts = { transparent = false, italic_comments = true },
	},
	{
		"marko-cerovac/material.nvim",
		lazy = true,
		init = function()
			vim.g.material_style = "deep ocean" -- darker | lighter | oceanic | palenight | deep ocean
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		opts = {
			flavour = "mocha", -- latte | frappe | macchiato | mocha
			integrations = {
				blink_cmp = true,
				gitsigns = true,
				neotest = true,
				noice = true,
				mason = true,
				which_key = true,
				snacks = true,
				dap = true,
				dap_ui = true,
			},
		},
	},
	{ "shaunsingh/nord.nvim", lazy = true },
	{
		"Mofiqul/dracula.nvim",
		lazy = true,
		opts = {
			transparent_bg = false,
		},
	},
	{
		"nyoom-engineering/oxocarbon.nvim", -- IBM Carbon–inspired dark/light theme
		lazy = true,
		init = function()
			vim.opt.background = "dark" -- set to "light" for the light variant
		end,
	},
	{
		"gilbertfrancois/intellij_light.nvim", -- CLion/IntelliJ default light theme
		lazy = true,
	},

	-- =========================================================
	-- DEFAULT: cursor-dark-midnight (Cursor's "Dark Midnight")
	-- Other options: "cursor-dark" / "oxocarbon" /
	-- "rusty" / "material" / "catppuccin" / "nord" / "dracula" /
	-- "intellij_light"
	-- =========================================================
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "cursor-dark-midnight",
		},
	},
}
