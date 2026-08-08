vim.pack.add {
  'https://github.com/tpope/vim-dadbod',
  'https://github.com/kristijanhusak/vim-dadbod-completion',
  'https://github.com/kristijanhusak/vim-dadbod-ui',
}

vim.keymap.set({'n', 'v'}, '<leader>dr', function()
  local db_url = vim.w.db or vim.t.db or vim.b.db or vim.g.db

  if not db_url or db_url == '' then
    vim.notify('No active database found', vim.log.levels.ERROR)
    return
  end

  local start_line, end_line

  if vim.fn.mode():match('[vV\22]') then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', false)
    start_line = vim.fn.getpos("'<")[2]
    end_line = vim.fn.getpos("'>")[2]
  else
    start_line = 1
    end_line = vim.fn.line('$')
  end

  vim.cmd(string.format('%d,%dDB %s', start_line, end_line, db_url))
end, { desc = 'Execute SQL', silent = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dbout',
  callback = function()
    vim.opt_local.foldenable = false
    vim.opt_local.foldlevel = 99
    vim.opt_local.wrap = false
  end,
})
