-- Store the persistent agent terminal
local agent_terminal = nil

-- Get relative path from git root
local function get_relative_path(filepath)
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(vim.fn.fnamemodify(filepath, ':h')) .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 or not git_root then
    -- Not in a git repo, return just the filename
    return vim.fn.fnamemodify(filepath, ':t')
  end

  -- Make path relative to git root
  local relative = vim.fn.fnamemodify(filepath, ':p'):gsub('^' .. vim.pesc(git_root) .. '/', '')
  return relative
end

local function get_visual_selection()
  local _, srow, scol = unpack(vim.fn.getpos 'v')
  local _, erow, ecol = unpack(vim.fn.getpos '.')
  if srow > erow or (srow == erow and scol > ecol) then
    srow, erow = erow, srow
    scol, ecol = ecol, scol
  end
  local lines = vim.api.nvim_buf_get_lines(0, srow - 1, erow, false)
  if #lines == 0 then
    return ''
  end
  lines[#lines] = string.sub(lines[#lines], 1, ecol)
  lines[1] = string.sub(lines[1], scol)
  return table.concat(lines, '\\n'), srow, erow
end

-- Check if agent terminal is still valid
local function is_terminal_valid()
  if not agent_terminal then
    return false
  end
  -- Check if the terminal window and buffer still exist
  if agent_terminal.win and vim.api.nvim_win_is_valid(agent_terminal.win) then
    return true
  end
  return false
end

-- Create or show the agent terminal
local function ensure_agent_terminal()
  -- Check if agent CLI is available
  if vim.fn.executable 'agent' ~= 1 then
    vim.notify("'agent' CLI not found in PATH", vim.log.levels.ERROR)
    return nil
  end

  -- If terminal exists and is valid, just focus it
  if is_terminal_valid() then
    vim.api.nvim_set_current_win(agent_terminal.win)
    return agent_terminal
  end

  -- Create new terminal with auto model
  agent_terminal = Snacks.terminal('agent --model auto', {
    win = {
      style = 'split',
      position = 'right',
      width = 0.4,
      border = 'rounded',
    },
  })

  return agent_terminal
end

-- Send a message to the agent terminal
local function send_to_agent(text)
  local term = ensure_agent_terminal()
  if not term then
    return
  end

  -- Get the terminal channel/job ID from the buffer
  local chan = vim.bo[term.buf].channel
  if not chan or chan == 0 then
    vim.notify('Agent terminal channel not available', vim.log.levels.ERROR)
    return
  end

  -- Send the text to the terminal
  vim.api.nvim_chan_send(chan, text .. '\n')
end

-- Close the agent terminal
local function close_agent_terminal()
  if is_terminal_valid() then
    vim.api.nvim_win_close(agent_terminal.win, true)
  end
  agent_terminal = nil
  vim.notify('Agent terminal closed', vim.log.levels.INFO)
end

-- Show previous sessions using agent ls interactively
local function show_previous_sessions()
  -- Close current terminal if open
  if is_terminal_valid() then
    close_agent_terminal()
  end

  -- Open agent ls in interactive mode
  -- The agent CLI will handle the selection, and after selection it will resume the session
  agent_terminal = Snacks.terminal('agent ls --model auto', {
    win = {
      style = 'split',
      position = 'right',
      width = 0.4,
      border = 'rounded',
    },
  })
end

return {
  'folke/snacks.nvim',
  keys = {
    {
      '<leader>cc',
      function()
        ensure_agent_terminal()
      end,
      desc = 'Open Agent Chat',
    },
    {
      '<leader>cp',
      function()
        show_previous_sessions()
      end,
      desc = 'Open Previous Agent Session',
    },
    {
      '<leader>cf',
      function()
        local file = vim.fn.expand '%:p'
        local relative = get_relative_path(file)
        send_to_agent('@' .. relative)
      end,
      desc = 'Send current file to Agent',
    },
    {
      '<leader>cs',
      function()
        local selection, srow, erow = get_visual_selection()
        local file = vim.fn.expand '%:p'
        local relative = get_relative_path(file)
        -- Exit visual mode to prevent selection in terminal
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
        local context = string.format('@%s (lines %d-%d):', relative, srow, erow)
        send_to_agent(context .. '\n```\n' .. selection .. '\n```')
      end,
      mode = 'v',
      desc = 'Send selection to Agent',
    },
  },
}
