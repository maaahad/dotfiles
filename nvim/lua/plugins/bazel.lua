-- =========================================================
-- Bazel / Starlark support (BUILD, WORKSPACE, .bzl files)
-- This monorepo uses Bazel with bzlmod (see AGENTS.md).
-- =========================================================
return {
	-- Treesitter parser for Starlark (nvim's built-in filetype
	-- detection already maps .bazel/.bzl/BUILD to filetype "bzl")
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "starlark" })
		end,
	},

	-- Mason: buildifier (format + lint) and starpls (LSP)
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "buildifier", "starpls" })
		end,
	},

	-- LSP: starpls (filetype "bzl" is its default, matches nvim's detection)
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				starpls = {},
			},
		},
	},

	-- Formatting: buildifier via conform.nvim for bzl files
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				bzl = { "buildifier" },
			},
		},
	},
}
