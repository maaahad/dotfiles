-- =========================================================
-- Snacks picker: exclude generated/build output from
-- find-files (<leader><space>) and live-grep (<leader>/)
-- so fuzzy results stay fast and relevant on this monorepo.
-- =========================================================
local exclude = {
	"__generated__",
	"node_modules",
	"dist",
	"build",
	".next",
	"bazel-*", -- Bazel's convenience symlinks (bazel-bin, bazel-out, ...)
}

return {
	{
		"folke/snacks.nvim",
		opts = {
			picker = {
				sources = {
					files = { exclude = exclude },
					grep = { exclude = exclude },
				},
			},
		},
	},
}
