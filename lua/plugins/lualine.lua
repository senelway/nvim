return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-mini/mini.icons', 'folke/trouble.nvim', 'rcarriga/nvim-dap-ui' },
  opts = {
    extensions = { 'trouble', 'nvim-dap-ui' },
    options = {
      component_separators = '|',
    },
    sections = {
      lualine_c = { { 'filename', path = 1 } },
    },
  },
}
