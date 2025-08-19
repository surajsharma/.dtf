local wezterm = require("wezterm")

local config = {}

-- Use config builder object if available (newer versions)
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Window configuration
config.initial_rows = 50
config.initial_cols = 120
config.window_decorations = "NONE"
config.window_background_opacity = 0.88
config.text_background_opacity = 1.0

-- Force window to be borderless and undecorated
config.window_close_confirmation = "NeverPrompt"

-- Start maximized - NixOS/Linux specific methods
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- Alternative: set window to fullscreen if maximize doesn't work
-- wezterm.on('gui-startup', function(cmd)
--   local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
--   window:gui_window():set_inner_size(9999, 9999)
-- end)

-- Color scheme - using Tokyo Night theme
-- config.color_scheme = 'Tokyo Night'

-- Alternative dark themes you can try:
-- config.color_scheme = 'Dracula'
-- config.color_scheme = 'OneDark'
-- config.color_scheme = 'Gruvbox Dark (Gogh)'
-- config.color_scheme = 'Catppuccin Mocha'
-- config.color_scheme = "Kasugano (terminal.sexy)"
-- config.color_scheme = "Kanagawa (Gogh)"
-- config.color_scheme = "Kanagawa Dragon (Gogh)"
-- config.color_scheme = "Konsolas"
config.color_scheme = "Sex Colors (terminal.sexy)"
-- config.color_scheme = "Sundried"
-- config.color_scheme = "SOS (terminal.sexy)"

-- Font configuration
config.font = wezterm.font("Berkeley Mono")
config.font_size = 12.0

-- Cursor configuration
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500

-- Tab bar configuration
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false

-- Scrollback
config.scrollback_lines = 10000

-- Enable scrollbar
config.enable_scroll_bar = false

-- Window padding
config.window_padding = {
	left = 8,
	right = 8,
	top = 8,
	bottom = 8,
}

-- Disable audible bell
config.audible_bell = "Disabled"

-- Key bindings (optional - common useful ones)
config.keys = {
	-- Split panes
	{
		key = "d",
		mods = "CMD",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "d",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Close pane
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	-- Navigate panes
	{
		key = "LeftArrow",
		mods = "CMD|OPT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "RightArrow",
		mods = "CMD|OPT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "UpArrow",
		mods = "CMD|OPT",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "DownArrow",
		mods = "CMD|OPT",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
}

return config
