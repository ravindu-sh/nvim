vim.pack.add {
  'https://github.com/tpope/vim-dadbod',
  'https://github.com/kristijanhusak/vim-dadbod-completion',
  'https://github.com/kristijanhusak/vim-dadbod-ui',
}

-- Execute visual SQL selection using the buffer-scoped b:db variable
vim.keymap.set('v', '<leader>db', function()
  -- Check if a buffer-local db variable exists
  if not vim.b.db then
    vim.notify('No b:db variable set for this buffer!', vim.log.levels.ERROR)
    return
  end

  -- Feed keys to exit visual mode, which forces Neovim to set the '< and '> marks
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', false)

  -- Retrieve the validated mark line numbers
  local start_line = vim.fn.getpos("'<")[2]
  local end_line = vim.fn.getpos("'>")[2]

  -- Construct and execute the command safely
  vim.cmd(string.format('%d,%dDB %s', start_line, end_line, vim.b.db))
end, { desc = 'Execute selected SQL using buffer b:db', silent = true })

