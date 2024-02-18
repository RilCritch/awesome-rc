-- vim:fileencoding=utf-8:shiftwidth=4:tabstop=4:foldmethod=marker
-- awesome_mode: api-level=4:screen=on

-- annoying warnings

--[[ LuaRocks ]]--
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local os = require("os")
local ipairs = ipairs

--[[ Awesome Modules ]]--
local gears = require("gears") -- utilities such as color parsing and objects
local awful = require("awful") -- everything related to window management
require("awful.remote")

require("awful.autofocus") -- Handling of focus when focused window disappears

local wibox     = require("wibox") -- awesome's generic widget framework
local beautiful = require("beautiful") -- awesome theme module

local ruled   = require("ruled") -- define declarative rules on various rules

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

--[[ Error Handling ]]--
require("main.errorhandling") -- ./main/errorhandling.lua

--[[ My Modules ]]--
-- Global namespace, created before requiring any modules
RC = {}
RC.vars = require("main.uservariables") -- ./main/uservariables.lua

-- Custom local libraries
local main = {
    layouts = require("main.layouts"), -- ./main/layouts.lua
    tags    = require("main.tags"),    -- ./main/tags.lua
    rules   = require("main.rules"),   -- ./main/rules.lua
}

local binding = {
    globalbuttons = require("binding.globalbuttons"), -- ./binding/globalbuttons.lua
    clientbuttons = require("binding.clientbuttons"), -- ./binding/clientbuttons.lua
    globalkeys    = require("binding.globalkeys"),    -- ./binding/globalkeys.lua
    bindtotags    = require("binding.bindtotags"),    -- ./binding/bindtotags.lua
    clientkeys    = require("binding.clientkeys"),    -- ./binding/clientkeys.lua
}

-- local utils = {
--     win = require("util.windows")
-- }

-- test
-- local x01 = utils.win.align_x(0.5, 1000)
-- print(x01)

--  TODO: Need to figure out what do with this for modular approach
-- initialize theme variables
beautiful.init(gears.filesystem.get_xdg_config_home() .. "awesome/themes/everforest/theme.lua")


--[[ Third Party Modules ]]--
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')

local bling_module = require("bling.module")

local rubato = require ("rubato")


--[[ Bling Modules ]]--
-- variables
local spad_term = "kitty -c '/home/rc/Repos/configs-ril/kitty/specialconfigs/scratchpad.conf'"
-- Scratchpads
local term_scratch = bling_module.scratchpad {
    command = spad_term .. " --class spadone",
    rule = { instance = "spadone" },
    sticky = true,
    above = true,
    autoclose = true,
    floating = true,
    geometry = { x=1660, y=90, height=1200, width=1800 },
    reapply = true,
    dont_focus_before_close  = true,
    -- rubato = {x = anim_x, y = anim_y}
}

local term_scratch_two = bling_module.scratchpad {
    command = spad_term .. " --class spadtwo",
    rule = { instance = "spadtwo" },
    sticky = true,
    above = true,
    autoclose = true,
    floating = true,
    geometry = { x=1660, y=90, height=1200, width=1800 },
    reapply = true,
    dont_focus_before_close  = true,
    -- rubato = {x = anim_x, y = anim_y}
}

local clip_scratch = bling_module.scratchpad {
    command = spad_term .. " --class spadthree bash -i '/home/rc/Repos/scripts-ril/menus/fzf-clip.sh'",
    -- command = spad_term .. " -o shell_integration=disabled --class spadthree " ..  "clipcat-menu",
    rule = { instance = "spadthree" },
    sticky = true,
    above = true,
    autoclose = true,
    floating = true,
    geometry = { x=1860, y=90, height=1200, width=1400 },
    reapply = true,
    dont_focus_before_close  = true,
    -- rubato = {x = anim_x, y = anim_y}
}

local repos_scratch = bling_module.scratchpad {
    command = spad_term .. " --class spadfour '/home/rc/Repos/scripts-ril/menus/fzf-manage-repos.sh'",
    rule = { instance = "spadfour" },
    sticky = true,
    above = true,
    autoclose = true,
    floating = true,
    geometry = { x=2060, y=30, height=1370, width=1000 },
    reapply = true,
    dont_focus_before_close  = true,
    -- rubato = {x = anim_x, y = anim_y}
}

