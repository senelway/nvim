return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = false },
    dashboard = { enabled = false },
    indent = { enabled = false },
    input = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },

    words = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },

    explorer = {
      auto_close = true,
      replace_netrw = true,
      trash = true,
    },

    scratch = {
      ft = 'markdown',
      win = {
        width = 150,
        height = 25,
        minimal = true,
        footer_keys = false,
        border = true,
      },
    },

    terminal = {
      win = {
        style = 'float',
        relative = 'editor',
        width = 0.5,
        height = 0.4,
        border = 'rounded',
        backdrop = 80,
      },
    },
    gitbrowse = {},
    picker = {
      hidden = true,
      sources = {
        files = {
          hidden = true,
        },
      },
    },
  },
  keys = {
    {
      '<leader>pm',
      function()
        Snacks.picker()
      end,
      desc = 'GitHub Picker',
    },

    -- GH CLIENT

    {
      '<leader>g1',
      function()
        Snacks.picker.gh_issue { state = 'open' }
      end,
      desc = 'GitHub Issues (open)',
    },
    {
      '<leader>g2',
      function()
        Snacks.picker.gh_issue { state = 'open', assignee = '@me', repo = 'bidease/tasks' }
      end,
      desc = 'GitHub Issues (open)',
    },
    {
      '<leader>g3',
      function()
        Snacks.picker.gh_issue { state = 'open', assignee = '@me', repo = 'bidease/adex-tasks' }
      end,
      desc = 'GitHub Issues (open)',
    },
    {
      '<leader>g4',
      function()
        Snacks.picker.gh_pr()
      end,
      desc = 'GitHub Pull Requests (open)',
    },
    {
      '<leader>gof',
      function()
        Snacks.gitbrowse.open()
      end,
      desc = 'Github open',
    },
    {
      '<leader>goc',
      function()
        Snacks.gitbrowse.open {
          open = function(url)
            vim.fn.setreg('+', url)
            Snacks.notify.info('Copied: ' .. url)
          end,
        }
      end,
      desc = 'Copy GitHub URL',
    },
    -- GH BALEM
    {
      '<leader>g8',
      function()
        Snacks.picker.git_branches()
      end,
      desc = 'Git Branches',
    },
    {
      '<leader>g9',
      function()
        Snacks.picker.git_log_file()
      end,
      desc = 'Git Log File',
    },
    {
      '<leader>g-',
      function()
        Snacks.picker.git_status()
      end,
      desc = 'Git Status',
    },
    {
      '<leader>g0',
      function()
        Snacks.picker.git_diff()
      end,
      desc = 'Git Diff (Hunks)',
    },
    {
      '<leader>g=',
      function()
        Snacks.picker.git_log()
      end,
      desc = 'Git Log',
    },
    -- GIT
    -- UTILS
    {
      'gr',
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = 'References',
    },
    {
      ']]',
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = 'Next Reference',
      mode = { 'n', 't' },
    },
    {
      '[[',
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = 'Prev Reference',
      mode = { 'n', 't' },
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
      '<leader>su',
      function()
        Snacks.picker.undo()
      end,
      desc = 'Undo History',
    },
    {
      '<leader>sa',
      function()
        Snacks.picker.files { ignored = true, hidden = true }
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
    {
      '<leader>sr',
      function()
        Snacks.picker.resume()
      end,
      desc = 'Resume Last Picker',
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
    {
      '<leader>bd',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Delete Buffer',
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end

        if vim.fn.has 'nvim-0.11' == 1 then
          vim._print = function(_, ...)
            dd(...)
          end
        else
          vim.print = _G.dd
        end

        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>fs'
        Snacks.toggle.inlay_hints():map '<leader>fh'
        Snacks.toggle.zen():map '<leader>fz'
        Snacks.toggle.dim():map '<leader>fd'
      end,
    })
  end,
}
