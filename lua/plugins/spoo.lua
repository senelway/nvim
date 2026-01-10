--[[
-- Player Control:
  'pause'
  'playpause'
  'next track'
  'previous track'
  'set player position to 30'

-- Player State (GET):
  'get player state'
  'get player position'
  'get sound volume'

-- Player State (SET):
  'set sound volume to 50' 

-- Current Track Info (GET):
  'get name of current track'
  'get artist of current track'
  'get album of current track'
  'get duration of current track'
  'get id of current track' 
  'get artwork url of current track'
  'get popularity of current track' 
  'get spotify url of current track'

-- Shuffle (GET/SET):
  'get shuffling'
  'set shuffling to true'
  'set shuffling to false'

-- Repeat (GET/SET):
  'get repeating'
  'set repeating to true'
  'set repeating to false'
  'set repeating to one'
--]]

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
  local state = spotify_command 'get player state'
  local volume = spotify_command 'get sound volume'
  local player_time = spotify_command 'get player position'
  local track_duration = spotify_command 'get duration of current track'

  if not name or name == '' or name:match '^%d+$' then
    return nil
  end

  return {
    name = name or 'Unknown',
    artist = artist or 'Unknown',
    state = state or 'stopped',
    volume = tonumber(volume) or 0,
    player_time = tonumber(player_time) or 0,
    duration = tonumber(track_duration) or 0,
  }
end

local function truncate(str, max_len)
  if not str or #str <= max_len then
    return str or ''
  end
  return str:sub(1, max_len - 3) .. '...'
end

local popup_win = nil

local function update_popup()
  if not popup_win then
    return
  end

  local win_id = popup_win.win
  if not win_id or not vim.api.nvim_win_is_valid(win_id) then
    return
  end

  local track = get_current_track()
  local lines = {}

  if not track then
    local message = is_spotify_running() and 'No track is playing' or 'Spotify is not running'
    lines = { ' ' .. message }
  else
    local max_len = 50
    local state_icon = track.state == 'playing' and '▶' or '⏸'
    local track_name = truncate(track.name, max_len)
    local artist_name = truncate(track.artist, max_len)

    local player_time = string.format('%.2d:%.2d', math.floor(track.player_time / 60), math.floor(track.player_time % 60))
    local duration = string.format('%02d:%02d', math.floor((track.duration / 1000) / 60), (track.duration / 1000) % 60)

    lines = {
      ' ' .. state_icon .. ' ' .. artist_name .. ' - ' .. track_name,
      ' Duration: ' .. player_time .. ' / ' .. duration,
      ' Volume: ' .. track.volume,
    }
  end

  local buf = popup_win.buf
  if buf and vim.api.nvim_buf_is_valid(buf) then
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
  end
end

local function update_defer()
  vim.schedule(function()
    vim.defer_fn(update_popup, 300)
  end)
end

local function create_popup()
  if popup_win then
    local win_id = popup_win.win
    if win_id and vim.api.nvim_win_is_valid(win_id) then
      vim.api.nvim_set_current_win(win_id)
      update_popup()
      return
    end
  end

  popup_win = Snacks.win {
    style = 'float',
    relative = 'editor',
    width = 60,
    height = 3,
    title = ' Spoo ',
    title_pos = 'center',
    border = 'rounded',
    enter = true,
    backdrop = 80,
  }

  local buf = popup_win.buf
  vim.bo[buf].filetype = 'spotify'
  vim.bo[buf].modifiable = false

  vim.api.nvim_buf_set_keymap(buf, 'n', 'p', '', {
    callback = function()
      spotify_command 'playpause'
      update_defer()
    end,
    desc = 'Play/Pause',
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'n', '', {
    callback = function()
      spotify_command 'next track'
      update_defer()
    end,
    desc = 'Next track',
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'b', '', {
    callback = function()
      spotify_command 'previous track'
      update_defer()
    end,
    desc = 'Previous track',
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'r', '', {
    callback = update_defer,
    desc = 'Refresh',
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'c', '', {
    callback = function()
      local track = get_current_track()
      if track then
        local url = spotify_command 'get spotify url of current track'
        vim.fn.setreg('+', url or 'error getting url')
      end
    end,
    desc = 'Copy Track URL',
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', '+', '', {
    callback = function()
      spotify_command 'set sound volume to (get sound volume + 5)'
      update_defer()
    end,
    desc = 'Volume Up',
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', '-', '', {
    callback = function()
      spotify_command 'set sound volume to (get sound volume - 5)'
      update_defer()
    end,
    desc = 'Volume Down',
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', {
    callback = function()
      popup_win:close()
      popup_win = nil
    end,
    desc = 'Close',
  })

  update_popup()
end

local function toggle_popup()
  if popup_win then
    local win_id = popup_win.win
    if win_id and vim.api.nvim_win_is_valid(win_id) then
      popup_win:close()
      popup_win = nil
    else
      popup_win = nil
      create_popup()
    end
  else
    create_popup()
  end
end

vim.keymap.set('n', '<leader>si', toggle_popup, { desc = '[S]poo [I] popup' })

return {}
