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
local bling_path =  gfs.get_xdg_config_home() .. "awesome/bling/"

local theme = {}

theme.font          = "MononokiNerdFont 15"

theme.bg_normal     = "#232A2EDD"
theme.bg_focus      = "#7A8478"
theme.bg_urgent     = "#5C3F45"
theme.bg_minimize   = "#2D353B"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#E5E6CF"
theme.fg_focus      = "#232A2E"
theme.fg_urgent     = "#E67E80"
theme.fg_minimize   = "#4D585E"

theme.useless_gap         = dpi(6)
theme.border_width        = dpi(3)
theme.border_color_normal = "#232A2E"
theme.border_color_active = "#83C092"
theme.border_color_marked = "#DBBC7F"

theme.hotkeys_bg               = "#232A2EF8"
theme.hotkeys_fg               = "#E5E6CF"
theme.hotkeys_border_color     = "#7FBBB3"
theme.hotkeys_modifiers_fg     = "#9DA9A0BD"
theme.hotkeys_label_bg         = "#48584E"
theme.hotkeys_label_fg         = "#83C092"
theme.hotkeys_font             = "Varino 14"
theme.hotkeys_description_font = "UbuntuNerdFont 14"

--[[ Bling ]]--
-- flash focus
theme.flash_focus_start_opacity = 0.4
theme.flash_focus_step          = 0.02

-- Window Switcher
theme.window_switcher_widget_bg = "#232A2EF8"
theme.window_switcher_widget_border_width = 3
theme.window_switcher_widget_border_radius = 8
theme.window_switcher_widget_border_color = "#7FBBB3"
theme.window_switcher_clients_spacing = 20
theme.window_switcher_client_icon_horizontal_spacing = 0
theme.window_switcher_client_width = 400
theme.window_switcher_client_height = 250
theme.window_switcher_client_margins = 10
theme.window_switcher_thumbnail_margins = 8
theme.thumbnail_scale = true
theme.window_switcher_name_margins = 16
theme.window_switcher_name_valign = "top"
theme.window_switcher_name_forced_width = 400
theme.window_switcher_name_font = "UbuntuNerdFont 14"
theme.window_switcher_name_normal_color = theme.fg_normal
theme.window_switcher_name_focus_color = theme.border_color_active
theme.window_switcher_icon_valign = "center"
theme.window_switcher_icon_width = 0

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
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    0, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_sel(
    0, theme.bg_focus
)
theme.taglist_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end
theme.taglist_shape_empty = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end
theme.taglist_shape_border_width_empty = dpi(2)
theme.taglist_shape_border_width_focus = dpi(0)
theme.taglist_shape_border_color_empty = '#83C09233'
theme.taglist_fg_focus    = "#232A2E"
theme.taglist_fg_occupied = "#232A2E"
theme.taglist_fg_empty    = "#83C09233"
theme.taglist_bg_focus    = "#83C092"
theme.taglist_bg_occupied = "#83C09255"
theme.taglist_bg_empty    = "#232A2E00"
-- theme.taglist_spacing = dpi(4)
-- theme.taglist_font        = "CuteNotes 36"
-- theme.taglist_font        = "Where My Keys 32"
-- theme.taglist_font        = "Leaf1 40"
-- theme.taglist_font        = "Leaflets 48"
theme.taglist_font        = "MononokiNerdFont Mono 46"

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

theme.wallpaper = themes_path.."everforest/wallpapers/DarkForestWithFog.png"

local icon_color = "#232A2E"

-- You can use your own layout icons like this:
-- awesome builtin layouts
theme.layout_fairh =      gears.color.recolor_image(themes_path.."gruvbox/layouts/fairhw.png"     , icon_color)
theme.layout_fairv =      gears.color.recolor_image(themes_path.."gruvbox/layouts/fairvw.png"     , icon_color)
theme.layout_floating  =  gears.color.recolor_image(themes_path.."gruvbox/layouts/floatingw.png"  , icon_color)
theme.layout_magnifier =  gears.color.recolor_image(themes_path.."gruvbox/layouts/magnifierw.png" , icon_color)
theme.layout_max =        gears.color.recolor_image(themes_path.."gruvbox/layouts/maxw.png"       , icon_color)
theme.layout_fullscreen = gears.color.recolor_image(themes_path.."gruvbox/layouts/fullscreenw.png", icon_color)
theme.layout_tilebottom = gears.color.recolor_image(themes_path.."gruvbox/layouts/tilebottomw.png", icon_color)
theme.layout_tileleft   = gears.color.recolor_image(themes_path.."gruvbox/layouts/tileleftw.png"  , icon_color)
theme.layout_tile =       gears.color.recolor_image(themes_path.."gruvbox/layouts/tilew.png"      , icon_color)
theme.layout_tiletop =    gears.color.recolor_image(themes_path.."gruvbox/layouts/tiletopw.png"   , icon_color)
theme.layout_spiral  =    gears.color.recolor_image(themes_path.."gruvbox/layouts/spiralw.png"    , icon_color)
theme.layout_dwindle =    gears.color.recolor_image(themes_path.."gruvbox/layouts/dwindlew.png"   , icon_color)
theme.layout_cornernw =   gears.color.recolor_image(themes_path.."gruvbox/layouts/cornernww.png"  , icon_color)
theme.layout_cornerne =   gears.color.recolor_image(themes_path.."gruvbox/layouts/cornernew.png"  , icon_color)
theme.layout_cornersw =   gears.color.recolor_image(themes_path.."gruvbox/layouts/cornersww.png"  , icon_color)
theme.layout_cornerse =   gears.color.recolor_image(themes_path.."gruvbox/layouts/cornersew.png"  , icon_color)

-- bling layouts
theme.layout_mstab =      gears.color.recolor_image(bling_path .."icons/layouts/mstab.png"        , icon_color)
theme.layout_centered =   gears.color.recolor_image(bling_path .."icons/layouts/centered.png"     , icon_color)
theme.layout_vertical =   gears.color.recolor_image(bling_path .."icons/layouts/vertical.png"     , icon_color)
theme.layout_horizontal = gears.color.recolor_image(bling_path .."icons/layouts/horizontal.png"   , icon_color)
theme.layout_equalarea =  gears.color.recolor_image(bling_path .."icons/layouts/equalarea.png"    , icon_color)
theme.layout_deck =       gears.color.recolor_image(bling_path .."icons/layouts/deck.png"         , icon_color)

-- Layout list theme
theme.layoutlist_bg_normal   = "#83C09233"
theme.layoutlist_bg_selected = "#83C092"

theme.layoutlist_disable_name = true

theme.layoutlist_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 2) end
theme.layoutlist_shape_selected = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 2) end
theme.layoutlist_shape_border_width = dpi(2)
theme.layoutlist_shape_border_color = "#83C09233"
theme.layoutlist_shape_border_width_selected = dpi(2)
theme.layoutlist_shape_border_color_selected = "#83C092"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    dpi(100),
    "#00000000",
    theme.hotkeys_border_color
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
