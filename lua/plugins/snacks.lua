return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    explorer = {
      auto_close = true,
      replace_netrw = true,
      trash = true,
    },
    terminal = {
      win = {
        style = 'float',
        relative = 'editor',
        width = 0.5,
        height = 0.3,
        border = 'rounded',
        backdrop = 80,
      },
    },
    dashboard = {},
  },
  keys = {
    -- GH CLIENT
    {
      '<leader>gp',
      function()
        Snacks.picker.gh_pr()
      end,
      desc = 'GitHub Pull Requests (open)',
    },

    -- GH BALEM
    {
      '<leader>gb',
      function()
        Snacks.picker.git_branches()
      end,
      desc = 'Git Branches',
    },
    {
      '<leader>gl',
      function()
        Snacks.picker.git_log()
      end,
      desc = 'Git Log',
    },
    {
      '<leader>gL',
      function()
        Snacks.picker.git_log_line()
      end,
      desc = 'Git Log Line',
    },
    {
      '<leader>gs',
      function()
        Snacks.picker.git_status()
      end,
      desc = 'Git Status',
    },
    {
      '<leader>gf',
      function()
        Snacks.picker.git_log_file()
      end,
      desc = 'Git Log File',
    },

    -- UTILS
    {
      '<leader>z',
      function()
        Snacks.zen()
      end,
      desc = 'Toggle Zen Mode',
    },
    -- FINDER
    {
      '<leader>sb',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Buffers',
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = 'Diagnostics',
    },
    {
      '<leader><space>',
      function()
        Snacks.picker.smart()
      end,
      desc = 'Smart Find Files',
    },
    {
      '<leader>sf',
      function()
        Snacks.picker.files()
      end,
      desc = 'Find Files',
    },
    {
      '<leader>sa',
      function()
        Snacks.picker.files { ignore = true, hidden = true }
      end,
      desc = 'Find All Files',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = 'Visual selection or word',
      mode = { 'n', 'x' },
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Grep',
    },
    -- explorer
    {
      '<leader>e',
      function()
        Snacks.explorer()
      end,
      desc = 'Explorer',
    },
    -- Terminal
    {
      '<leader>i',
      function()
        Snacks.terminal()
        vim.keymap.set('t', 'jk', '<C-\\><C-n>', { nowait = true })
      end,
      desc = 'Floating Terminal',
    },
    {
      '<leader>tt',
      function()
        vim.cmd 'terminal'
      end,
      desc = 'Classic Terminal',
    },
  },
}
