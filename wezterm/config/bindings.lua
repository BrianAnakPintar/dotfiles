local wezterm = require "wezterm"
local act = wezterm.action

-- Detect platform and set modifier keys accordingly
local mod = {}
if wezterm.target_triple:find("apple") then
  mod.SUPER = "SUPER"
  mod.SUPER_REV = "SUPER|CTRL"
else
  mod.SUPER = "ALT"
  mod.SUPER_REV = "ALT|CTRL"
end

-- Build config
local config = wezterm.config_builder and wezterm.config_builder() or {}

-- Aesthetics
config.color_scheme = "Catppuccin Macchiato"
config.font = wezterm.font("JetBrains Mono")
config.font_size = 16
config.window_decorations = "RESIZE"
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_and_split_indices_are_zero_based = true

-- Leader key (tmux style)
config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 2000 }

-- Keybindings
local keys = {
  -- Tmux-style
  { mods = "LEADER", key = "c", action = act.SpawnTab "CurrentPaneDomain" },
  { mods = "LEADER", key = "x", action = act.CloseCurrentPane { confirm = true } },
  { mods = "LEADER", key = "b", action = act.ActivateTabRelative(-1) },
  { mods = "LEADER", key = "n", action = act.ActivateTabRelative(1) },
  { mods = "LEADER", key = "|", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { mods = "LEADER", key = "-", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { mods = "LEADER", key = "h", action = act.ActivatePaneDirection "Left" },
  { mods = "LEADER", key = "j", action = act.ActivatePaneDirection "Down" },
  { mods = "LEADER", key = "k", action = act.ActivatePaneDirection "Up" },
  { mods = "LEADER", key = "l", action = act.ActivatePaneDirection "Right" },
  { mods = "LEADER", key = "LeftArrow", action = act.AdjustPaneSize { "Left", 5 } },
  { mods = "LEADER", key = "RightArrow", action = act.AdjustPaneSize { "Right", 5 } },
  { mods = "LEADER", key = "DownArrow", action = act.AdjustPaneSize { "Down", 5 } },
  { mods = "LEADER", key = "UpArrow", action = act.AdjustPaneSize { "Up", 5 } },

  -- Functional F keys
  { key = "F1", mods = "NONE", action = "ActivateCopyMode" },
  { key = "F2", mods = "NONE", action = act.ActivateCommandPalette },
  { key = "F3", mods = "NONE", action = act.ShowLauncher },
  { key = "F4", mods = "NONE", action = act.ShowLauncherArgs { flags = "FUZZY|TABS" } },
  { key = "F5", mods = "NONE", action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" } },
  { key = "F11", mods = "NONE", action = act.ToggleFullScreen },
  { key = "F12", mods = "NONE", action = act.ShowDebugOverlay },

  -- Search and Quick Select
  { key = "f", mods = mod.SUPER, action = act.Search { CaseInSensitiveString = "" } },
  {
    key = "u",
    mods = mod.SUPER,
    action = act.QuickSelectArgs {
      label = "open url",
      patterns = {
        "\\((https?://\\S+)\\)",
        "\\[(https?://\\S+)\\]",
        "\\{(https?://\\S+)\\}",
        "<(https?://\\S+)>",
        "\\bhttps?://\\S+[)/a-zA-Z0-9-]+",
      },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.log_info("opening: " .. url)
        wezterm.open_with(url)
      end),
    },
  },

  -- Cursor movement
  { key = "LeftArrow", mods = mod.SUPER, action = act.SendString "\x1bOH" },
  { key = "RightArrow", mods = mod.SUPER, action = act.SendString "\x1bOF" },
  { key = "Backspace", mods = mod.SUPER, action = act.SendString "\x15" },

  -- Tabs
  { key = "t", mods = mod.SUPER, action = act.SpawnTab "DefaultDomain" },
  { key = "t", mods = mod.SUPER_REV, action = act.SpawnTab { DomainName = "WSL:Ubuntu" } },
  { key = "x", mods = mod.SUPER_REV, action = act.CloseCurrentTab { confirm = false } },
  { key = "[", mods = mod.SUPER, action = act.ActivateTabRelative(-1) },
  { key = "]", mods = mod.SUPER, action = act.ActivateTabRelative(1) },
  { key = "[", mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) },
  { key = "]", mods = mod.SUPER_REV, action = act.MoveTabRelative(1) },

  -- Windows
  { key = "n", mods = mod.SUPER, action = act.SpawnWindow },

  -- Panes
  { key = [[\]], mods = "CMD|SHIFT", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = [[\]], mods = mod.SUPER, action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "Enter", mods = "SUPER|SHIFT", action = act.TogglePaneZoomState },
  { key = "Enter", mods = mod.SUPER, action = act.TogglePaneZoomState },
  { key = "x", mods = mod.SUPER, action = act.CloseCurrentPane { confirm = false } },
  { key = "h", mods = mod.SUPER, action = act.ActivatePaneDirection "Left" },
  { key = "j", mods = mod.SUPER, action = act.ActivatePaneDirection "Down" },
  { key = "k", mods = mod.SUPER, action = act.ActivatePaneDirection "Up" },
  { key = "l", mods = mod.SUPER, action = act.ActivatePaneDirection "Right" },
  {
    key = "p",
    mods = mod.SUPER_REV,
    action = act.PaneSelect { alphabet = "1234567890", mode = "SwapWithActiveKeepFocus" },
  },

  -- Key tables
  {
    key = "f",
    mods = "SUPER|SHIFT",
    action = act.ActivateKeyTable { name = "resize_font", one_shot = false, timeout_milliseconds = 1000 },
  },
  {
    key = "p",
    mods = "SUPER|SHIFT",
    action = act.ActivateKeyTable { name = "resize_pane", one_shot = false, timeout_milliseconds = 1000 },
  },

  -- Shortcuts
  {
    key = "s",
    mods = "SUPER|SHIFT",
    action = act.SpawnCommandInNewTab {
      args = { "ssh", "bmoniaga@remote.students.cs.ubc.ca" },
    },
  },
  {
    key = "o",
    mods = "SUPER|SHIFT",
    action = act.SendString "cd $HOME/Documents/PersonalProjects",
  },
  {
    key = "l",
    mods = "SUPER|SHIFT",
    action = act.SendString "cd $HOME/Documents/school/Year\\ 3/",
  },
  {
    key = "c",
    mods = "SUPER|SHIFT",
    action = act.SendString "cd $HOME/.config",
  },
}

-- Add leader + number keybindings for tab switching
for i = 0, 9 do
  table.insert(keys, {
    key = tostring(i),
    mods = "LEADER",
    action = wezterm.action.ActivateTab(i),
  })
end

config.keys = keys

-- Key tables
config.key_tables = {
  resize_font = {
    { key = "k", action = act.IncreaseFontSize },
    { key = "j", action = act.DecreaseFontSize },
    { key = "r", action = act.ResetFontSize },
    { key = "Escape", action = "PopKeyTable" },
    { key = "q", action = "PopKeyTable" },
  },
  resize_pane = {
    { key = "k", action = act.AdjustPaneSize { "Up", 1 } },
    { key = "j", action = act.AdjustPaneSize { "Down", 1 } },
    { key = "h", action = act.AdjustPaneSize { "Left", 1 } },
    { key = "l", action = act.AdjustPaneSize { "Right", 1 } },
    { key = "Escape", action = "PopKeyTable" },
    { key = "q", action = "PopKeyTable" },
  },
}

-- Mouse bindings
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = act.OpenLinkAtMouseCursor,
  },
}

-- Status line
wezterm.on("update-right-status", function(window, _)
  local prefix = ""
  local arrow = ""
  local arrow_color = { Foreground = { Color = "#c6a0f6" } }

  if window:leader_is_active() then
    prefix = " " .. utf8.char(0x1f30a) -- 🌊
    arrow = utf8.char(0xe0b2)
  end

  if window:active_tab():tab_id() ~= 0 then
    arrow_color = { Foreground = { Color = "#1e2030" } }
  end

  window:set_left_status(wezterm.format {
    { Background = { Color = "#b7bdf8" } },
    { Text = prefix },
    arrow_color,
    { Text = arrow },
  })
end)

return config
