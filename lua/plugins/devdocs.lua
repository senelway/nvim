return {
  'maskudo/devdocs.nvim',
  lazy = true,
  dependencies = {
    'folke/snacks.nvim',
  },
  cmd = { 'DevDocs' },
  keys = {
    {
      '<leader>hdi',
      mode = 'n',
      '<cmd>DevDocs install<cr>',
      desc = 'Install Devdocs',
    },
    {
      '<leader>hdo',
      mode = 'n',
      function()
        local devdocs = require 'devdocs'
        local installedDocs = devdocs.GetInstalledDocs()
        vim.ui.select(installedDocs, {}, function(selected)
          if not selected then
            return
          end
          local docDir = devdocs.GetDocDir(selected)
          -- prettify the filename as you wish
          Snacks.picker.files { cwd = docDir }
        end)
      end,
      desc = 'Get Devdocs',
    },
    {
      '<leader>hdd',
      mode = 'n',
      '<cmd>DevDocs delete<cr>',
      desc = 'Delete Devdoc',
    },
  },
  opts = {},
}
