return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = false },
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = '<C-n>',
          jump_next = '<C-p>',
          accept = '<C-y>',
        },
      },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
    keys = {
      {
        '<leader>c',
        mode = { 'n', 'v' },
        desc = '+Copilot',
      },
      {
        '<leader>cp',
        function()
          require('copilot.panel').toggle()
        end,
        mode = { 'n', 'v' },
        desc = 'Copilot: Toggle [C]opilot [P]anel',
      },
      {
        '<leader>ct',
        function()
          if package.loaded['copilot.client'] and require('copilot.client').is_disabled() then
            require('copilot.command').enable()
            print 'Copilot enabled'
          else
            require('copilot.command').disable()
            print 'Copilot disabled'
          end
        end,
        mode = { 'n', 'v' },
        desc = 'Copilot: [C]opilot [T]oggle Enable/Disable',
      },
    },
  },
}
