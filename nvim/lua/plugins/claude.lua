-- =========================================================
-- Claude Code integration (IDE bridge by Coder)
-- Requires the `claude` CLI on your PATH.
-- =========================================================

-- Opens AGENTS.md or CLAUDE.md from the project root (whichever
-- exists; prefers AGENTS.md). Falls back to creating AGENTS.md
-- if neither is present.
local function open_agent_file()
	local root = vim.fn.getcwd()
	for _, name in ipairs({ "AGENTS.md", "CLAUDE.md" }) do
		local path = root .. "/" .. name
		if vim.fn.filereadable(path) == 1 then
			vim.cmd.edit(path)
			return
		end
	end
	vim.cmd.edit(root .. "/AGENTS.md")
end

return {
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		config = true,
		keys = {
			{ "<leader>a", nil, desc = "+ai (Claude)" },
			{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<leader>aR", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
			{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
			{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
			{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
			{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny Claude diff" },
			{ "<leader>ag", open_agent_file, desc = "Open AGENTS.md / CLAUDE.md" },
		},
	},
}
