vim.keymap.set(
  "n",
  "<leader>od",
  ":DBUIToggle<CR>",
  { noremap = true, silent = true, desc = "[O]pen [D]atabase viewer" }
)

return {
  "tpope/vim-dadbod",
  cmd = { "DB", "DBUIAddConnection", "DBUI", "DBUIToggle" },
  dependencies = {
    { "kristijanhusak/vim-dadbod-ui" },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    { -- optional saghen/blink.cmp completion source
      "saghen/blink.cmp",
      opts = {
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
          per_filetype = {
            sql = { "snippets", "dadbod", "buffer" },
          },
          -- add vim-dadbod-completion to your completion providers
          providers = {
            dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
          },
        },
      },
    },
  },
  init = function()
    vim.g.db_ui_save_location = vim.fn.stdpath("config") .. require("plenary.path").path.sep .. "db_ui"
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_win_position = "right"
  end,
}
