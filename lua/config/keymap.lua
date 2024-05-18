vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local function generate_options(desc)
  return { noremap = true, silent = true, desc = desc }
end

-- basic movement
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move down' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move up' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move right' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move left' })

-- Git integration
vim.keymap.set('n', '<leader>go', ':GithubOpen<CR>', generate_options '[G]ithub [O]pen')
vim.keymap.set('n', '<leader>gg', ':Git <CR>', generate_options '[G] [G]it run')
vim.keymap.set('n', '<leader>gm', ':Git mergetool <CR>', generate_options '[G]it [M]ergetool')
--
-- resize
vim.keymap.set('n', '<leader>rw', ':tabdo wincmd =<CR>', generate_options '[R] Equalize [W]indow sizes')
--
-- General
vim.keymap.set('i', 'jj', '<Esc>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<leader>bw', ':bw<CR>', generate_options '[B]uffer [W]ipeout')
--
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = 'Move up' })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = 'Move down' })

-- moving line
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", generate_options 'Move line down')
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", generate_options 'Move line up')

-- nerdtree
-- vim.keymap.set('n', '<leader>e', ':Explore %:p:h<CR>', generate_options '[E]xplore')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>oe', vim.diagnostic.open_float, { desc = '[O]pen floating diagnostic message / [E]rrors' })
vim.keymap.set('n', '<leader>x', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- navigate within insert mode
vim.keymap.set('i', '<C-j>', '<Down>', { desc = 'Move down' })
vim.keymap.set('i', '<C-k>', '<Up>', { desc = 'Move up' })
vim.keymap.set('i', '<C-l>', '<Right>', { desc = 'Move right' })
vim.keymap.set('i', '<C-h>', '<Left>', { desc = 'Move left' })

-- sort
vim.keymap.set('v', 'gsn', ':sort<CR>', { desc = '[S]ort [N]ormal' })
vim.keymap.set('v', 'gsi', ':sort i<CR>', { desc = '[S]ort [I]gnore case' })
vim.keymap.set('v', 'gsu', ':sort u<CR>', { desc = '[S]ort Remove dupclitaes' })

-- quick fix
vim.keymap.set('n', ']q', ':cnext<CR>zz', { desc = 'Forward qfixlist' })
vim.keymap.set('n', '[q', ':cprev<CR>zz', { desc = 'Backward qfixlist' })
