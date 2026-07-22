--[[
=====================================================================
  LazyVim single-file starter — Fullstack (React/TS · Rust · Go · AI)
  Place this file at: ~/.config/nvim/init.lua
  (Back up / remove any existing ~/.config/nvim/lua/config and
   lua/plugins folders — this file is fully self-contained.)

  Stacks covered:
    - React / TypeScript / Tailwind / Biome / Playwright (+ Vitest)
    - SQL editor + Postgres (vim-dadbod + DBUI + completion)
    - Terminal (Snacks floating terminal + lazygit)
    - REST client "Postman-like" (kulala.nvim via util.rest extra)
    - Claude Code integration (claudecode.nvim)
    - Rust (rustaceanvim), Go (gopls/delve), GraphQL
    - Markdown (in-buffer rendering)
    - Testing: neotest → vitest / playwright / go / rust
    - Debugging: nvim-dap (codelldb, delve via extras)
    - Colorschemes: rusty, material, catppuccin, nord

  Prerequisites (install on your system first):
    git, ripgrep, fd, unzip, a C compiler (gcc/clang)
    node + npm            (TS/React tooling, LSP servers)
    go                    (gopls, delve, neotest-golang)
    rustup + cargo        (rust-analyzer via rustup)
    lazygit               (optional but recommended)
    tree-sitter CLI:  `npm i -g tree-sitter-cli`  (or `cargo install tree-sitter-cli`)
      ^ IMPORTANT: having this on your PATH prevents the
        "Package is already installing" race, because LazyVim then
        skips installing it through Mason during the treesitter build.

  ABOUT THE ERROR YOU HIT:
    "Failed to run `config` for mason.nvim ... Package is already
    installing" is a race: the treesitter build hook asks Mason to
    install `tree-sitter-cli` while Mason's ensure_installed (or a
    second plugin spec) is already installing the same package.
    This config fixes it by:
      1) using the renamed `mason-org/*` repos,
      2) deduplicating `ensure_installed` programmatically,
      3) not re-listing tools that LazyVim extras already install,
      4) recommending a system-wide tree-sitter CLI (above).
    If it still fires once on the very first bootstrap, simply
    restart Neovim — installs resume cleanly.
=====================================================================
--]]

