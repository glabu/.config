-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- Catppuccin "Macchiato" Theme
-- Copyright (c) 2021
-- This source code is licensed under the MIT license found in the license file.
config.color_scheme = "Catppuccin Macchiato" -- or Mocha, Frappe, Latte

-- Change the font:
config.font_size = 19
config.font = wezterm.font("IosevkaTerm Nerd Font Mono")

---- Change the window size and position
config.initial_cols = 150
config.initial_rows = 35
config.window_padding = {
  left = "0.7cell",
	right = "0.7cell",
	top = "0.3cell",
	bottom = "0.3cell",
}

-- Eliminate the window bar
config.enable_tab_bar = false

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.macos_window_background_blur = 8

-- Return the configuration to wezterm
return config
