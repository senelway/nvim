vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'Git Status' })

return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    on_attach = function(bufnr)
      local gs = require 'gitsigns'

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gs.nav_hunk 'next'
        end
      end)

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gs.nav_hunk 'prev'
        end
      end)

      -- Preview hunk
      map('n', '<leader>gd', gs.preview_hunk_inline, { desc = 'Preview hunk inline' })
    end,
  },
  {
    'tpope/vim-fugitive',
    cmd = { 'Git' },
  },
}
