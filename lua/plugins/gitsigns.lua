return {
  'lewis6991/gitsigns.nvim',
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

      -- Actions
      map('n', '<leader>hb', gs.blame, { desc = 'Git blame line full' })
      map('n', '<leader>hB', function()
        gs.blame_line { full = false }
      end, { desc = 'git blame line' })

      map('n', '<leader>hD', gs.diffthis, { desc = 'git diff against index' })
      map('n', '<leader>hd', function()
        gs.diffthis '~'
      end, { desc = 'git diff against last commit' })

      -- Toggles
      map('n', '<leader>gB', gs.toggle_current_line_blame, { desc = '[G]it toggle [B]lame' })
      map('n', '<leader>gd', gs.preview_hunk_inline, { desc = '[G]it toggle [D]iff' })
    end,
  },
}
