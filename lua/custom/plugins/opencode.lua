vim.g.opencode_opts = {
  -- Keep UI behavior predictable
  auto_focus = 'ask',
  auto_reload = true,

  -- Required for diff/review flow
  events = {
    edits = { enabled = true },
    reload = { enabled = true },
    permissions = { enabled = true },
    status = { enabled = true },
    auto_applly = { enabled = false },
  },
}

vim.pack.add {
  {
    src = 'https://github.com/nickjvandyke/opencode.nvim',
    version = 'main',
  },
}

vim.keymap.set({ 'n', 'x' }, '<leader>oa', function() require('opencode').ask '@this: ' end, { desc = 'Ask OpenCode…' })
vim.keymap.set({ 'n', 'x' }, '<leader>os', function() require('opencode').select() end, { desc = 'Select OpenCode…' })
vim.keymap.set({ 'n', 'x' }, '<leader>or', function() return require('opencode').operator '@this ' end, { desc = 'Append range to OpenCode', expr = true })
vim.keymap.set({ 'n' }, '<leader>ol', function() return require('opencode').operator '@this ' .. '_' end, { desc = 'Append line to OpenCode', expr = true })
vim.keymap.set({ 'n' }, '<leader>ou', function() require('opencode').command 'session.half.page.up' end, { desc = 'Scroll OpenCode up' })
vim.keymap.set({ 'n' }, '<leader>od', function() require('opencode').command 'session.half.page.down' end, { desc = 'Scroll OpenCode down' })
