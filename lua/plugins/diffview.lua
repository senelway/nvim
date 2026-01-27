return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
  keys = {
    { '<leader>gf', '<cmd>DiffviewOpen<cr>', desc = 'Diff view (working tree)' },
    { '<leader>gp', '<cmd>DiffviewFileHistory<cr>', desc = 'Branch history' },
    { '<leader>gH', '<cmd>DiffviewFileHistory %<cr>', desc = 'File history' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Close diff view' },
  },
  opts = {},
}
