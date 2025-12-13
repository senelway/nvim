---@param buf integer
---@param language string
---@return boolean
local function attach(buf, language)
  if not vim.treesitter.language.add(language) then
    return false
  end
  vim.treesitter.start(buf, language)
  return true
end

return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  branch = 'main',
  config = function()
    local parsers = { 'go', 'lua', 'tsx', 'typescript', 'html', 'css', 'scss', 'sql', 'markdown', 'json', 'http', 'c_sharp' }
    require('nvim-treesitter').install(parsers)

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local buf, filetype = args.buf, args.match
        local language = vim.treesitter.language.get_lang(filetype)
        if not language then
          return
        end
        if attach(buf, language) then
          return
        end
        attach(buf, language)
      end,
    })
  end,
}
