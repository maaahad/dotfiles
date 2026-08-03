-- =========================================================
-- Postgres / SQL quickstart (vim-dadbod-ui, on top of the sql extra)
--
--   <leader>D  -> toggle the DB drawer
--
-- Connections are read from a `.env` file in the cwd instead of being
-- hardcoded here, so credentials never end up committed to this
-- dotfiles repo. Any KEY ending in `_URL` and containing "DB" or
-- "DATABASE" (e.g. DATABASE_URL, TEST_DATABASE_URL) becomes a named
-- connection. Falls back to :DBUIAddConnection for anything else.
-- =========================================================

local function load_dbs_from_env()
	local dbs = {}
	local env_path = vim.fn.getcwd() .. "/.env"
	local f = io.open(env_path, "r")
	if not f then
		return dbs
	end

	for line in f:lines() do
		local key, value = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
		local upper = key and key:upper() or ""
		if key and value and key:match("_URL$") and (upper:match("DATABASE") or upper:match("DB_URL$")) then
			value = value:gsub([["]], ""):gsub("'", "")
			local name = key:gsub("_URL$", ""):lower():gsub("_", "-")
			table.insert(dbs, { name = name, url = value })
		end
	end
	f:close()
	return dbs
end

return {
	{
		"kristijanhusak/vim-dadbod-ui",
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"

			local function refresh_dbs()
				vim.g.dbs = load_dbs_from_env()
			end

			refresh_dbs()
			vim.api.nvim_create_autocmd("DirChanged", {
				callback = refresh_dbs,
			})
		end,
	},
}
