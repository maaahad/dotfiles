-- =========================================================
-- Treesitter parsers for the whole stack
-- =========================================================
return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"graphql",
				"http",
				"sql",
				"tsx",
				"typescript",
				"javascript",
				"rust",
				"go",
				"gomod",
				"gosum",
				"gowork",
				"css",
				"scss",
				"html",
				"markdown",
				"markdown_inline",
				"dockerfile",
				"toml",
				"json",
				"yaml",
				"lua",
				"bash",
			},
		},
	},
}
