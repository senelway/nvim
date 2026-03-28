return {
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      toggler = {
        line = '<leader>/',
        block = '<leader>?',
      },
      opleader = {
        line = '<leader>/',
        block = '<leader>?',
      },
    },
  },
}
