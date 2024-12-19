return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup()

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    require("mason-lspconfig").setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
        })
      end,
    })

    require("lspconfig").lua_ls.setup({
      -- ... other configs
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })

    -- Global LSP mappings
    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
    vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

    -- More LSP mappings
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, opts)
        vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)
        -- vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])

        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        -- if client:supports_method("textDocument/implementation") then
        -- Create a keymap for vim.lsp.buf.implementation
        -- end

        -- if client:supports_method("textDocument/completion") then
        -- 	-- Enable auto-completion
        -- 	vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        -- end

        if client:supports_method("textDocument/formatting") then
          -- Format the current buffer on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = ev.buf,
            callback = function()
              vim.lsp.buf.format({ bufnr = ev.buf, id = client.id })
            end,
          })
        end
      end,
    })
  end,
}
