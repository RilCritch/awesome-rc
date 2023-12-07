-- vim:fileencoding=utf-8:shiftwidth=4:tabstop=4:foldmethod=marker
-- awesome_mode: api-level=4:screen=on

-- annoying warnings

--[[ LuaRocks ]]--
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")


--[[ Awesome Modules ]]--
local gears = require("gears") -- utilities such as color parsing and objects
local awful = require("awful") -- everything related to window management

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

local utils = {
    win = require("util.windows")
}

-- test
local x01 = utils.win.align_x(0.5, 1000)
print(x01)

--  TODO: Need to figure out what do with this for modular approach
-- initialize theme variables
beautiful.init(gears.filesystem.get_xdg_config_home() .. "awesome/themes/everforest/theme.lua")


--[[ Third Party Modules ]]--
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')

local bling_module = require("bling.module")

local rubato = require ("rubato")


--[[ Bling Modules ]]--
-- Scratchpads
local term_scratch = bling_module.scratchpad {
    command = "kitty --class spad",
    rule = { instance = "spad" },
    sticky = true,
    above = true,
    autoclose = false,
    floating = true,
    geometry = {x=360, y=90, height=900, width=1200},
    reapply = true,
    dont_focus_before_close  = true,
    -- rubato = {x = anim_x, y = anim_y}
}

--[[ Hotkeys popup ]]--
-- Popup widget that shows declared hotkeys w/ descriptions
local hotkeys = require("awful.hotkeys_popup")
local my_hotkeys_popup = hotkeys.widget.new({
    width        = 1600,
    height       = 1200,
    border_width = 3,
    group_margin = 80,
    shape    = gears.shape.rounded_rect,
})

-- Setting group colors
my_hotkeys_popup:add_group_rules("awesome",   { color = "#7FBBB301" })
my_hotkeys_popup:add_group_rules("client",    { color = "#7FBBB301" })
my_hotkeys_popup:add_group_rules("focus",     { color = "#7FBBB301" })
my_hotkeys_popup:add_group_rules("launcher",  { color = "#7FBBB301" })
my_hotkeys_popup:add_group_rules("layout",    { color = "#7FBBB301" })
my_hotkeys_popup:add_group_rules("programs",  { color = "#7FBBB301" })
my_hotkeys_popup:add_group_rules("sratchpad", { color = "#7FBBB301" })
my_hotkeys_popup:add_group_rules("tag",       { color = "#7FBBB301" })


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
        position     = "right",
        stretch      = true,
        width    = dpi(80),
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
        position     = "left",
        stretch      = true,
        width    = dpi(80),
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
--[[ Global Mouse ]]--
awful.mouse.append_global_mousebindings( binding.globalbuttons() )


