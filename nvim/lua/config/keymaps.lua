local keymap = vim.keymap

-- Exit insert mode
keymap.set("i", "kk", "<esc>")

-- Terminal
-- TODO: if happy remap st to tt
vim.keymap.set("n", "<leader>st", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)
end)
