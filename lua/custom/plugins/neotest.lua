return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    { 'fredrikaverpil/neotest-golang', version = '*' },
  },
  config = function()
    local neotest_golang_opts = {}
    require('neotest').setup {
      adapters = {
        require 'neotest-golang'(neotest_golang_opts),
      },
    }
  end,
  keys = {
    { '<leader>t', '', desc = '+test' },
    {
      '<leader>tf',
      function()
        -- find the test file for the current file in go
        if vim.bo.filetype == 'go' then
          require('neotest').run.run(vim.fn.expand '%:r' .. '_test.go')
        end
        require('neotest').run.run(vim.fn.expand '%')
        require('neotest').summary.open()
      end,
      desc = '[T]est [F]ile (Neotest)',
    },
    {
      '<leader>ta',
      function()
        require('neotest').run.run(vim.uv.cwd())
      end,
      desc = '[T]est [A]ll Files (Neotest)',
    },
    {
      '<leader>tn',
      function()
        require('neotest').run.run()
      end,
      desc = '[T]est [N]earest (Neotest)',
    },
    {
      '<leader>tl',
      function()
        require('neotest').run.run_last()
      end,
      desc = '[T]est [L]ast (Neotest)',
    },
    {
      '<leader>tp',
      function()
        require('neotest').summary.toggle()
      end,
      desc = '[T]est [P]anel Toggle (Neotest)',
    },
    {
      '<leader>to',
      function()
        require('neotest').output.open { enter = true, auto_close = true }
      end,
      desc = '[T]est [O]utput (Neotest)',
    },
    {
      '<leader>tO',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = '[T]est [O]utput Panel (Neotest)',
    },
    {
      '<leader>tS',
      function()
        require('neotest').run.stop()
      end,
      desc = '[T]est [S]top (Neotest)',
    },
    {
      '<leader>tw',
      function()
        require('neotest').watch.toggle(vim.fn.expand '%')
      end,
      desc = '[T]oggle [W]atch (Neotest)',
    },
  },
}
