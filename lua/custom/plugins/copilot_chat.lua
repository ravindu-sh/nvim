return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    opts = function()
      local user = vim.env.USER or 'User'
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        auto_insert_mode = false,
        question_header = '  ' .. user .. ' ',
        answer_header = '  Copilot ',
        window = {
          width = 0.4,
        },
      }
    end,
    keys = {
      { '<c-s>', '<CR>', ft = 'copilot-chat', desc = 'Submit Prompt', remap = true },
      {
        '<leader>cc',
        function()
          return require('CopilotChat').toggle()
        end,
        desc = 'Copilot: Toggle [C]opilot [C]hat',
        mode = { 'n', 'v' },
      },
      {
        '<leader>cx',
        function()
          return require('CopilotChat').reset()
        end,
        desc = 'Copilot: Clear',
        mode = { 'n', 'v' },
      },
      {
        '<leader>cq',
        function()
          vim.ui.input({
            prompt = 'Quick Chat: ',
          }, function(input)
            if input ~= '' then
              require('CopilotChat').ask(input)
            end
          end)
        end,
        desc = 'Copilot: [Q]uick Chat',
        mode = { 'n', 'v' },
      },
      {
        '<leader>ca',
        function()
          require('CopilotChat').select_prompt()
        end,
        desc = 'Copilot: Prompt [A]ctions',
        mode = { 'n', 'v' },
      },
    },
  },
}
