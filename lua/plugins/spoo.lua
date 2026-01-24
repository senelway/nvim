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
  vim.fn.system { 'pgrep', '-x', 'Spotify' }
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

local function show_menu()
  local track = get_current_track()
  local is_running = is_spotify_running()

  -- Build status header
  local status_lines = {}
  if not is_running then
    table.insert(status_lines, '❌ Spotify is not running')
  elseif not track then
    table.insert(status_lines, '⏸ No track playing')
  else
    local state_icon = track.state == 'playing' and '▶' or '⏸'
    local duration = string.format('%02d:%02d', math.floor((track.duration / 1000) / 60), (track.duration / 1000) % 60)
    local current_time = string.format('%02d:%02d', math.floor(track.player_time / 60), math.floor(track.player_time % 60))

    table.insert(status_lines, state_icon .. ' ' .. track.name)
    table.insert(status_lines, '   ' .. track.artist)
    table.insert(status_lines, '   ' .. current_time .. ' / ' .. duration .. ' | Vol: ' .. track.volume)
  end

  -- Menu options
  local options = {
    {
      display = '⏯  Play/Pause',
      action = function()
        spotify_command 'playpause'
      end,
    },
    {
      display = '⏭  Next Track',
      action = function()
        spotify_command 'next track'
      end,
    },
    {
      display = '⏮  Previous Track',
      action = function()
        spotify_command 'previous track'
      end,
    },
    {
      display = '🔊 Volume Up (+5)',
      action = function()
        spotify_command 'set sound volume to (get sound volume + 5)'
      end,
    },
    {
      display = '🔉 Volume Down (-5)',
      action = function()
        spotify_command 'set sound volume to (get sound volume - 5)'
      end,
    },
    {
      display = '📋 Copy Track URL',
      action = function()
        local url = spotify_command 'get spotify url of current track'
        vim.fn.setreg('+', url or 'error getting url')
        ---@type fun(msg: string|string[], opts: snacks.notify.Opts)
        Snacks.notify('Copied to clipboard', { title = '🎵 Spoo', level = 'info' })
      end,
    },
  }

  local prompt = table.concat(status_lines, '\n')

  vim.ui.select(options, {
    prompt = prompt,
    format_item = function(item)
      return item.display
    end,
  }, function(choice)
    if choice and choice.action then
      choice.action()
    end
  end)
end

vim.keymap.set('n', '<leader>mo', show_menu, { desc = '[M]usic c[O]ntrol menu' })
return {}
