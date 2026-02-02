return {
  'nvim-treesitter/nvim-treesitter',
  -- event = { 'BufReadPost', 'BufNewFile' },
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local filetypes = { 'go', 'lua', 'tsx', 'typescript', 'html', 'css', 'scss', 'sql', 'markdown', 'json', 'http', 'c_sharp', 'svelte', 'diff', 'vimdoc' }

    require('nvim-treesitter').install(filetypes)

    vim.api.nvim_create_autocmd('FileType', {
      pattern = filetypes,
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
