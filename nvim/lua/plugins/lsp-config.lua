return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import mason_lspconfig plugin
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    mason_lspconfig.setup_handlers({
      -- default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,
      ["svelte"] = function()
        -- configure svelte server
        lspconfig["svelte"].setup({
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePost", {
              pattern = { "*.js", "*.ts" },
              callback = function(ctx)
                -- Here use ctx.match instead of ctx.file
                client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
              end,
            })
          end,
        })
      end,
      ["graphql"] = function()
        -- configure graphql language server
        lspconfig["graphql"].setup({
          capabilities = capabilities,
          filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
        })
      end,
      ["emmet_ls"] = function()
        -- configure emmet language server
        lspconfig["emmet_ls"].setup({
          capabilities = capabilities,
          filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })
      end,
      ["lua_ls"] = function()
        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              -- make the language server recognize "vim" global
              diagnostics = {
                globals = { "vim" },
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        })
      end,
    })
  end,
}

-- return {
--   "neovim/nvim-lspconfig",
--   dependencies = {
--     "williamboman/mason.nvim",
--     "williamboman/mason-lspconfig.nvim",
--   },
--   opts = {
--     servers = {
--       biome = {
--         -- Additional Biome-specific settings
--         settings = {
--           biome = {
--             validate = true, -- Enable validation
--             format = true,   -- Enable formatting
--           },
--         },
--         filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" },
--       },
--     },
--   },
--   config = function()
--     -- require("mason").setup()
--     require("mason-lspconfig").setup()
--
--     local capabilities = require("cmp_nvim_lsp").default_capabilities()
--
--     require("mason-lspconfig").setup_handlers({
--       function(server_name)
--         require("lspconfig")[server_name].setup({
--           capabilities = capabilities,
--         })
--       end,
--     })
--
--     -- Example LSP server configurations
--     require("lspconfig").pyright.setup({})
--
--     -- Use Biome to format the document
--     local function biome_formatting()
--       -- Ensure Biome is available in the environment
--       local cmd = "biome --stdin --stdin-filepath " .. vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
--
--       -- Format with Biome
--       vim.fn.jobstart(cmd, {
--         stdout_buffered = true,
--         on_stdout = function(_, data)
--           if data then
--             vim.api.nvim_buf_set_lines(0, 0, -1, false, data)
--           end
--         end,
--         on_stderr = function(_, data)
--           if data then
--             vim.api.nvim_err_writeln("Biome formatting error: " .. table.concat(data, "\n"))
--           end
--         end,
--       })
--     end
--     -- nvim-lspconfig setup for TypeScript/TSX
--     require('lspconfig').ts_ls.setup({
--       on_attach = function(client, bufnr)
--         -- Enable formatting in TypeScript files
--         client.server_capabilities.documentFormattingProvider = true
--
--         vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', ':lua biome_formatting()<CR>',
--           { noremap = true, silent = true })
--       end,
--       flags = {
--         debounce_text_changes = 150,
--       },
--     })
--
--     require("lspconfig").lua_ls.setup({
--       -- ... other configs
--       settings = {
--         Lua = {
--           diagnostics = {
--             globals = { "vim" },
--           },
--         },
--       },
--     })
--
--     -- Global LSP mappings
--     vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
--     vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
--     vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
--     vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)
--
--     -- More LSP mappings
--     vim.api.nvim_create_autocmd("LspAttach", {
--       group = vim.api.nvim_create_augroup("UserLspConfig", {}),
--       callback = function(ev)
--         local opts = { buffer = ev.buf }
--         vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
--         vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
--         vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
--         vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
--         vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)
--         vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts)
--         vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, opts)
--         vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)
--         -- vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
--
--         local client = vim.lsp.get_client_by_id(ev.data.client_id)
--
--         -- if client:supports_method("textDocument/implementation") then
--         -- Create a keymap for vim.lsp.buf.implementation
--         -- end
--
--         -- if client:supports_method("textDocument/completion") then
--         -- 	-- Enable auto-completion
--         -- 	vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
--         -- end
--
--         if client:supports_method("textDocument/formatting") then
--           -- Keymap for manual formatting
--           vim.api.nvim_buf_set_keymap(ev.buf, "n", "<leader>cf", "", {
--             noremap = true,
--             silent = true,
--             desc = "Format Document",
--             callback = function()
--               vim.lsp.buf.format({ bufnr = ev.buf })
--             end,
--           })
--
--           -- Format the current buffer on save
--           vim.api.nvim_create_autocmd("BufWritePre", {
--             buffer = ev.buf,
--             callback = function()
--               vim.lsp.buf.format({ bufnr = ev.buf, id = client.id })
--             end,
--           })
--         end
--       end,
--     })
--   end,
-- }
