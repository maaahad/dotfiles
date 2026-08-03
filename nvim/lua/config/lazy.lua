-------------------------------------------------------------------
-- Bootstrap lazy.nvim
-------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-------------------------------------------------------------------
-- Leader keys (must be set before lazy.setup)
-------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-------------------------------------------------------------------
-- lazy.nvim + LazyVim + extras + custom plugins
-------------------------------------------------------------------
require("lazy").setup({
	spec = {
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },

		-- LazyVim extras (must resolve before custom plugins)
		{ import = "lazyvim.plugins.extras.lang.typescript" }, -- vtsls, js-debug-adapter
		{ import = "lazyvim.plugins.extras.lang.typescript.biome" }, -- (renamed from formatting.biome)
		{ import = "lazyvim.plugins.extras.lang.tailwind" }, -- tailwindcss-language-server + color hints
		{ import = "lazyvim.plugins.extras.lang.rust" }, -- rustaceanvim, crates.nvim, codelldb, neotest adapter
		{ import = "lazyvim.plugins.extras.lang.go" }, -- gopls, gofumpt, delve, neotest-golang
		{ import = "lazyvim.plugins.extras.lang.sql" }, -- vim-dadbod + dadbod-ui + completion (SQL editor, <leader>D)
		{ import = "lazyvim.plugins.extras.lang.markdown" }, -- marksman, markdownlint, render-markdown
		{ import = "lazyvim.plugins.extras.lang.json" }, -- jsonls + SchemaStore
		{ import = "lazyvim.plugins.extras.lang.yaml" },
		{ import = "lazyvim.plugins.extras.lang.docker" },
		{ import = "lazyvim.plugins.extras.lang.git" },
		{ import = "lazyvim.plugins.extras.test.core" }, -- neotest core (adapters added in plugins/test.lua!)
		{ import = "lazyvim.plugins.extras.dap.core" }, -- debugging (codelldb / delve / js-debug)
		{ import = "lazyvim.plugins.extras.util.rest" }, -- kulala.nvim = Postman-like HTTP client (.http files)
		{ import = "lazyvim.plugins.extras.editor.refactoring" }, -- refactoring.nvim (extract fn/var, inline, ...)
		{ import = "lazyvim.plugins.extras.util.mini-hipatterns" }, -- tailwind color highlighting helpers
		-- { import = "lazyvim.plugins.extras.ai.copilot" },          -- uncomment if you also want GitHub Copilot

		{ import = "plugins" },
	},

	defaults = { lazy = false, version = false },
	install = { colorscheme = { "cursor-dark-midnight", "catppuccin", "habamax" } },
	checker = { enabled = true, notify = true }, -- auto-check plugin updates
	rocks = { enabled = false }, -- silence luarocks warnings
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
				"netrwPlugin",
				"matchit",
			},
		},
	},
})

--[[
=====================================================================
  CHEAT SHEET
=====================================================================
  <leader><space>  find files          <leader>/   grep project
  <leader>e        file explorer       <leader>,   buffers
  <leader>uC       switch colorscheme
                   (cursor-dark-midnight [default] / cursor-dark /
                    oxocarbon / rusty / material / catppuccin / nord)

  TESTS (neotest):
    <leader>tt  run current file       <leader>tr  run nearest test
    <leader>ts  toggle summary tree    <leader>to  show output
    Rust : works out of the box (rustaceanvim)
    Go   : works out of the box (neotest-golang)
    React: vitest/jest auto-detected; Playwright for e2e specs
    -> If "No tests found": open nvim at the repo root and make sure
       the runner's config file (vitest.config.ts / jest.config.js /
       playwright.config.ts / go.mod / Cargo.toml) is present.

  HTTP client (Postman-like, kulala.nvim):
    Create a file like `requests.http`:
        GET https://api.example.com/users
        Authorization: Bearer {{TOKEN}}
    Put the cursor on the request and run it (see <leader>R group).

  DATABASE:
    <leader>D  DB drawer -> write SQL in the query buffer,
    completion via dadbod-completion, execute with :w / <leader>S

  CLAUDE:
    <leader>ac toggle · visual <leader>as send selection
    <leader>aa / <leader>ad accept/deny proposed diffs

  GIT:
    <leader>gg lazygit · <leader>gd diffview · <leader>gh file history

  DEBUG (DAP): <leader>db breakpoint · <leader>dc continue
=====================================================================
--]]
