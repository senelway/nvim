return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  branch = 'main',
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
      'markdown_inline',
      'json',
      'http',
      'c_sharp',
      'svelte',
    })

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local language = vim.treesitter.language.get_lang(args.match)
        if not language or not vim.treesitter.language.add(language) then
          return
        end
        vim.treesitter.start(args.buf, language)
        if vim.treesitter.query.get(language, 'indents') ~= nil then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
