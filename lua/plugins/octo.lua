return {
  'pwntester/octo.nvim',
  requires = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('octo').setup()
    vim.keymap.set('n', '<leader>op', '<cmd>Octo pr list<cr>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>oi', '<cmd>Octo issue list<cr>', { noremap = true, silent = true })
  end,
}
