-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", {}),
  desc = "Hightlight selection on yank",
  pattern = "*",
  callback = function()
    -- (vim.hl or vim.highlight).on_yank({ higroup = "IncSearch", timeout = 500 })
    (vim.hl or vim.highlight).on_yank({ higroup = "IncSearch" })
  end,
})

-- Float Terminal
local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function open_floating_terminal(params)
  -- Get the editor dimensions
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  -- Calculate centered position
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create a floating window configuration
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  }

  -- Create a new buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(params.buf) then
    buf = params.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- false = listed, true = scratch
  end

  if not buf then
    vim.notify("Failed to create buffer", vim.log.levels.ERROR)
    return
  end

  -- Open the floating window
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Set terminal options for the buffer
  -- BUG: The followings are buggy
  -- vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  -- vim.fn.termopen(vim.o.shell) -- Start the terminal in the buffer

  -- Automatically enter insert mode in the terminal
  vim.cmd("startinsert")

  return { buf = buf, win = win }
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = open_floating_terminal({ buf = state.floating.buf })
    -- call terminal command to make opened buffer work as terminal
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
-- KEYMAPS
-- Escape from terminal mode
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
-- Keymap to toggle terminal
vim.keymap.set({ "n", "t" }, "<leader>ft", toggle_terminal)
