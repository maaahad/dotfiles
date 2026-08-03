-- =========================================================
-- Classic bottom command line instead of noice's floating
-- cmdline popup — everything else about noice stays default.
-- =========================================================
return {
	{
		"folke/noice.nvim",
		opts = {
			cmdline = {
				view = "cmdline", -- classic bottom cmdline (default is "cmdline_popup")
			},
		},
	},
}
