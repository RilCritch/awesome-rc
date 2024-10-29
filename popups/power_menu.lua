-- vim:fileencoding=utf-8:shiftwidth=4:tabstop=4:foldmethod=marker

-- Libraries
local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")

-- Utility
local dpi            = require("beautiful.xresources.apply_dpi")
local awesomebuttons = require("awesome-buttons.awesome-buttons")

-- Screen
local s = awful.screen.focused{}

-- Variables
local p_theme = {}
p_theme.width = 1000
p_theme.height = 600
p_theme.placement = awful.placement.centered
p_theme.border_color = beautiful.fg_urgent
p_theme.border_width = 3
p_theme.background = beautiful.hotkeys_bg
p_theme.margin_main = 8
p_theme.title_color = beautiful.hotkeys_border_color

-- Popup and Widget Definitions

local power_widget = wibox.widget {
    widget = wibox.container.margin,
    margins = dpi(p_theme.margin_main),
    forced_width = dpi(p_theme.width - p_theme.margin_main),
    forced_height = dpi(p_theme.height - p_theme.margin_main),
}

local popup_title = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "<span foreground='" .. p_theme.title_color .. "'>POWER MENU</span",
    halign = "center",
    font = "Varino 24",
}

-- local power_popup = awful.popup {
--     screen = s,
--     type = "popup_menu",
--     visible = false,
--     ontop = true,
--     -- Placement and Sizing
--     width = dpi(p_theme.width),
--     height = dpi(p_theme.height),
--     placement = p_theme.placement,
--     -- Theming
--     border_color = p_theme.border_color,
--     border_width = dpi(p_theme.border_width),
--     background = p_theme.background,
--     shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
--     widget = power_widget,
-- }

-- Create button (https://github.com/streetturtle/awesome-wm-widgets/blob/master/logout-popup-widget/logout-popup.lua)
local function create_button(icon_name, action_name, accent_color, label_color, onclick, icon_size, icon_margin)
end
