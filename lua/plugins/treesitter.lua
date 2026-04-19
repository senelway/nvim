return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local wanted = {
      'go',
      'lua',
      'tsx',
      'typescript',
      'html',
      'css',
      'scss',
      'sql',
      'markdown',
      'json',
      'http',
      'c_sharp',
      'svelte',
    }
    local installed = require('nvim-treesitter.config').get_installed()
    local todo = vim
      .iter(wanted)
      :filter(function(p)
        return not vim.tbl_contains(installed, p)
      end)
      :totable()
    require('nvim-treesitter').install(todo)

    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
