return {
  'nvim-neotest/neotest',
  event = 'VeryLazy',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    {
      'fredrikaverpil/neotest-golang',
      version = '*',
      build = function()
        vim.system({ 'go', 'install', 'gotest.tools/gotestsum@latest' }):wait() -- Optional, but recommended
      end,
    },
    'marilari88/neotest-vitest',
    'Issafalcon/neotest-dotnet',
    -- 'rouge8/neotest-rust',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-golang' { runner = 'gotestsum' },
        require 'neotest-vitest',
        require 'neotest-dotnet' {
          discovery_root = 'solution', -- or "project" if you don't have a .sln file
          -- Add any dotnet test CLI arguments here
          dotnet_additional_args = {
            '--verbosity=normal',
            '--configuration=TESTS',
          },
        },
        -- require 'neotest-rust',
      },
    }

    vim.keymap.set('n', '<leader>ts', ':Neotest summary<CR>', { noremap = true, desc = '[T]est [S]ummary' })
    vim.keymap.set('n', '<leader>to', ':Neotest output<CR>', { noremap = true, desc = '[T]est [O]utput' })
    vim.keymap.set('n', '<leader>tO', ':Neotest output-panel<CR>', { noremap = true, desc = '[T]est [O]utput-panel' })
  end,
}
