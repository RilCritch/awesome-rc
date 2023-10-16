-- vim:fileencoding=utf-8:shiftwidth=4:tabstop=4:foldmethod=marker
-- awesome_mode: api-level=4:screen=on

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
local menubar = require("menubar") -- XDG (application) menu implementation

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi


--[[ Custom Modules ]]--
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


--[[ Error Handling ]]--
require("main.errorhandling") -- ./main/errorhandling.lua


--[[ Hotkeys popup ]]--
-- Popup widget that shows declared hotkeys w/ descriptions
local hotkeys = require("awful.hotkeys_popup")
local my_hotkeys_popup = hotkeys.widget.new({
    width        = 1800,
    height       = 1200,
    group_margin = 36,
})

-- Setting group colors
my_hotkeys_popup:add_group_rules("awesome",  { color = "#3F5865" })
my_hotkeys_popup:add_group_rules("client",   { color = "#48584E" })
my_hotkeys_popup:add_group_rules("launcher", { color = "#55544A" })
my_hotkeys_popup:add_group_rules("layout",   { color = "#48584E" })
my_hotkeys_popup:add_group_rules("screen",   { color = "#55544A" })
my_hotkeys_popup:add_group_rules("tag",      { color = "#48584E" })


--[[ Variables ]]--
--  TODO: Need to figure out what do with this for modular approach
-- initialize theme variables
beautiful.init(gears.filesystem.get_xdg_config_home() .. "awesome/themes/everforest/theme.lua")

-- Termporarily include these until I move keydindings to separate file
local terminal = RC.vars.terminal
local editor_cmd = RC.vars.editor_cmd
local modkey = RC.vars.modkey


--[[ Tag Layouts ]]--
RC.layouts = main.layouts()

-- Set global layouts
tag.connect_signal("request::default_layouts", function() -- maybe move this part to external
    awful.layout.append_default_layouts(
        RC.layouts -- ./main/layouts.lua
    )
end)


--[[ Wallpaper ]]--
-- NOTE: <s> is the screen on which to draw the wallpaper
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
-- Keyboard layout indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- NOTE: <s> signifies the screen the widgets will be added
screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    -- basic method:
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    -- more indepth method:
    -- local l = awful.layout.suit
    -- local names =   { "1",    "2",    "3",    "4",    "5",    "6",    "7",    "8",    "9"    }
    -- -- or local names = { "main", "note", "conf", "cust", "brow", "term", "strm", "tune", "chat" }
    -- local layouts = { l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile }
    -- awful.tag(names, s, layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end)
        }
    }

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                                            if client.focus then
                                                client.focus:move_to_tag(t)
                                            end
                                        end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                                            if client.focus then
                                                client.focus:toggle_tag(t)
                                            end
                                        end),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        },
        widget_template = {
            widget = wibox.container.margin,
            left   = dpi(2),
            right  = dpi(0),
            top    = dpi(2),
            bottom = dpi(2),
            {
                id           = "background_role",
                widget       = wibox.container.background,
                {
                    widget = wibox.container.margin,
                    left   = dpi(12),
                    right  = dpi(12),
                    {
                        layout = wibox.layout.fixed.horizontal,
                        {
                            id = "text_role",
                            widget = wibox.widget.textbox,
                        },
                    },
                },
            },
        }
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = {
            -- NOTE: <c> signifies the client (aka window) that mouse is hovering over
            awful.button({ }, 1, function (c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
        }
    }

    s.mywibox = awful.wibar {
        position = "top",
        margins  = {
            top    = dpi(3),
            bottom = dpi(0),
            right  = dpi(3),
            left   = dpi(3),
        },
        height = dpi(38),
        screen   = s,
        widget   = {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                s.mytaglist,
                s.mypromptbox,
            },
            s.mytasklist, -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                -- mykeyboardlayout,
                wibox.widget.systray(),
                mytextclock,
                s.mylayoutbox,
            },
        }
    }

    -- s.mywibox = awful.wibar {
    --     position = "top",
    --     -- margins = 5,
    --     screen   = s,
    --     widget   = {
    --         layout = wibox.layout.align.horizontal,
    --     }
    -- }
end)


--[[ Global Mouse ]]--
awful.mouse.append_global_mousebindings( binding.globalbuttons() )


--[[ Global Keys ]]--
-- use xev to see button values for system
-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "s",
              function ()
                  my_hotkeys_popup:show_help()
              end,
              {description="show help", group="awesome"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
              end,
              {description = "restore minimized", group = "client"}),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
})


awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
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
        description = "toggle tag",
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
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
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
    awful.key {
        modifiers   = { modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})


--[[ Client Mouse ]]--
client.connect_signal("request::default_mousebindings", function() ---@diagnostic disable-line: undefined-global
    awful.mouse.append_client_mousebindings( binding.clientbuttons() )
end)


--[[ Client Keys ]]--
client.connect_signal("request::default_keybindings", function() ---@diagnostic disable-line: undefined-global
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
                {description = "close", group = "client"}),
        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
                {description = "toggle floating", group = "client"}),
        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                {description = "move to master", group = "client"}),
        awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
                {description = "move to screen", group = "client"}),
        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                {description = "toggle keep on top", group = "client"}),
        awful.key({ modkey,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end ,
            {description = "minimize", group = "client"}),
        awful.key({ modkey,           }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "(un)maximize", group = "client"}),
        awful.key({ modkey, "Control" }, "m",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end ,
            {description = "(un)maximize vertically", group = "client"}),
        awful.key({ modkey, "Shift"   }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end ,
            {description = "(un)maximize horizontally", group = "client"}),
    })
end)


--[[  Rules  ]]--
ruled.client.connect_signal("request::rules", function()
    ruled.client.append_rules( main.rules() )
end)


--[[ Notifications ]]--
require("main.signals")


--[[ Autostart ]]
awful.spawn.with_shell("~/.config/awesome/scripts/autostart.sh")