--[[ Global Keys ]]--
-- use xev to see button values for system
-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "s",
        function() my_hotkeys_popup:show_help() end,
        {description="- show help", group="awesome"}
    ),
    awful.key({ modkey, "Control" }, "r",
        awesome.restart,
        {description = "- reload awesome", group = "awesome"}
    ),
    awful.key({ modkey, "Shift", "Control" }, "q",
        awesome.quit,
        {description = "- logout of awesome", group = "awesome"}
    ),

    --[[ My keybindings ]]--
    -- TODO: add more common applications
    awful.key({ modkey,         }, "b",
        function() awful.spawn(browser) end,
        { description = "- open browser", group = "programs" }
    ),
    awful.key({ modkey,         }, "Return",
        function() awful.spawn(terminal) end,
        { description = "- open a terminal", group = "programs" }
    ),
    awful.key({ modkey,         }, "v",
        function() awful.spawn(editor_cmd) end,
        { description = "- open vim", group = "programs" }
    ),
    awful.key({ modkey,         }, "r",
        function() awful.spawn(launcher) end,
        { description = "- run application launcher", group = "launcher" }
    ),

    --[[ Scratchpads ]]--
    awful.key({ modkey, "Shift" }, "t",
        function() term_scratch:toggle() end,
        { description = "- toggle terminal scratchpad", group = "sratchpad" }
    ),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "Escape",
        awful.tag.history.restore,
        {description = "- go to previous tag", group = "tag"}
    ),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.bydirection("down")
            -- bling.module.flash_focus.flashfocus(client.focus)
        end,
        {description = "- move client focus down", group = "focus"}
    ),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.bydirection("up")
            -- bling.module.flash_focus.flashfocus(client.focus)
        end,
        {description = "- move client focus up", group = "focus"}
    ),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.bydirection("left")
            -- bling.module.flash_focus.flashfocus(client.focus)
        end,
        {description = "- move client focus left", group = "focus"}
    ),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.bydirection("right")
            -- bling.module.flash_focus.flashfocus(client.focus)
        end,
        {description = "- move client focus right", group = "focus"}
    ),
    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
            c:activate { raise = true, context = "key.unminimize" }
            end
        end,
        {description = "- restore minimized", group = "client"}
    ),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift" }, "j",
        function() awful.client.swap.bydirection("down") end,
        {description = "- swap with client below", group = "client"}
    ),
    awful.key({ modkey, "Shift" }, "k",
        function() awful.client.swap.bydirection("up") end,
        {description = "- swap with client above", group = "client"}
    ),
    awful.key({ modkey, "Shift" }, "h",
        function() awful.client.swap.bydirection("left") end,
        {description = "- swap with client on left", group = "client"}
    ),
    awful.key({ modkey, "Shift" }, "l",
        function() awful.client.swap.bydirection("right") end,
        {description = "- swap with client on right", group = "client"}
    ),

    awful.key({ modkey }, "e",
        function() awful.tag.incmwfact(0.05)  end,
        {description = "- increase master width factor", group = "layout"}
    ),
    awful.key({ modkey, "Shift" }, "e",
        function () awful.tag.incmwfact(-0.05) end,
        {description = "- decrease master width factor", group = "layout"}
    ),

    awful.key({ modkey }, "q",
        function () awful.tag.incnmaster( 1, nil, true) end,
        {description = "- increase the number of master clients", group = "layout"}
    ),
    awful.key({ modkey, "Shift" }, "q",
        function () awful.tag.incnmaster(-1, nil, true) end,
        {description = "- decrease the number of master clients", group = "layout"}
    ),

    awful.key({ modkey }, "p",
        function () awful.tag.incncol(1, nil, true) end,
        {description = "- increase the number of columns", group = "layout"}
    ),
    awful.key({ modkey, "Shift" }, "p",
        function () awful.tag.incncol(-1, nil, true) end,
        {description = "- decrease the number of columns", group = "layout"}
    ),

    awful.key({ modkey }, "space",
        function () awful.layout.inc(1) end,
        {description = "- select next", group = "layout"}
    ),
    awful.key({ modkey, "Shift"}, "space",
        function () awful.layout.inc(-1) end,
        {description = "- select previous", group = "layout"}
    ),
})


awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "- view only tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "- toggle tag",
        group       = "tag",
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
        description = "- move focused client to tag",
        group       = "tag",
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


--[[ Client Mouse ]]--
client.connect_signal("request::default_mousebindings", function() ---@diagnostic disable-line: undefined-global
    awful.mouse.append_client_mousebindings( binding.clientbuttons() )
end)


--[[ Client Keys ]]--
client.connect_signal("request::default_keybindings", function() ---@diagnostic disable-line: undefined-global
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey }, "f",
            function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "- toggle fullscreen", group = "client"}
        ),
        -- TODO: change this
        awful.key({ modkey, "Control" }, "space",
            awful.client.floating.toggle,
            {description = "- toggle floating", group = "client"}
        ),

        awful.key({ modkey, "Shift" }, "c",
            function(c) c:kill() end,
                {description = "- close window", group = "client"}
        ),

        awful.key({ modkey, "Control" }, "Return",
            function(c) c:swap(awful.client.getmaster()) end,
            {description = "- move to master", group = "client"}
        ),

        awful.key({ modkey }, "n",
            function(c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end ,
            {description = "- minimize", group = "client"}
        ),
        awful.key({ modkey }, "m",
            function(c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "- (un)maximize", group = "client"}
        ),
    })
end)
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
-- Tag 1 -- AwesomeWM
-- Tag 2 -- Configuration
-- Tag 3 -- Configuration
-- Tag 4 -- Notes
-- Tag 5 -- Browser
-- awful.spawn.once("firefox https://chat.openai.com/", { tag = screen[1].tags[5] })
-- awful.spawn.once("firefox", { tag = screen[1].tags[5] })
-- Tag 6 -- Terminal
-- awful.spawn.once("kitty",   { tag = screen[1].tags[6] })
-- Tag 7
-- awful.spawn.once("firefox https://www.youtube.com/", { tag = screen[1].tags[7] })
-- Tag 8
-- Tag 9
-- awful.spawn.once("discord", { tag = screen[1].tags[9] })
