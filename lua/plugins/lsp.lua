return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  cmd = { 'Mason', 'MasonUpdate', 'MasonToolsInstall' },
  dependencies = {
    {
      'mason-org/mason.nvim',
      opts = {
        registries = {
          'github:mason-org/mason-registry',
          'github:Crashdummyy/mason-registry',
        },
      },
    },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    { 'folke/lazydev.nvim', ft = 'lua', opts = {} },
    'saghen/blink.cmp',
  },
  config = function()
    -- lsp.log never rotates; the default WARN level grew it to ~900MB. Raise when debugging a server.
    vim.lsp.log.set_level('OFF')

    local lsp_attach_group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true })
    local lsp_highlight_group = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
    local lsp_detach_group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true })

    vim.api.nvim_create_autocmd('LspAttach', {
      group = lsp_attach_group,
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', function()
          vim.lsp.buf.definition({ on_list = require('config.typescript').on_list })
        end, '[G]oto [D]efinition')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('<C-s>', vim.lsp.buf.signature_help, 'Signature Documentation')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/documentHighlight', event.buf) then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = lsp_highlight_group,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = lsp_highlight_group,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = lsp_detach_group,
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = lsp_highlight_group, buffer = event2.buf })
            end,
          })
        end
        if client and client:supports_method('textDocument/inlayHint', event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    vim.diagnostic.config({
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      virtual_text = true,
      virtual_lines = false,
      jump = {
        on_jump = function(_, bufnr)
          vim.diagnostic.open_float({ bufnr = bufnr, scope = 'cursor', focus = false })
        end,
      },
    })

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    local servers = {
      kotlin_language_server = {
        cmd_env = {
          JAVA_HOME = '/usr/lib/jvm/java-17-openjdk',
        },
        settings = {
          kotlin = {
            diagnostics = {
              enabled = false,
            },
          },
        },
      },
      cssls = {
        settings = {
          scss = { lint = { unknownAtRules = 'ignore' } },
        },
      },
      lua_ls = {
        settings = {
          -- workspace.library is left to lazydev.nvim, which resolves it per-require
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = { checkThirdParty = false },
            completion = { callSnippet = 'Replace' },
            diagnostics = { globals = { 'vim', 'Snacks' } },
          },
        },
      },
    }

    -- Mason registry package names, not lspconfig server names.
    require('mason-tool-installer').setup({
      ensure_installed = {
        'tree-sitter-cli',
        'stylua',
        'goimports',
        'gofumpt',
        'roslyn-language-server',
        'jsonlint',
        'golangci-lint',
        'htmlhint',
        'gopls',
        'golangci-lint-langserver',
        'rust-analyzer',
        'lua-language-server',
        'css-lsp',
        'html-lsp',
        'kotlin-language-server',
        'eslint_d',
        'tailwindcss-language-server',
        'svelte-language-server',
      },
    })

    require('mason-lspconfig').setup({
      ensure_installed = {},
    })

    for name, server in pairs(servers) do
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      vim.lsp.config(name, server)
      vim.lsp.enable(name)
    end
    vim.lsp.enable('sourcekit')
  end,
}
