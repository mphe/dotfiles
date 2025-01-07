-- https://wezfurlong.org/wezterm/config/files.html
-- https://wezfurlong.org/wezterm/config/lua/general.html

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.front_end = "OpenGL"

config.default_prog = { 'bash' }

config.font = wezterm.font('Terminus')
config.font_size = 11

config.animation_fps = 1
-- config.default_cursor_style = 'BlinkingBlock'
config.default_cursor_style = 'SteadyBlock'

config.hide_tab_bar_if_only_one_tab = true
config.audible_bell = "Disabled"

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

config.keys = {
    { key = "t", mods = "CTRL|SHIFT", action = wezterm.action.SpawnWindow },
}

-- config.color_scheme = 'Solarized Dark (Gogh)'
config.color_scheme = 'Solarized (dark) (terminal.sexy)'

config.bold_brightens_ansi_colors = false

config.colors = {
  foreground = '#839496',
  background = '#002b36',

  cursor_bg = '#93a1a1',
  cursor_fg = '#93a1a1',
  cursor_border = '#93a1a1',

  selection_bg = '#839496',
  selection_fg = '#002b36',

  ansi = {
      "073642",  -- black
      "dc322f",  -- red
      "859900",  -- green
      "b58900",  -- yellow
      "268bd2",  -- blue
      "d33682",  -- purple
      "2aa198",  -- cyan
      "eee8d5",  -- white
  },
  brights = {
      "002b36",
      "cb4b16",
      "586e75",
      "657b83",
      "839496",
      "6c71c4",
      "93a1a1",
      "fdf6e3",
  },

  -- Arbitrary colors of the palette in the range from 16 to 255
  indexed = { [17] = '#094655' },
}

return config
