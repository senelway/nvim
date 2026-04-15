return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').install({
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
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        'go',
        'lua',
        'typescript',
        'typescriptreact',
        'javascript',
        'javascriptreact',
        'html',
        'css',
        'scss',
        'sql',
        'markdown',
        'json',
        'http',
        'cs',
        'svelte',
      },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