-------------------------------------------------------------------
-- 1. Bootstrap lazy.nvim
-------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Leader keys must be set before lazy loads
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-------------------------------------------------------------------
-- 2. Plugins
-------------------------------------------------------------------
require("lazy").setup({
  spec = {
    -----------------------------------------------------------------
    -- LazyVim core
    -----------------------------------------------------------------
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        colorscheme = "catppuccin", -- rusty | material | catppuccin | nord
        news = { lazyvim = true },
      },
    },

    -----------------------------------------------------------------
    -- LazyVim extras (language & tooling packs)
    -- NOTE: `extras.formatting.biome` was RENAMED →
    --       `extras.lang.typescript.biome`
    -----------------------------------------------------------------
    -- Web / React / TypeScript
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.typescript.biome" }, -- Biome format + lint
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.yaml" },

    -- Systems languages
    { import = "lazyvim.plugins.extras.lang.rust" }, -- rustaceanvim + codelldb + neotest adapter
    { import = "lazyvim.plugins.extras.lang.go" },   -- gopls + delve + gofumpt

    -- SQL / Postgres (vim-dadbod, DBUI, cmp source, sqlfluff)
    { import = "lazyvim.plugins.extras.lang.sql" },

    -- Docs & config formats
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.toml" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "lazyvim.plugins.extras.lang.git" },

    -- Testing & debugging
    { import = "lazyvim.plugins.extras.test.core" }, -- neotest
    { import = "lazyvim.plugins.extras.dap.core" },  -- nvim-dap + dap-ui

    -- Pro workflow niceties
    { import = "lazyvim.plugins.extras.util.rest" },            -- kulala.nvim = Postman in Neovim (.http files)
    { import = "lazyvim.plugins.extras.util.mini-hipatterns" }, -- inline Tailwind color swatches
    { import = "lazyvim.plugins.extras.coding.mini-surround" },
    { import = "lazyvim.plugins.extras.coding.yanky" },         -- yank history/ring
    { import = "lazyvim.plugins.extras.editor.inc-rename" },    -- live LSP rename preview

    -----------------------------------------------------------------
    -- Mason: `williamboman/*` was RENAMED → `mason-org/*`
    -- (If you are pinned to an older LazyVim < 14.14 that requires
    --  Mason 1.x, add `version = "^1.0.0"` to BOTH specs below.)
    -----------------------------------------------------------------
    {
      "mason-org/mason.nvim",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, {
          "graphql-language-service-cli", -- GraphQL LSP
          "prettierd",                    -- fallback formatter where Biome doesn't apply
        })
        -- FIX for "Package is already installing":
        -- deduplicate so no package is ever requested twice.
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
    { "mason-org/mason-lspconfig.nvim" },

    -----------------------------------------------------------------
    -- Colorschemes: Rusty · Material · Catppuccin · Nord
    -- Picker: <leader>uC · Cycle the four: <leader>ut
    -----------------------------------------------------------------
    {
      "catppuccin/nvim",
      name = "catppuccin",
      lazy = true,
      opts = {
        flavour = "mocha",
        integrations = { blink_cmp = true, neotest = true, mason = true, which_key = true, dap = true },
      },
    },
    { "shaunsingh/nord.nvim", lazy = true },
    {
      "marko-cerovac/material.nvim",
      lazy = true,
      init = function()
        vim.g.material_style = "deep ocean" -- darker | lighter | oceanic | palenight | deep ocean
      end,
      opts = {
        contrast = { floating_windows = true },
        plugins = { "gitsigns", "nvim-web-devicons", "which-key" },
      },
    },
    {
      "armannikoyan/rusty",
      name = "rusty",
      lazy = true,
      opts = { transparent = false, italic_comments = true },
    },

    -----------------------------------------------------------------
    -- Treesitter parsers for the full stack
    -----------------------------------------------------------------
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, {
          "tsx", "typescript", "javascript", "css", "html",
          "rust", "go", "gomod", "gosum", "gowork",
          "graphql", "sql", "http",
          "markdown", "markdown_inline",
          "json", "jsonc", "yaml", "toml", "dockerfile",
          "lua", "vim", "regex", "bash",
        })
      end,
    },

    -----------------------------------------------------------------
    -- LSP: GraphQL (works inside .graphql AND embedded in TS/React)
    -----------------------------------------------------------------
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          graphql = {
            filetypes = { "graphql", "typescript", "typescriptreact", "javascript", "javascriptreact" },
          },
        },
      },
    },

    -----------------------------------------------------------------
    -- Testing: neotest adapters
    --   React  → vitest + playwright
    --   Go     → neotest-golang (with delve debugging)
    --   Rust   → rustaceanvim's built-in neotest adapter
    -----------------------------------------------------------------
    {
      "nvim-neotest/neotest",
      dependencies = {
        "marilari88/neotest-vitest",
        "thenbe/neotest-playwright",
        "fredrikaverpil/neotest-golang",
      },
      opts = {
        adapters = {
          ["neotest-vitest"] = {},
          ["neotest-playwright"] = {
            options = {
              persist_project_selection = true,
              enable_dynamic_test_discovery = true,
            },
          },
          ["neotest-golang"] = {
            go_test_args = { "-v", "-race", "-count=1" },
            dap_go_enabled = true,
          },
          ["rustaceanvim.neotest"] = {},
        },
      },
      -- Keymaps from the test.core extra:
      --   <leader>tt run file · <leader>tr nearest · <leader>ts summary
      --   <leader>to output · <leader>td debug nearest test
    },

    -----------------------------------------------------------------
    -- Claude Code — AI pair programmer inside Neovim
    -- Requires the `claude` CLI on your PATH (Claude Code)
    -----------------------------------------------------------------
    {
      "coder/claudecode.nvim",
      dependencies = { "folke/snacks.nvim" },
      opts = {},
      keys = {
        { "<leader>a", nil, desc = "+ai (Claude)" },
        { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
        { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
        { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume session" },
        { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue session" },
        { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
        { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
        { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
        { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
      },
    },

    -----------------------------------------------------------------
    -- Postgres / SQL editor polish (on top of the sql extra)
    -- Open UI: <leader>D · Add DB: :DBUIAddConnection
    -----------------------------------------------------------------
    {
      "kristijanhusak/vim-dadbod-ui",
      init = function()
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_show_database_icon = 1
        -- Predefine connections here (or add interactively):
        vim.g.dbs = {
          -- { name = "local-pg", url = "postgres://postgres:postgres@localhost:5432/mydb" },
        }
      end,
    },

    -----------------------------------------------------------------
    -- Markdown in-buffer rendering (pairs with the markdown extra)
    -----------------------------------------------------------------
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown" },
      opts = {},
    },

    -----------------------------------------------------------------
    -- Extra pro tools
    -----------------------------------------------------------------
    -- Cargo.toml: inline crate versions, updates, hover docs
    {
      "saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
      opts = {
        completion = { crates = { enabled = true } },
        lsp = { enabled = true, actions = true, completion = true, hover = true },
      },
    },
    -- package.json: inline npm dependency versions
    {
      "vuki656/package-info.nvim",
      dependencies = { "MunifTanjim/nui.nvim" },
      event = { "BufRead package.json" },
      opts = {},
    },

    -- Already included by LazyVim core (no config needed):
    --   snacks.nvim (picker, floating terminal, lazygit, dashboard)
    --   blink.cmp (completion) · trouble.nvim (diagnostics)
    --   gitsigns · which-key · flash (motions) · grug-far (search/replace)
    --   todo-comments · conform (formatting) · noice (UI)
  },

  defaults = { lazy = false, version = false },
  install = { colorscheme = { "catppuccin", "habamax" } },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin", "netrwPlugin",
      },
    },
  },
})

-------------------------------------------------------------------
-- 3. Options (on top of LazyVim defaults)
-------------------------------------------------------------------
local opt = vim.opt
opt.relativenumber = true
opt.wrap = false
opt.scrolloff = 8
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.conceallevel = 2

-- Rust & Go conventions: 4-wide indents, Go uses real tabs
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "rust" },
  callback = function(ev)
    vim.bo[ev.buf].tabstop = 4
    vim.bo[ev.buf].shiftwidth = 4
    vim.bo[ev.buf].expandtab = vim.bo[ev.buf].filetype ~= "go"
  end,
})

