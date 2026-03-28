vim.keymap.set(
  'n',
  '<leader>od',
  ':DBUIToggle<CR>',
  { noremap = true, silent = true, desc = '[O]pen [D]atabase viewer' }
)

return {
  'tpope/vim-dadbod',
  cmd = { 'DB', 'DBUIAddConnection', 'DBUI', 'DBUIToggle' },
  dependencies = {
    { 'kristijanhusak/vim-dadbod-ui' },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    {
      'saghen/blink.cmp',
      opts = {
        sources = {
          per_filetype = {
            sql = { 'snippets', 'dadbod', 'buffer' },
          },
        },
      },
    },
  },
  init = function()
    vim.g.db_ui_save_location = vim.fn.stdpath('config') .. require('plenary.path').path.sep .. 'db_ui'
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_win_position = 'right'
  end,
}
