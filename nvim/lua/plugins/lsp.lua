return {
	-- =========================================================
	-- Mason (NOTE: mason-org/*, NOT williamboman/*)
	-- =========================================================
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, {
				-- GraphQL
				"graphql-language-service-cli",
				-- TOML
				"taplo",
				-- extra formatters/linters not covered by extras
				"prettier", -- fallback formatter (css, html, ... — biome handles js/ts)
				"shfmt",
				"hadolint", -- Dockerfile linting
			})
			-- dedupe: avoids the "package already installing" race between
			-- this list and packages LazyVim extras already request
			local seen, deduped = {}, {}
			for _, pkg in ipairs(opts.ensure_installed) do
				if not seen[pkg] then
					seen[pkg] = true
					table.insert(deduped, pkg)
				end
			end
			opts.ensure_installed = deduped
		end,
	},

	-- =========================================================
	-- LSP: GraphQL + TOML servers on top of LazyVim defaults
	-- =========================================================
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				graphql = {
					filetypes = {
						"graphql",
						"gql",
						"typescriptreact",
						"javascriptreact",
						"typescript",
						"javascript",
					},
				},
				taplo = {},
			},
		},
	},
}