local calc_scratch = bling_module.scratchpad {
    command = spad_term .. " --class spadfive kalker",
    rule = { instance = "spadfive" },
    sticky = true,
    above = true,
    autoclose = true,
    floating = true,
    geometry = { x=1860, y=30, height=1370, width=1400 },
    reapply = true,
    dont_focus_before_close  = true,
    -- rubato = {x = anim_x, y = anim_y}
}

--[[ Hotkeys popup ]]--
-- Popup widget that shows declared hotkeys w/ descriptions
local hotkeys = require("awful.hotkeys_popup")
local my_hotkeys_popup = hotkeys.widget.new({
    -- width        = 2560,
    width        = 2560,
    height       = 550,
    border_width = 3,
    group_margin = 65,
    shape    = gears.shape.rounded_rect,
})

-- Setting group colors
my_hotkeys_popup:add_group_rules("󱃻  Client Actions",    { color = "#83C092" })
my_hotkeys_popup:add_group_rules("󰂮  Client Editing",    { color = "#7FBBB3" })
my_hotkeys_popup:add_group_rules("󰲋  Client Navigation", { color = "#83C092" })
my_hotkeys_popup:add_group_rules("󰌨  Layout Actions",    { color = "#7FBBB3" })
my_hotkeys_popup:add_group_rules("󱢒  Layout Editing",    { color = "#83C092" })
my_hotkeys_popup:add_group_rules("󰽏  Open Popups",       { color = "#7FBBB3" })
my_hotkeys_popup:add_group_rules("󰌧  Run Programs",      { color = "#83C092" })
my_hotkeys_popup:add_group_rules("󱤈  Tag Navigation",    { color = "#7FBBB3" })
my_hotkeys_popup:add_group_rules("  Window Manager",    { color = "#859289" })


--[[ Variables ]]--

-- Termporarily include these until I move keydindings to separate file
local terminal = RC.vars.terminal
local editor_cmd = RC.vars.editor_cmd
local modkey = RC.vars.modkey
local browser = RC.vars.browser
local launcher = RC.vars.launcher


--[[ Tag Layouts ]]--
RC.layouts = main.layouts()

-- Set global layouts
tag.connect_signal("request::default_layouts", function() -- maybe move this part to external
    awful.layout.append_default_layouts(
        RC.layouts -- ./main/layouts.lua
    )
end)


--[[ Wallpaper ]]--
screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
        screen = s,
        widget = {
            {
                image     = beautiful.wallpaper,
                upscale   = true,
                downscale = true,
                widget    = wibox.widget.imagebox,
            },
            valign = "center",
            halign = "center",
            tiled  = false,
            widget = wibox.container.tile,
        }
    }
end)


--[[ Tags ~ Workspaces ]]--
RC.tags = main.tags()


