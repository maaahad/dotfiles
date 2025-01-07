-- kanagawa
-- return {
--   'rebelot/kanagawa.nvim',
--   config = function()
--     require('kanagawa').setup({})
--
--     -- setting up kanagawa as default colorscheme
--     vim.cmd("colorscheme kanagawa")
--   end
-- }

-- Solarized
return {
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
		require("solarized").setup(opts)
		vim.cmd.colorscheme("solarized")
	end,
}
