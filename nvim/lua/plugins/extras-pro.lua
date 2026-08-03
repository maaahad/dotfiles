-- =========================================================
-- Pro/advanced developer extras
-- =========================================================
return {
	-- Harpoon 2 — instant jumping between your 4-5 hot files
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		keys = function()
			local keys = {
				{
					"<leader>H",
					function()
						require("harpoon"):list():add()
					end,
					desc = "Harpoon: add file",
				},
				{
					"<leader>h",
					function()
						local harpoon = require("harpoon")
						harpoon.ui:toggle_quick_menu(harpoon:list())
					end,
					desc = "Harpoon: menu",
				},
			}
			for i = 1, 5 do
				table.insert(keys, {
					"<leader>" .. i,
					function()
						require("harpoon"):list():select(i)
					end,
					desc = "Harpoon: file " .. i,
				})
			end
			return keys
		end,
	},

	-- Diffview — proper PR-style diff & git history review
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: open" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: file history" },
		},
	},

	-- Package info for package.json (versions inline, upgrade hints)
	{
		"vuki656/package-info.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		event = "BufRead package.json",
		opts = {},
	},

	-- Better TS errors (translates cryptic TS diagnostics)
	{
		"dmmulroy/ts-error-translator.nvim",
		ft = { "typescript", "typescriptreact" },
		opts = {},
	},

	-- =========================================================
	-- Terminal
	-- LazyVim already ships a floating terminal via snacks.nvim:
	--   <C-/>       toggle terminal
	--   <leader>ft  terminal at project root
	--   <leader>gg  lazygit
	-- toggleterm added for persistent horizontal/vertical terms:
	-- =========================================================
	{
		"akinsho/toggleterm.nvim",
		cmd = { "ToggleTerm", "TermExec" },
		keys = {
			{ "<leader>Th", "<cmd>ToggleTerm direction=horizontal size=15<cr>", desc = "Terminal: horizontal" },
			{ "<leader>Tv", "<cmd>ToggleTerm direction=vertical size=80<cr>", desc = "Terminal: vertical" },
		},
		opts = { shade_terminals = false },
	},
}
