-- Go: real tabs, width 4 (gofmt convention)
-- Rust: spaces, width 4 (rustfmt convention)
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go", "rust" },
	callback = function(ev)
		vim.bo[ev.buf].tabstop = 4
		vim.bo[ev.buf].shiftwidth = 4
		vim.bo[ev.buf].expandtab = vim.bo[ev.buf].filetype ~= "go"
	end,
})
