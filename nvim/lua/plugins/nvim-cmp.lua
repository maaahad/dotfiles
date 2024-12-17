return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
	},
	config = function()
		-- Set up nvim-cmp
		-- TODO: Uncomment autopairs related stuff if decided to use autopairs
		-- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local luasnip = require("luasnip")
		local cmp = require("cmp")

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = {
				{ name = "nvim_lsp", max_item_count = 5 },
				{ name = "buffer", max_item_count = 5 },
				{ name = "path", max_item_count = 3 },
				{ name = "luasnip", max_item_count = 3 },
			},
			formatting = {
				format = function(_, vim_item)
					vim_item.abbr = string.sub(vim_item.abbr, 1, 20)
					return vim_item
				end,
			},
		})

		-- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
