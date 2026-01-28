return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-mini/mini.icons', 'folke/trouble.nvim', 'rcarriga/nvim-dap-ui' },
  config = function()
    local C = require('catppuccin.palettes').get_palette()

    local bg = C.mantle -- Options: C.crust, C.mantle, C.base, C.surface0

    vim.cmd.highlight('MsgArea guibg=' .. bg)
    local theme = {
      normal = {
        a = { bg = bg, fg = C.blue, gui = 'bold' },
        b = { bg = bg, fg = C.blue },
        c = { bg = bg, fg = C.text },
      },
      insert = {
        a = { bg = bg, fg = C.green, gui = 'bold' },
        b = { bg = bg, fg = C.green },
      },
      command = {
        a = { bg = bg, fg = C.peach, gui = 'bold' },
        b = { bg = bg, fg = C.peach },
      },
      visual = {
        a = { bg = bg, fg = C.mauve, gui = 'bold' },
        b = { bg = bg, fg = C.mauve },
      },
      replace = {
        a = { bg = bg, fg = C.red, gui = 'bold' },
        b = { bg = bg, fg = C.red },
      },
      inactive = {
        a = { bg = bg, fg = C.surface1 },
        b = { bg = bg, fg = C.surface1 },
        c = { bg = bg, fg = C.overlay0 },
      },
    }

    require('lualine').setup {
      extensions = { 'trouble', 'nvim-dap-ui' },
      options = {
        theme = theme,
        component_separators = '|',
        section_separators = '|',
      },
      sections = {
        lualine_a = {},
        lualine_c = { { 'filename', path = 1 } },
      },
    }
  end,
}
