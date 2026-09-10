return {
  'folke/sidekick.nvim',
  dependencies = { 'folke/snacks.nvim' },
  opts = {
    cli = {
      picker = 'snacks',
    },
  },
  keys = {
    {
      '<leader>sc',
      function()
        require('sidekick.cli').toggle { name = 'codex', focus = true }
      end,
      desc = 'Sidekick Toggle Codex',
    },
  },
}
