local disable_filetypes = { c = true, cpp = true, swift = true, kotlin = true }
local slow_format_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}
local eslint = { 'eslint_d' }

return {
  -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true, lsp_format = 'fallback' })
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local ft = vim.bo[bufnr].filetype
      if disable_filetypes[ft] or slow_format_filetypes[ft] then
        return nil
      end
      return { timeout_ms = 1000, lsp_format = 'fallback' }
    end,
    format_after_save = function(bufnr)
      if not slow_format_filetypes[vim.bo[bufnr].filetype] then
        return nil
      end
      return { lsp_format = 'never' }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      go = { 'gofumpt', 'goimports' },
      javascript = eslint,
      javascriptreact = eslint,
      typescript = eslint,
      typescriptreact = eslint,
    },
  },
}
