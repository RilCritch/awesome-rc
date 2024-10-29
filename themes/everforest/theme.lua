---------------------------
-- Everforest awesome theme --
---------------------------
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi = xresources.apply_dpi

local gears = require("gears") -- utilities such as color parsing and objects

local gfs = require("gears.filesystem")
local themes_path = gfs.get_xdg_config_home() .. "awesome/themes/"
local bling_path  = gfs.get_xdg_config_home() .. "awesome/lib/bling/"
local lain_path   = gfs.get_xdg_config_home() .. "awesome/lib/lain/"

local theme = {}

theme.main_font      = "UbuntuSans Nerd Font"
theme.title_font     = "UbuntuSans Nerd Font Bold 16"
theme.mono_font      = "JetBrainsMono Nerd Font 15"
theme.mono_bold_font = "JetBrainsMono Nerd Font Bold 15"
theme.special_font   = "Varino" -- add size later

-- Colors
theme.transparent = "#00000000"

theme.fg_main   = "#E5DFC5"
theme.fg_light  = "#FDF6E3"
theme.fg_1      = "#F3EAD3"
theme.fg_2      = "#DDD8BE"
theme.fg_3      = "#D3C6AA"

theme.bg_main   = "#1E2326"
theme.bg_dark   = "#161A1D"
theme.bg_1      = "#232A2E"
theme.bg_2      = "#272E33"
theme.bg_3      = "#333C43"

theme.surface_0 = "#3A464C"
theme.surface_1 = "#414B50"
theme.surface_2 = "#495156"
theme.surface_3 = "#555F66"

theme.gray_0    = "#5D6B66"
theme.gray_1    = "#7A8478"
theme.gray_2    = "#859289"
theme.gray_3    = "#9DA9A0"

theme.red       = "#E67E80"
theme.orange    = "#E69875"
theme.yellow    = "#DBBC7F"
theme.green     = "#A7C080"
theme.cyan      = "#83C092"
theme.blue      = "#7FBBB3"
theme.magenta   = "#D699B6"

theme.red_bg    = "#543A48"
theme.orange_bg = "#59464C"
theme.green_bg  = "#425047"
theme.blue_bg   = "#3A515D"
theme.yellow_bg = "#4D4C43"


-- Theme Variables
theme.font = theme.main_font .. " 14"

theme.bg_normal     = theme.bg_main .. "F0"
theme.bg_light      = theme.bg_2 .. "F0"
theme.bg_focus      = theme.cyan
theme.bg_urgent     = theme.red_bg
theme.bg_minimize   = theme.bg_3
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = theme.fg_main
theme.fg_dimmed     = theme.gray_3 .. "BD"
theme.fg_focus      = theme.bg_main
theme.fg_active     = theme.cyan
theme.fg_active_alt = theme.blue
theme.fg_empty      = theme.cyan .. "33"
theme.fg_non_active = theme.cyan .. "55"
theme.fg_important  = theme.yellow
theme.fg_urgent     = theme.red
theme.fg_minimize   = theme.gray_0

theme.useless_gap         = dpi(12)
theme.border_width        = dpi(3)
theme.border_color_normal = theme.surface_1
theme.border_color_active = theme.fg_active
theme.border_color_marked = theme.fg_important

theme.popup_bg_normal     = theme.bg_dark .. "D0"
theme.popup_bg_light      = theme.bg_minimize
theme.popup_border_normal = theme.fg_active_alt
theme.popup_border_alt    = theme.fg_important

theme.hotkeys_bg               = theme.popup_bg_normal
theme.hotkeys_fg               = theme.fg_normal
theme.hotkeys_border_color     = theme.popup_border_normal
theme.hotkeys_modifiers_fg     = theme.fg_dimmed
theme.hotkeys_label_fg         = theme.fg_focus
theme.hotkeys_font             = theme.mono_bold_font
theme.hotkeys_description_font = theme.font

--[[ Bling ]]--
-- flash focus
theme.flash_focus_start_opacity = 0.70
theme.flash_focus_step          = 0.01

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
theme.taglist_shape_border_width          = theme.border_width
theme.taglist_shape_border_color_empty    = theme.fg_empty
theme.taglist_shape_border_color_focus    = theme.bg_focus
theme.taglist_shape_border_color          = theme.fg_non_active
theme.taglist_fg_focus    = theme.fg_focus
theme.taglist_fg_occupied = theme.fg_focus
theme.taglist_fg_empty    = theme.fg_empty
theme.taglist_bg_focus    = theme.bg_focus
theme.taglist_bg_occupied = theme.fg_non_active
theme.taglist_bg_empty    = theme.transparent
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
-- theme.menu_submenu_icon = themes_path.."icons/submenu.svg"
-- theme.menu_submenu_icon = gears.color.recolor_image(
--     theme.menu_submenu_icon,
--     theme.fg_focus
-- )

theme.menu_height = dpi(32)
theme.menu_width  = dpi(240)

theme.wallpaper = themes_path.."everforest/wallpapers/foggy-dark-valley.jpg"

local icon_color = theme.bg_main

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
theme.layout_mstab =      gears.color.recolor_image(bling_path .."icons/layouts/mstab.png"          , icon_color)
theme.layout_centered =   gears.color.recolor_image(bling_path .."icons/layouts/centered-right.png" , icon_color)
theme.layout_vertical =   gears.color.recolor_image(bling_path .."icons/layouts/vertical.png"       , icon_color)
theme.layout_horizontal = gears.color.recolor_image(bling_path .."icons/layouts/horizontal.png"     , icon_color)
theme.layout_equalarea =  gears.color.recolor_image(bling_path .."icons/layouts/equalarea.png"      , icon_color)
theme.layout_deck =       gears.color.recolor_image(bling_path .."icons/layouts/deck.png"           , icon_color)

-- lain layouts
theme.lain_icons         = lain_path .. "icons/layout/default/"
theme.layout_termfair    = theme.lain_icons .. "termfair.png"
theme.layout_centerfair  = theme.lain_icons .. "centerfair.png"  -- termfair.center
theme.layout_cascade     = theme.lain_icons .. "cascade.png"
theme.layout_cascadetile = theme.lain_icons .. "cascadetile.png" -- cascade.tile
theme.layout_centerwork  = gears.color.recolor_image(bling_path .."icons/layouts/centered-left.png"     , icon_color)
theme.layout_centerworkh = theme.lain_icons .. "centerworkh.png" -- centerwork.horizontal

-- Layout list theme
theme.layoutlist_bg_normal   = theme.fg_empty
theme.layoutlist_bg_selected = theme.fg_active

theme.layoutlist_disable_name = true

theme.layoutlist_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end
theme.layoutlist_shape_selected = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end
theme.layoutlist_shape_border_width = theme.border_width
theme.layoutlist_shape_border_color = theme.fg_empty
theme.layoutlist_shape_border_width_selected = theme.border_width
theme.layoutlist_shape_border_color_selected = theme.fg_active

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
