return {
  {
    'jmbuhr/otter.nvim',
    dev = false,
    dependencies = {
      {
        'neovim/nvim-lspconfig',
        'nvim-treesitter/nvim-treesitter',
      },
    },
    ---@type OtterConfig
  },
  {
    'quarto-dev/quarto-nvim',
    ft = { 'quarto', 'qmd', 'markdown' },
    dev = false,
    opts = {
      lspFeatures = {
        enabled = true,
        languages = { 'r', 'python', 'rust' },
        chunks = 'all',
        diagnostics = {
          enabled = true,
          triggers = { 'BufWritePost' },
        },
        completion = {
          enabled = true,
        },
        codeRunner = {
          enabled = true,
          default_method = 'slime',
        },
      },
      codeRunner = {
        enabled = true,
        default_method = 'molten',
      },
    },
    dependencies = {
      'jmbuhr/otter.nvim',
    },
    config = function()
      local quarto = require 'quarto'
      quarto.setup()
      -- I find auto open annoying, keep in mind setting this option will require setting
      -- a keybind for `:noautocmd MoltenEnterOutput` to open the output again
      vim.g.molten_auto_open_output = false

      -- this guide will be using image.nvim
      -- Don't forget to setup and install the plugin if you want to view image outputs
      vim.g.molten_image_provider = 'image.nvim'

      -- optional, I like wrapping. works for virt text and the output window
      vim.g.molten_wrap_output = true

      -- Output as virtual text. Allows outputs to always be shown, works with images, but can
      -- be buggy with longer images
      vim.g.molten_virt_text_output = true

      -- this will make it so the output shows up below the \`\`\` cell delimiter
      vim.g.molten_virt_lines_off_by_1 = true

      -- vim.keymap.set('n', '<localleader>me', ':MoltenEvaluateOperator<CR>', { desc = 'evaluate operator', silent = true })
      vim.keymap.set('n', '<localleader>no', ':noautocmd MoltenEnterOutput<CR>', { desc = 'goto [n]otebook [o]utput', silent = true })
      vim.keymap.set('n', '<localleader>nc', ':MoltenReevaluateCell<CR>', { desc = 'run [n]otebook [c]ell', silent = true })
      -- automatically import output chunks from a jupyter notebook
      -- tries to find a kernel that matches the kernel in the jupyter notebook
      -- falls back to a kernel that matches the name of the active venv (if any)
      local imb = function(e) -- init molten buffer
        vim.schedule(function()
          local kernels = vim.fn.MoltenAvailableKernels()
          local try_kernel_name = function()
            local metadata = vim.json.decode(io.open(e.file, 'r'):read 'a')['metadata']
            return metadata.kernelspec.name
          end
          local ok, kernel_name = pcall(try_kernel_name)
          if not ok or not vim.tbl_contains(kernels, kernel_name) then
            kernel_name = nil
            local venv = os.getenv 'VIRTUAL_ENV' or os.getenv 'CONDA_PREFIX'
            if venv ~= nil then
              kernel_name = string.match(venv, '/.+/(.+)')
            end
          end
          if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
            vim.cmd(('MoltenInit %s'):format(kernel_name))
          end
          vim.cmd 'MoltenImportOutput'
        end)
      end

      -- automatically import output chunks from a jupyter notebook
      vim.api.nvim_create_autocmd('BufAdd', {
        pattern = { '*.ipynb' },
        callback = imb,
      })

      -- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = { '*.ipynb' },
        callback = function(e)
          if vim.api.nvim_get_vvar 'vim_did_enter' ~= 1 then
            imb(e)
          end
        end,
      })

      -- automatically export output chunks to a jupyter notebook on write
      vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = { '*.ipynb' },
        callback = function()
          if require('molten.status').initialized() == 'Molten' then
            vim.cmd 'MoltenExportOutput!'
          end
        end,
      })

      require('nvim-treesitter.configs').setup {
        -- ... other ts config
        textobjects = {
          move = {
            enable = true,
            set_jumps = false, -- you can change this if you want.
            goto_next_start = {
              --- ... other keymaps
              [']b'] = { query = '@code_cell.inner', desc = 'next code block' },
            },
            goto_previous_start = {
              --- ... other keymaps
              ['[b'] = { query = '@code_cell.inner', desc = 'previous code block' },
            },
          },
          select = {
            enable = true,
            lookahead = true, -- you can change this if you want
            keymaps = {
              --- ... other keymaps
              ['ib'] = { query = '@code_cell.inner', desc = 'in block' },
              ['ab'] = { query = '@code_cell.outer', desc = 'around block' },
            },
          },
          swap = { -- Swap only works with code blocks that are under the same
            -- markdown header
            enable = true,
            swap_next = {
              --- ... other keymap
              ['<leader>sbl'] = '@code_cell.outer',
            },
            swap_previous = {
              --- ... other keymap
              ['<leader>sbh'] = '@code_cell.outer',
            },
          },
        },
      }
    end,
  },
  {
    'GCBallesteros/jupytext.nvim',
    opts = {
      style = 'markdown',
      output_extension = 'md',
      force_ft = 'markdown',
    },
  },
  {
    'benlubas/molten-nvim',
    version = '^1.0.0', -- use version <2.0.0 to avoid breaking changes
    dependencies = { '3rd/image.nvim' },
    build = ':UpdateRemotePlugins',
    init = function()
      -- these are examples, not defaults. Please see the readme
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_output_win_max_height = 20
    end,
  },
  {
    -- see the image.nvim readme for more information about configuring this plugin
    '3rd/image.nvim',
    opts = {
      backend = 'kitty', -- whatever backend you would like to use
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
    },
  },
  { -- send code from python/r/qmd documets to a terminal or REPL
    -- like ipython, R, bash
    'jpalardy/vim-slime',
    dev = false,
    init = function()
      vim.b['quarto_is_python_chunk'] = false
      Quarto_is_in_python_chunk = function()
        require('otter.tools.functions').is_otter_language_context 'python'
      end

      vim.cmd [[
      let g:slime_dispatch_ipython_pause = 100
      function SlimeOverride_EscapeText_quarto(text)
      call v:lua.Quarto_is_in_python_chunk()
      if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
      return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
      else
      if exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
      return [a:text, "\n"]
      else
      return [a:text]
      end
      end
      endfunction
      ]]

      vim.g.slime_target = 'neovim'
      vim.g.slime_no_mappings = true
      vim.g.slime_python_ipython = 1
    end,
    config = function()
      vim.g.slime_input_pid = false
      vim.g.slime_suggest_default = true
      vim.g.slime_menu_config = false
      vim.g.slime_neovim_ignore_unlisted = true

      local function mark_terminal()
        local job_id = vim.b.terminal_job_id
        vim.print('job_id: ' .. job_id)
      end

      local function set_terminal()
        vim.fn.call('slime#config', {})
      end
      vim.keymap.set('n', '<leader>cm', mark_terminal, { desc = '[m]ark terminal' })
      vim.keymap.set('n', '<leader>cs', set_terminal, { desc = '[s]et terminal' })
    end,
  },
}