-------------------------------------------------------------------
-- 4. Extra keymaps
-------------------------------------------------------------------
-- Cycle between your four themes with <leader>ut
local themes = { "rusty", "material", "catppuccin", "nord" }
local theme_idx = 3
vim.keymap.set("n", "<leader>ut", function()
  theme_idx = theme_idx % #themes + 1
  vim.cmd.colorscheme(themes[theme_idx])
  vim.notify("Colorscheme: " .. themes[theme_idx])
end, { desc = "Cycle colorscheme (rusty/material/catppuccin/nord)" })

--[[
=====================================================================
  CHEAT SHEET  (<leader> = Space)

  Find/nav:   <leader>ff files · <leader>/ live grep · <leader>, buffers
  LSP:        gd definition · gr references · <leader>ca code action
              <leader>cr rename (live preview via inc-rename)
  Format:     <leader>cf  (Biome for TS/React, gofumpt, rustfmt, sqlfluff)
  Tests:      <leader>tt file · <leader>tr nearest · <leader>ts summary
              <leader>to output · <leader>td debug nearest
  Debug:      <leader>db breakpoint · <leader>dc continue · <leader>du UI
  Git:        <leader>gg lazygit · ]h/[h next/prev hunk · <leader>ghs stage
  Terminal:   <c-/> floating terminal · <leader>fT terminal (root dir)
  REST:       create a .http file → <leader>rs send request (kulala)
  SQL/PG:     <leader>D database UI · :DBUIAddConnection to add Postgres
  Claude:     <leader>ac toggle · visual <leader>as send selection
  Themes:     <leader>ut cycle four themes · <leader>uC full picker
  Markdown:   rendered inline automatically (render-markdown.nvim)

  FIRST START:
    1. Install prerequisites (see header), especially:
         npm i -g tree-sitter-cli
    2. Run `nvim` — let lazy.nvim + Mason install everything.
    3. RESTART Neovim once, then run :LazyHealth to verify.
=====================================================================
--]]


