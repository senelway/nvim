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
    -- 'rouge8/neotest-rust',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-golang' { runner = 'gotestsum' },
        require 'neotest-vitest',
        -- require 'neotest-rust',
      },
    }

    vim.keymap.set('n', '<leader>tr', ':Neotest run<CR>', { noremap = true }, '[T]est [R]run')
    vim.keymap.set('n', '<leader>ts', ':Neotest summary<CR>', { noremap = true }, '[T]est [S]ummary')
    vim.keymap.set('n', '<leader>to', ':Neotest output<CR>', { noremap = true }, '[T]est [O]output')
    vim.keymap.set('n', '<leader>tO', ':Neotest output-panel<CR>', { noremap = true }, '[T]est [O]output-panel')
  end,
}
