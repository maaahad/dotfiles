-- =========================================================
-- Neotest — FIX for "No tests found"
-- test.core ships no adapters; we register them here.
-- Rust adapter comes from the rust extra (rustaceanvim.neotest)
-- Go adapter comes from the go extra (neotest-golang)
-- Below we add the React/TS adapters.
--
-- Keymaps (from test.core):
--   <leader>tt run file   <leader>tr run nearest
--   <leader>ts summary    <leader>to output panel
--   <leader>tl run last   <leader>tw watch file
-- =========================================================
return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"marilari88/neotest-vitest",
			"nvim-neotest/neotest-jest",
			"thenbe/neotest-playwright",
		},
		opts = {
			adapters = {
				-- Vitest (most modern React setups)
				["neotest-vitest"] = {
					filter_dir = function(name)
						return name ~= "node_modules"
					end,
				},
				-- Jest (CRA / older React setups)
				["neotest-jest"] = {
					jestCommand = "npx jest",
					cwd = function()
						return vim.fn.getcwd()
					end,
				},
				-- Playwright e2e tests
				["neotest-playwright"] = {
					options = {
						persist_project_selection = true,
						enable_dynamic_test_discovery = true,
					},
				},
			},
			-- nicer output
			output = { open_on_run = true },
			status = { virtual_text = true },
		},
	},
}