--[[ Wibar ]]--
screen.connect_signal("request::desktop_decoration", function(s)
    s.myrightwibox = awful.wibar { -- {{{
        position = "right",
        stretch  = true,
        width    = dpi(80),
        opacity  = 0.95,
        -- border_width = dpi(1),
        -- border_color = "#000000",
        screen   = s,
        widget   = {
            layout = wibox.layout.align.vertical,

            { --[[-( Top Widgets )-]]-- {{{{
                layout = wibox.layout.fixed.vertical,

                { --[[ Time Widget ]]-- {{{{{
                    widget = wibox.container.margin,
                    top    = dpi(8),
                    left   = dpi(0),
                    right  = dpi(0),
                    {
                        widget = wibox.container.background,
                        fg     = "#83C092",
                        {
                            layout = wibox.layout.fixed.vertical,
                            { -- ( Hours )
                                widget = wibox.container.margin,
                                top    = dpi(6),
                                {
                                    widget = wibox.widget.textclock,
                                    format = "%I",
                                    font   = "Varino 22",
                                    halign = "center",
                                },
                            },
                            { -- ( AM | PM )
                                widget = wibox.container.background,
                                fg     = "#83C09265",
                                {
                                    widget = wibox.container.margin,
                                    top    = dpi(-1),
                                    bottom = dpi(1),
                                    {
                                        widget = wibox.widget.textclock,
                                        format = "%p",
                                        font   = "Varino 10",
                                        halign = "center",
                                    },
                                },
                            },
                            { -- ( Minutes )
                                widget = wibox.container.margin,
                                top    = dpi(0),
                                bottom = dpi(0),
                                {
                                    widget = wibox.widget.textclock,
                                    format = "%M",
                                    font   = "Varino 22",
                                    halign = "center",
                                },
                            },
                        },
                    },
                }, -- }}}}}

                { --[[ Date Widget ]]-- {{{{{
                    widget = wibox.container.margin,
                    top    = dpi(2),
                    left   = dpi(0),
                    right  = dpi(0),
                    {
                        widget       = wibox.container.background,
                        shape        = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 2) end,
                        {
                            layout = wibox.layout.fixed.vertical,
                            {
                                widget = wibox.container.margin,
                                top    = dpi(12),
                                bottom = dpi(0),
                                left   = dpi(0),
                                right  = dpi(0),
                                {
                                    widget = wibox.container.background,
                                    fg     = "#7FBBB3",
                                    {
                                        widget = wibox.widget.textclock,
                                        format = "%a",
                                        font   = "Varino 12",
                                        halign = "center",
                                    },
                                },
                            },
                            {
                                widget = wibox.container.margin,
                                top    = dpi(4),
                                bottom = dpi(8),
                                left   = dpi(0),
                                right  = dpi(0),
                                {
                                    widget = wibox.container.background,
                                    fg     = "#83C09265",
                                    {
                                        widget = wibox.widget.textclock,
                                        format = "%m-%d",
                                        font   = "Varino 10",
                                        halign = "center",
                                    },
                                }
                            },
                        },
                    },
                }, -- }}}}}
            }, -- }}}}

            { --[[-( Middle Widgets )-]]--  {{{{
                widget = wibox.container.place,
                valign = "center",
                {
                    widget = wibox.container.margin,
                    left   = dpi(16),
                    right  = dpi(16),
                    {
                        widget = awful.widget.layoutlist {
                            screen = s,
                            base_layout = wibox.widget {
                                layout  = wibox.layout.flex.vertical,
                                spacing = dpi(24),
                            },
                            widget_template = {
                                id     = 'background_role',
                                widget = wibox.container.background,
                                shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 2) end,
                                {
                                    id     = 'icon_role',
                                    widget = wibox.widget.imagebox,
                                }
                            }
                        },
                    },
                },
            }, -- }}}}

            { --[[-( Bottom Widgets )-]]-- {{{{
                widget = wibox.container.place,
                valign = "bottom",
                halign = "center",
                {
                    widget = wibox.container.margin,
                    top    = dpi(0),
                    bottom = dpi(16),
                    left   = dpi(16),
                    right  = dpi(16),
                    {
                        widget = wibox.container.background,
                        border_width = 2,
                        border_color = beautiful.hotkeys_border_color,
                        bg           = "#00000000",
                        shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 3) end,
                        {
                            widget = wibox.widget.imagebox,
                            image  = beautiful.awesome_icon,
                            resize = true,
                        },
                    },
                },
            }, -- }}}}
        },
    } -- }}}

    s.myleftwibox = awful.wibar { -- {{{
        position = "left",
        stretch  = true,
        width    = dpi(80),
        opacity  = 0.95,
        screen   = s,
        widget   = {
            layout = wibox.layout.align.vertical,

            { --[[-( Top Widgets )-]]-- {{{{
                layout = wibox.layout.fixed.vertical,
                {
                    widget = wibox.container.margin,
                    top    = dpi(8),
                    bottom = dpi(12),
                    left   = dpi(12),
                    right  = dpi(12),
                    {
                        widget        = wibox.container.background,
                        border_width  = 0,
                        border_color  = beautiful.hotkeys_border_color,
                        bg            = "#00000000",
                        -- bg            = beautiful.hotkeys_border_color,
                        shape         = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 3) end,
                        -- forced_width  = dpi(52),
                        -- forced_height = dpi(52),
                        {
                            widget = wibox.container.margin,
                            top    = dpi(6),
                            {
                                widget = wibox.container.place,
                                halign = "center",
                                -- valign = "center",
                                {
                                    widget = wibox.widget.textbox,
                                    markup = "<span foreground='#7FBBB3'>RC</span>",
                                    -- markup = "<span foreground='#232A2E'>RC</span>",
                                    font   = "Varino 24",
                                },
                            },
                        },
                    },
                },
                {
                    widget = wibox.container.margin,
                    top    = -8,
                    bottom = dpi(6),
                    left   = dpi(0),
                    right  = dpi(0),
                    {
                        widget = wibox.container.place,
                        halign = "center",
                        {
                            widget = wibox.widget.textbox,
                            markup = "<span foreground='#83C092AA'>DEBIAN</span>",
                            font   = "Varino 10",
                        }
                    }
                },
            }, -- }}}}

            { --[[-( Middle Widgets )-]]-- {{{{
                widget = wibox.container.place,
                valign = "center",
                {
                    widget = wibox.container.place,
                    valign = "center",
                    {
                        widget = wibox.container.margin,
                        left   = dpi(0),
                        right  = dpi(0),
                        {
                            widget = awful.widget.taglist {
                                screen  = s,
                                filter  = awful.widget.taglist.filter.all,
                                buttons = {
                                    awful.button({ }, 1, function(t) t:view_only() end),
                                    awful.button({ modkey }, 1, function(t)
                                                                    if client.focus then ---@diagnostic disable-line: undefined-global
                                                                        client.focus:move_to_tag(t) ---@diagnostic disable-line: undefined-global
                                                                    end
                                                                end),
                                    awful.button({ }, 3, awful.tag.viewtoggle),
                                    awful.button({ modkey }, 3, function(t)
                                                                    if client.focus then ---@diagnostic disable-line: undefined-global
                                                                        client.focus:toggle_tag(t) ---@diagnostic disable-line: undefined-global
                                                                    end
                                                                end),
                                    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
                                    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
                                },
                                base_layout = wibox.widget {
                                    layout  = wibox.layout.flex.vertical,
                                    spacing = dpi(24),
                                },
                                widget_template = {
                                    id            = 'background_role',
                                    widget        = wibox.container.background,
                                    forced_height = dpi(51),
                                    forced_width  = dpi(51),
                                    {
                                        widget = wibox.container.margin,
                                        top  = dpi(0),
                                        left = dpi(-1),
                                        {
                                            layout = wibox.layout.flex.horizontal,
                                            {
                                                id     = 'text_role',
                                                widget = wibox.widget.textbox,
                                                halign = "center",
                                            },
                                        },
                                    },
                                },
                            },
                        },
                    },
                },
            }, -- }}}}

            { --[[-( Bottom Widgets )-]]-- {{{{
                -- widget = wibox.container.place,
                layout = wibox.layout.fixed.vertical,
                -- widget = wibox.container.place,
                -- valign = "top",
                -- halign = "center",
                -- {
                --     widget = wibox.container.margin,
                --     top    = dpi(0),
                --     bottom = dpi(0),
                --     left   = dpi(15),
                --     right  = dpi(15),
                --     {
                --         widget        = wibox.container.background,
                --         border_width  = 0,
                --         border_color  = beautiful.border_color_active,
                --         bg            = "#00000000",
                --         shape         = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 3) end,
                --         forced_width  = dpi(52),
                --         {
                --             widget = wibox.container.place,
                --             halign = "center",
                --             {
                --                 widget = wibox.widget.textbox,
                --                 markup = "<span foreground='#83C09265'></span>",
                --                 font   = "Mononoki Nerd Font Mono 30",
                --             },
                --         },
                --     },
                -- },
                {
                    widget = wibox.container.margin,
                    top    = dpi(6),
                    bottom = dpi(12),
                    left   = dpi(12),
                    right  = dpi(12),
                    {
                        layout = wibox.layout.fixed.vertical,
                        volume_widget {
                            widget_type = "arc",
                            thickness   = 3,
                            size        = 60,
                            bg_color    = "#1E232600",
                            main_color  = "#83C092",
                            mute_color  = "#83C09288",
                        },
                    },
                },
            }, -- }}}}
        },
    } -- }}}
