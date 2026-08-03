-- =========================================================
-- Test coverage signs in the gutter + summary popup.
-- Doesn't run tests itself — just renders a coverage report
-- that your test runner already produced.
--
--   Go     : go test ./... -coverprofile=coverage.out
--   TS/JS  : vitest run --coverage / jest --coverage
--            (needs the "lcov" reporter enabled so
--            coverage/lcov.info is written)
--   Rust   : uses grcov by default (see :h nvim-coverage-rust).
--            If you use cargo-tarpaulin instead, generate an
--            lcov file and load it with :CoverageLoadLcov.
--
--   <leader>tc  load + show coverage signs
--   <leader>tC  coverage summary popup
--   <leader>tx  clear coverage signs
-- =========================================================
return {
	{
		"andythigpen/nvim-coverage",
		dependencies = "nvim-lua/plenary.nvim",
		cmd = { "Coverage", "CoverageLoad", "CoverageShow", "CoverageHide", "CoverageToggle", "CoverageSummary" },
		opts = {
			auto_reload = true,
		},
		keys = {
			{ "<leader>tc", "<cmd>Coverage<cr>", desc = "Coverage: load + show" },
			{ "<leader>tC", "<cmd>CoverageSummary<cr>", desc = "Coverage: summary" },
			{ "<leader>tx", "<cmd>CoverageClear<cr>", desc = "Coverage: clear" },
		},
	},
}
