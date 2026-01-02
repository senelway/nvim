local function spotify_command(cmd)
  local script = string.format(
    [[tell application "Spotify"
      %s
    end tell]],
    cmd
  )

  local result = vim.fn.system { 'osascript', '-e', script }
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return result and result:gsub('^%s+', ''):gsub('%s+$', ''):gsub('\n', '') or nil
end

local function is_spotify_running()
  local result = vim.fn.system { 'pgrep', '-x', 'Spotify' }
  return vim.v.shell_error == 0
end

local function get_current_track()
  if not is_spotify_running() then
    return nil
  end

  local name = spotify_command 'get name of current track'
  local artist = spotify_command 'get artist of current track'
  local album = spotify_command 'get album of current track'
  local state = spotify_command 'get player state'

  if not name or name == '' or name:match '^%d+$' then
    return nil
  end

  return {
    name = name or 'Unknown',
    artist = artist or 'Unknown',
    album = album or 'Unknown',
    state = state or 'stopped',
  }
end

local function play_pause()
  spotify_command 'playpause'
end

local function next_track()
  spotify_command 'next track'
end

local function previous_track()
  spotify_command 'previous track'
end

local popup_buf = nil
local popup_win = nil

local function update_popup()
  if not popup_win or not vim.api.nvim_win_is_valid(popup_win) then
    return
  end

  if not popup_buf or not vim.api.nvim_buf_is_valid(popup_buf) then
    return
  end

  local track = get_current_track()
  if not track then
    local message = is_spotify_running() and 'No track is playing' or 'Spotify is not running'
    local lines = {
      '  spoo',
      '',
      '  ' .. message,
      '',
      '  Press [q] to close',
    }
    vim.bo[popup_buf].modifiable = true
    vim.api.nvim_buf_set_lines(popup_buf, 0, -1, false, lines)
    vim.bo[popup_buf].modifiable = false
    return
  end

  local function truncate(str, max_len)
    if not str or #str <= max_len then
      return str or ''
    end
    return str:sub(1, max_len - 3) .. '...'
  end

  local state_icon = track.state == 'playing' and '▶' or '⏸'
  local max_len = 90
  local track_name = truncate(track.name, max_len)
  local artist_name = truncate(track.artist, max_len)
  local album_name = truncate(track.album, max_len)

  local state_text = string.format('%s %s', state_icon, track.state:upper())

  local lines = {
    '  spoo',
    '',
    '  ' .. state_text,
    '',
    '  Track:  ' .. track_name,
    '  Artist: ' .. artist_name,
    '  Album:  ' .. album_name,
    '',
    '  Controls:',
    '    [p] Play/Pause',
    '    [n] Next',
    '    [b] Previous',
    '    [r] Refresh',
    '    [q] Close',
  }

  vim.bo[popup_buf].modifiable = true
  vim.api.nvim_buf_set_lines(popup_buf, 0, -1, false, lines)
  vim.bo[popup_buf].modifiable = false
end

local function create_popup()
  if popup_win and vim.api.nvim_win_is_valid(popup_win) then
    vim.api.nvim_set_current_win(popup_win)
    update_popup()
    return
  end

  popup_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(popup_buf, 'spoo://' .. tostring(os.time()))
  vim.bo[popup_buf].filetype = 'spotify'

  local width = 100
  local height = 15

  local editor_width = vim.api.nvim_get_option_value('columns', {})
  local editor_height = vim.api.nvim_get_option_value('lines', {})

  local col = math.floor((editor_width - width) / 2)
  local row = math.floor((editor_height - height) / 2)

  popup_win = vim.api.nvim_open_win(popup_buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  })

  vim.bo[popup_buf].modifiable = false

  vim.api.nvim_buf_set_keymap(popup_buf, 'n', 'p', '', {
    callback = function()
      play_pause()
      vim.schedule(function()
        vim.defer_fn(update_popup, 300)
      end)
    end,
    desc = 'Play/Pause',
  })

  vim.api.nvim_buf_set_keymap(popup_buf, 'n', 'n', '', {
    callback = function()
      next_track()
      vim.schedule(function()
        vim.defer_fn(update_popup, 300)
      end)
    end,
    desc = 'Next track',
  })

  vim.api.nvim_buf_set_keymap(popup_buf, 'n', 'b', '', {
    callback = function()
      previous_track()
      vim.schedule(function()
        vim.defer_fn(update_popup, 300)
      end)
    end,
    desc = 'Previous track',
  })

  vim.api.nvim_buf_set_keymap(popup_buf, 'n', 'r', '', {
    callback = update_popup,
    desc = 'Refresh',
  })

  vim.api.nvim_buf_set_keymap(popup_buf, 'n', 'q', '', {
    callback = function()
      if popup_win and vim.api.nvim_win_is_valid(popup_win) then
        vim.api.nvim_win_close(popup_win, true)
      end
      if popup_buf and vim.api.nvim_buf_is_valid(popup_buf) then
        vim.api.nvim_buf_delete(popup_buf, { force = true })
      end
      popup_win = nil
      popup_buf = nil
    end,
    desc = 'Close',
  })

  update_popup()
end

local function toggle_popup()
  if popup_win and vim.api.nvim_win_is_valid(popup_win) then
    vim.api.nvim_win_close(popup_win, true)
    if popup_buf and vim.api.nvim_buf_is_valid(popup_buf) then
      vim.api.nvim_buf_delete(popup_buf, { force = true })
    end
    popup_win = nil
    popup_buf = nil
  else
    create_popup()
  end
end

vim.keymap.set('n', '<leader>si', toggle_popup, { desc = '[S]potify [I] popup' })

return {}
