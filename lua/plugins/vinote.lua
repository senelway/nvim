return {
  'senelway/vinote.nvim',
  event = 'VeryLazy',
  opts = {
    notes_dir = vim.fn.expand '~/.config/nvim/notes',
    keys = {
      toggle = '<leader>.',
      new_note = '<leader>vn',
    },
    window = {
      width = 0.5,
      list_height = 0.15,
      show_footer_keys = false,
    },
  },
}
