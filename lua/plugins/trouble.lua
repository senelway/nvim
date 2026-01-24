vim.keymap.set('n', '<leader>xo', vim.diagnostic.open_float, { desc = '[O]pen floating diagnostic message / [E]rrors' })
vim.keymap.set('n', '<leader>x', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1 }
  vim.diagnostic.open_float()
end, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1 }
  vim.diagnostic.open_float()
end, { desc = 'Next diagnostic' })

return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  opts = {},
  keys = {
    {
      '<leader>xx',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
  },
}