end)

--{{{ --[[ Bindings ]]-
--[[ Global Mouse ]]-- {{{{
awful.mouse.append_global_mousebindings( binding.globalbuttons() )
-- }}}}


--[[ Global Keys ]]--
-- use xev to see button values for system
awful.keyboard.append_global_keybindings({
    -- General Awesome keys -- {{{{
    awful.key({ modkey }, "s",
        function() my_hotkeys_popup:show_help() end,
        {description="-   Keys", group="󰽏  Open Popups"}
    ),
    awful.key({ modkey, "Shift", "Control" }, "r",
        awesome.restart,
        {description = "-   Reload", group = "  Window Manager"}
    ),
    awful.key({ modkey, "Shift", "Control" }, "q",
        awesome.quit,
        {description = "-   Logout", group = "  Window Manager"}
    ),
    -- }}}}

    --[[ My keybindings ]]--
    -- Launching Programs -- {{{{
    -- TODO: add more common applications
    awful.key({ modkey,         }, "b",
        function() awful.spawn(browser) end,
        { description = "-   Browser", group = "󰌧  Run Programs" }
    ),
    awful.key({ modkey,         }, "Return",
        function() awful.spawn(terminal) end,
        { description = "-   Terminal", group = "󰌧  Run Programs" }
    ),
    awful.key({ modkey,         }, "v",
        function() awful.spawn(editor_cmd) end,
        { description = "-   Neovim", group = "󰌧  Run Programs" }
    ),
    awful.key({ modkey,         }, "r",
        function() awful.spawn(launcher) end,
        { description = "-   Rofi", group = "󰌧  Run Programs" }
    ),
    -- }}}}

    -- Scratchpads -- {{{{
    awful.key({ modkey }, "t",
        function() term_scratch:toggle() end,
        { description = "-   Terminal 1", group = "󰽏  Open Popups" }
    ),
    awful.key({ modkey }, "y",
        function() term_scratch_two:toggle() end,
        { description = "-   Terminal 2", group = "󰽏  Open Popups" }
    ),
    awful.key({ modkey, "Control" } , "c",
        function() clip_scratch:toggle() end,
        { description = "-   Clipboard", group = "󰽏  Open Popups" }
    ),
    awful.key({ modkey, "Control" } , "r",
        function() repos_scratch:toggle() end,
        { description = "-   Mange Repos", group = "󰽏  Open Popups" }
    ),
    awful.key({ modkey, "Control" } , "k",
        function() calc_scratch:toggle() end,
        { description = "-   Kalculator", group = "󰽏  Open Popups" }
    ),
})
-- }}}}

-- Tags related keybindings -- {{{{
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "Escape",
        awful.tag.history.restore,
        {description = "-   Previous tag", group = "󱤈  Tag Navigation"}
    ),
})
-- }}}}

