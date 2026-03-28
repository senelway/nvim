return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.install').ensure_installed({
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
      callback = function(args)
        local language = vim.treesitter.language.get_lang(args.match)
        if language and vim.treesitter.language.add(language) then
          vim.treesitter.start(args.buf, language)
        end
      end,
    })
  end,
}
