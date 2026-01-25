return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  config = true,
  keys = {
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    -- { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    -- { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    -- {
    --   '<leader>as',
    --   '<cmd>ClaudeCodeTreeAdd<cr>',
    --   desc = 'Add file',
    --   ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
    -- },
    -- Diff management
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
  opts = {
    diff_opts = {
      auto_close_on_accept = true,
      vertical_split = false,
      open_in_current_tab = true,
      keep_terminal_focus = true, -- If true, moves focus back to terminal after diff opens
    },
    terminal = {
      provider = 'snacks',
    },
  },
}