-- Focus related keybindings -- {{{{
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.bydirection("down")
            -- bling.module.flash_focus.flashfocus(client.focus)
        end,
        {description = "-   Focus down", group = "󰲋  Client Navigation"}
    ),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.bydirection("up")
            -- bling.module.flash_focus.flashfocus(client.focus)
        end,
        {description = "-   Focus up", group = "󰲋  Client Navigation"}
    ),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.bydirection("left")
            -- bling.module.flash_focus.flashfocus(client.focus)
        end,
        {description = "-   Focus left", group = "󰲋  Client Navigation"}
    ),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.bydirection("right")
            -- bling.module.flash_focus.flashfocus(client.focus)
        end,
        {description = "-   Focus right", group = "󰲋  Client Navigation"}
    ),
    awful.key({ modkey, "Shift" }, "Up",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:activate { raise = true, context = "key.unminimize" }
            end
        end,
        {description = "-   Restore minimized", group = "󱃻  Client Actions"}
    ),
})
-- }}}}

-- Layout related keybindings -- {{{{
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift" }, "j",
        function() awful.client.swap.bydirection("down") end,
        {description = "-   Swap down", group = "󰂮  Client Editing"}
    ),
    awful.key({ modkey, "Shift" }, "k",
        function() awful.client.swap.bydirection("up") end,
        {description = "-   Swap up", group = "󰂮  Client Editing"}
    ),
    awful.key({ modkey, "Shift" }, "h",
        function() awful.client.swap.bydirection("left") end,
        {description = "-   Swap left", group = "󰂮  Client Editing"}
    ),
    awful.key({ modkey, "Shift" }, "l",
        function() awful.client.swap.bydirection("right") end,
        {description = "-   Swap right", group = "󰂮  Client Editing"}
    ),

    awful.key({ modkey, "Shift" }, "e",
        function() awful.tag.incmwfact(0.01)  end,
        {description = "-   Inc master width", group = "󱢒  Layout Editing"}
    ),
    awful.key({ modkey, "Shift" }, "d",
        function () awful.tag.incmwfact(-0.01) end,
        {description = "-   Dec master width", group = "󱢒  Layout Editing"}
    ),

    awful.key({ modkey }, "]",
        function () awful.tag.incnmaster( 1, nil, true) end,
        {description = "-   Inc master clients", group = "󱢒  Layout Editing"}
    ),
    awful.key({ modkey }, "[",
        function () awful.tag.incnmaster(-1, nil, true) end,
        {description = "-   Dec master clients", group = "󱢒  Layout Editing"}
    ),

    awful.key({ modkey, "Control" }, "e",
        function () awful.tag.incncol(1, nil, true) end,
        {description = "-   Inc columns", group = "󱢒  Layout Editing"}
    ),
    awful.key({ modkey, "Control" }, "d",
        function () awful.tag.incncol(-1, nil, true) end,
        {description = "-   Dec columns", group = "󱢒  Layout Editing"}
    ),

    awful.key({ modkey, "Shift", "Control" }, "period",
        function () awful.layout.inc(1) end,
        {description = "-   Next layout", group = "󰌨  Layout Actions"}
    ),
    awful.key({ modkey, "Shift", "Control" }, "comma",
        function () awful.layout.inc(-1) end,
        {description = "-   Prev layout", group = "󰌨  Layout Actions"}
    ),
})
-- }}}}

