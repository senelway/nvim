vim.keymap.set('n', '<leader>xo', vim.diagnostic.open_float, { desc = '[O]pen floating diagnostic message / [E]rrors' })
vim.keymap.set('n', '<leader>xl', vim.diagnostic.setloclist, { desc = 'Open diagnostics [L]ist' })

-- the float is opened by diagnostic.config's jump.on_jump handler
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1 }
end, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1 }
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
