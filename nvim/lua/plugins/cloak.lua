-- =========================================================
-- Mask secret values in .env files on screen
-- (screen-share / pairing / screenshot safety)
-- Toggle visibility with <leader>ce
-- =========================================================
return {
	{
		"laytan/cloak.nvim",
		event = "BufReadPre",
		opts = {
			enabled = true,
			cloak_character = "*",
			highlight_group = "Comment",
			patterns = {
				{
					file_pattern = { ".env*", ".env.*" },
					cloak_pattern = "=.+",
					replace = nil,
				},
			},
		},
		keys = {
			{ "<leader>ce", "<cmd>CloakToggle<cr>", desc = "Toggle .env secret masking" },
		},
	},
}
