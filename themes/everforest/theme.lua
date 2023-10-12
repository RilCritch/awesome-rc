---------------------------
-- Gruvbox awesome theme --
---------------------------

-- NOTE: This is just an initial theme
-- I need to create a more indepth theme
-- I want to use a colors table for this
-- This is so I can create themes easier

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi = xresources.apply_dpi

local gears = require("gears") -- utilities such as color parsing and objects

local gfs = require("gears.filesystem")
local themes_path = gfs.get_xdg_config_home() .. "awesome/themes/"

local theme = {}

theme.font          = "MononokiNerdFont 15"

theme.bg_normal     = "#272E33"
theme.bg_focus      = "#555F66"
theme.bg_urgent     = "#5C3F45"
theme.bg_minimize   = "#272E33"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#D3C6AA"
theme.fg_focus      = "#F3EAD3"
theme.fg_urgent     = "#D3C6AA"
theme.fg_minimize   = "#5D6B66"

theme.useless_gap         = dpi(10)
theme.border_width        = dpi(2)
theme.border_color_normal = "#1E2326"
theme.border_color_active = "#A7C080"
theme.border_color_marked = "#E69875"

theme.hotkeys_bg               = "#1E2326"
theme.hotkeys_fg               = "#D3C6AA"
theme.hotkeys_border_width     = dpi(2)
theme.hotkeys_border_color     = "#D3C6AA"
theme.hotkeys_modifiers_fg     = "#A7C080"
theme.hotkeys_label_bg         = "#48584E"
theme.hotkeys_label_fg         = "#F3EAD3"
theme.hotkeys_font             = "MononokiNerdFont 16"
theme.hotkeys_description_font = "UbuntuNerdFont 14"


-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(6)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_spacing = dpi(4)

-- Tasklist
theme.tasklist_disable_icon = true


-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."icons/submenu.svg"
theme.menu_submenu_icon = gears.color.recolor_image(
    theme.menu_submenu_icon,
    theme.fg_focus
)

theme.menu_height = dpi(32)
theme.menu_width  = dpi(240)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
-- theme.titlebar_close_button_normal = themes_path.."gruvbox/titlebar/close_normal.png"
-- theme.titlebar_close_button_focus  = themes_path.."gruvbox/titlebar/close_focus.png"
--
-- theme.titlebar_minimize_button_normal = themes_path.."gruvbox/titlebar/minimize_normal.png"
-- theme.titlebar_minimize_button_focus  = themes_path.."gruvbox/titlebar/minimize_focus.png"
--
-- theme.titlebar_ontop_button_normal_inactive = themes_path.."gruvbox/titlebar/ontop_normal_inactive.png"
-- theme.titlebar_ontop_button_focus_inactive  = themes_path.."gruvbox/titlebar/ontop_focus_inactive.png"
-- theme.titlebar_ontop_button_normal_active =   themes_path.."gruvbox/titlebar/ontop_normal_active.png"
-- theme.titlebar_ontop_button_focus_active  =   themes_path.."gruvbox/titlebar/ontop_focus_active.png"
--
-- theme.titlebar_sticky_button_normal_inactive = themes_path.."gruvbox/titlebar/sticky_normal_inactive.png"
-- theme.titlebar_sticky_button_focus_inactive  = themes_path.."gruvbox/titlebar/sticky_focus_inactive.png"
-- theme.titlebar_sticky_button_normal_active =   themes_path.."gruvbox/titlebar/sticky_normal_active.png"
-- theme.titlebar_sticky_button_focus_active  =   themes_path.."gruvbox/titlebar/sticky_focus_active.png"
--
-- theme.titlebar_floating_button_normal_inactive = themes_path.."gruvbox/titlebar/floating_normal_inactive.png"
-- theme.titlebar_floating_button_focus_inactive  = themes_path.."gruvbox/titlebar/floating_focus_inactive.png"
-- theme.titlebar_floating_button_normal_active =   themes_path.."gruvbox/titlebar/floating_normal_active.png"
-- theme.titlebar_floating_button_focus_active  =   themes_path.."gruvbox/titlebar/floating_focus_active.png"
--
-- theme.titlebar_maximized_button_normal_inactive = themes_path.."gruvbox/titlebar/maximized_normal_inactive.png"
-- theme.titlebar_maximized_button_focus_inactive  = themes_path.."gruvbox/titlebar/maximized_focus_inactive.png"
-- theme.titlebar_maximized_button_normal_active =   themes_path.."gruvbox/titlebar/maximized_normal_active.png"
-- theme.titlebar_maximized_button_focus_active  =   themes_path.."gruvbox/titlebar/maximized_focus_active.png"

theme.wallpaper = themes_path.."gruvbox/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh =      gears.color.recolor_image(themes_path.."gruvbox/layouts/fairhw.png"     , "#859289")
theme.layout_fairv =      gears.color.recolor_image(themes_path.."gruvbox/layouts/fairvw.png"     , "#859289")
theme.layout_floating  =  gears.color.recolor_image(themes_path.."gruvbox/layouts/floatingw.png"  , "#859289")
theme.layout_magnifier =  gears.color.recolor_image(themes_path.."gruvbox/layouts/magnifierw.png" , "#859289")
theme.layout_max =        gears.color.recolor_image(themes_path.."gruvbox/layouts/maxw.png"       , "#859289")
theme.layout_fullscreen = gears.color.recolor_image(themes_path.."gruvbox/layouts/fullscreenw.png", "#859289")
theme.layout_tilebottom = gears.color.recolor_image(themes_path.."gruvbox/layouts/tilebottomw.png", "#859289")
theme.layout_tileleft   = gears.color.recolor_image(themes_path.."gruvbox/layouts/tileleftw.png"  , "#859289")
theme.layout_tile =       gears.color.recolor_image(themes_path.."gruvbox/layouts/tilew.png"      , "#859289")
theme.layout_tiletop =    gears.color.recolor_image(themes_path.."gruvbox/layouts/tiletopw.png"   , "#859289")
theme.layout_spiral  =    gears.color.recolor_image(themes_path.."gruvbox/layouts/spiralw.png"    , "#859289")
theme.layout_dwindle =    gears.color.recolor_image(themes_path.."gruvbox/layouts/dwindlew.png"   , "#859289")
theme.layout_cornernw =   gears.color.recolor_image(themes_path.."gruvbox/layouts/cornernww.png"  , "#859289")
theme.layout_cornerne =   gears.color.recolor_image(themes_path.."gruvbox/layouts/cornernew.png"  , "#859289")
theme.layout_cornersw =   gears.color.recolor_image(themes_path.."gruvbox/layouts/cornersww.png"  , "#859289")
theme.layout_cornerse =   gears.color.recolor_image(themes_path.."gruvbox/layouts/cornersew.png"  , "#859289")

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Set different colors for urgent notifications.
rnotification.connect_signal('request::rules', function()
    rnotification.append_rule {
        rule       = { urgency = 'critical' },
        properties = { bg = '#4C3743', fg = '#F3EAD3' }
    }
end)

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