-- [[ Tag Keymaps ]] -- {{{{
awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "-   View tag",
        group       = "󱤈  Tag Navigation",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    -- awful.key { -- How do add more tag key mappings
    --     modifiers   = { modkey },
    --     key         = "F1",
    --     description = "-   View tag",
    --     group       = "󱤈  Tag Navigation",
    --     on_press    = function ()
    --         local screen = awful.screen.focused()
    --         local tag = screen.tags[11]
    --         if tag then
    --             tag:view_only()
    --         end
    --     end,
    -- },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "-   Toggle tag",
        group       = "󱤈  Tag Navigation",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "-   Client to tag",
        group       = "󱤈  Tag Navigation",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
})
-- }}}}


--[[ Client Mouse ]]-- {{{{
client.connect_signal("request::default_mousebindings", function() ---@diagnostic disable-line: undefined-global
    awful.mouse.append_client_mousebindings( binding.clientbuttons() )
end)
-- }}}}


--[[ Client Keys ]]-- {{{{
client.connect_signal("request::default_keybindings", function() ---@diagnostic disable-line: undefined-global
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey, "Shift" }, "Right",
            function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "-   Fullscreen toggle", group = "󱃻  Client Actions"}
        ),
        -- TODO: change this
        awful.key({ modkey, "Shift" }, "Left",
            awful.client.floating.toggle,
            {description = "-   Floating toggle", group = "󱃻  Client Actions"}
        ),

        awful.key({ modkey, "Shift" }, "c",
            function(c) c:kill() end,
                {description = "-   Close window", group = "󱃻  Client Actions"}
        ),

        -- awful.key({ modkey, "Control" }, "Return",
        --     function(c) c:swap(awful.client.getmaster()) end,
        --     {description = "- move to master", group = "CLIENT"}
        -- ),

        awful.key({ modkey, "Shift" }, "Down",
            function(c)
                c.minimized = true
            end,
            {description = "-   Minimize", group = "󱃻  Client Actions"}
        ),
        awful.key({ modkey, "Shift" }, "m",
            function(c)
                c.maximized = not c.maximized
                c:raise()
            end,
            {description = "-   Maximize toggle", group = "󱃻  Client Actions"}
        ),
    })
end)
-- }}}}
-- }}}

--[[  Rules  ]]--
ruled.client.connect_signal("request::rules", function()
    ruled.client.append_rules( main.rules() )
end)


--[[ Notifications ]]--
require("main.signals")


--[[ Autostart ]]--
awful.spawn.with_shell(os.getenv("HOME") .. "/Repos/awesome-rc/scripts/autostart.sh")

--[[ Start Applications ]]--
-- Tag 1 --- Home | Misc | Awesome Config ---
-- Tag 2 --- Notes | Programming | Script ---
-- Tag 3 --- Sys Settings | Configuration ---
-- Tag 4 --- Configuration | CLI Settings ---
-- Tag 5 --- Browser | Research | ChatGPT ---
-- Tag 6 --- Configuration | App Settings ---
-- Tag 7 --- File | Git | Repo Management ---
-- Tag 8 --- Media Editing | Misc Configs ---
-- Tag 9 --- Music | Streaming | Chatting ---

