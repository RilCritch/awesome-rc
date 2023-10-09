-- vim:fileencoding=utf-8:shiftwidth=4:tabstop=4:foldmethod=marker
-- awesome_mode: api-level=4:screen=on

-- LuaRocks {{{

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- LuaRocks end }}}

-- Imports {{{

-- Standard awesome library
local gears = require("gears") -- utilities such as color parsing and objects
local awful = require("awful") -- everything related to window management

-- Handling of focus when focused window disappears
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox") -- awesome's generic widget framework

-- Theme handling library
local beautiful = require("beautiful") -- awesome theme module

-- Notification library
local naughty = require("naughty") -- notification handling

-- Declarative object management
local ruled = require("ruled") -- define declarative rules on various rules
local menubar = require("menubar") -- XDG (application) menu implementation

-- Imports end }}}

-- Hotkeys popup {{{

-- Popup widget that shows declared hotkeys w/ descriptions
local hotkeys = require("awful.hotkeys_popup")

local my_hotkeys_popup = hotkeys.widget.new({
    width        = 1800,
    height       = 1200,
    group_margin = 36,
})

-- Setting group colors
my_hotkeys_popup:add_group_rules("awesome",  { color = "#83A598" })
my_hotkeys_popup:add_group_rules("client",   { color = "#D5C4A1" })
my_hotkeys_popup:add_group_rules("launcher", { color = "#A89984" })
my_hotkeys_popup:add_group_rules("layout",   { color = "#D5C4A1" })
my_hotkeys_popup:add_group_rules("screen",   { color = "#A89984" })
my_hotkeys_popup:add_group_rules("tag",      { color = "#D5C4A1" })

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
-- require("awful.hotkeys_popup.keys")

-- }}}

-- Error Handling {{{

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)

-- For other error handling tips check out these links:
-- https://awesomewm.org/apidoc/documentation/05-awesomerc.md.html#Error_handling
-- https://awesomewm.org/apidoc/documentation/01-readme.md.html#Troubleshooting

-- Error Handling end }}}

-- Variable Definitions {{{

-- Themes define colours, icons, font and wallpapers.
-- default:
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
-- user:
beautiful.init(gears.filesystem.get_xdg_config_home() .. "awesome/themes/gruvbox/theme.lua")

-- This is used later as the default terminal and editor to run.
-- terminal = "xterm" -- default
terminal = "kitty" -- my preferred terminal
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- Typical key representation:
-- mod1: Alt; mod2: Num_Lock; mod3: ISO_Level5_Shift; mod4: Super; mod5: ISO_Level3_Shift
modkey = "Mod4" -- super key (AKA logo key)

-- Variable Definitions end }}}

-- Menu {{{

-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() my_hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Menu end }}}

-- Tag Layout {{{

-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top,
        awful.layout.suit.fair,
        awful.layout.suit.fair.horizontal,
        awful.layout.suit.max,
        awful.layout.suit.max.fullscreen,
        awful.layout.suit.magnifier,
        awful.layout.suit.floating,
        -- awful.layout.suit.corner.nw,
        -- awful.layout.suit.corner.ne,
        -- awful.layout.suit.corner.sw,
        -- awful.layout.suit.corner.se,
        -- awful.layout.suit.spiral,
        -- awful.layout.suit.spiral.dwindle,
    })
end)

-- Tag Layout end }}}

-- Wallpaper {{{

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

-- Wallpaper end }}}

-- Tags ~ Workspaces {{{

awful.screen.connect_for_each_screen(function(s)
    -- Adding tags template:
    -- the values set in the template are the default value
    -- awful.tag.add("<tag name>", {
    --     icon                 = nil, string as path to icon, cairo, or librsvg, nil means no icon
    --     layout               = awful.layout.layouts[1], - the default layout for the tag
    --     layouts              = awful.layout.layouts, - change the list of layouts available on the tag
    --     master_width_factor  = "beautiful.master_width_factor" - tag specific with factor; diff for each layout
    --     master_fill_policy   = "beautiful.master_fill_policy", - can set to master_width_factor or expand
    --                                                            - limist width of clients when they will be too big
    --     master_count         = beautiful.master_count, - min: 1; number of master windows
    --     column_count         = beautiful.column_count, - min: 1; number of columns ~ good for ultrawide?
    --     gap_single_client    = beautiful.gap_single_client, - add gap when a single client is in the tag?
    --     gap                  = beautiful.useless_gap, - margin for each client in this tab
    --     screen               = awful.screen.focused(), - the screen the tag associated with
    --     index                = list.len + 1, - the tag's index ~ set automatically as they are added
    --     activated            = <true> or false, - True if tag is active and can be used
    --     selected             = true or <false>, - is tag selected? - one tag must have this as true
    --     volatile             = true or <false>, - remove tag when all clients removed; useful for throw away tags
    -- })

    -- variables
    local l = awful.layout.suit
    -- tag index -   t[1]    t[2]    t[3]    t[4]    t[5]    t[6]    t[7]    t[8]    t[9]
    local names =   { "1",    "2",    "3",    "4",    "5",    "6",    "7",    "8",    "9" }
    local layouts = { l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile }

    -- tags
    awful.tag.add(names[1], {
        layout          = layouts[1],
        screen          = s,
        selected        = true, -- this tag is selected on startup
    })
    awful.tag.add(names[2], {
        layout          = layouts[2],
        screen          = s,
    })
    awful.tag.add(names[3], {
        layout          = layouts[3],
        screen          = s,
    })
    awful.tag.add(names[4], {
        layout          = layouts[4],
        screen          = s,
    })
    awful.tag.add(names[5], {
        layout          = layouts[5],
        screen          = s,
    })
    awful.tag.add(names[6], {
        layout          = layouts[6],
        screen          = s,
    })
    awful.tag.add(names[7], {
        layout          = layouts[7],
        screen          = s,
    })
    awful.tag.add(names[8], {
        layout          = layouts[8],
        screen          = s,
    })
    awful.tag.add(names[9], {
        layout          = layouts[9],
        screen          = s,
    })
end)

-- }}}

-- Wibar {{{

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
            awful.button({ }, 5, function () awful.layout.inc( 1) end),
        }
    }

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            -- NOTE: <t> signifies the hovered tag in the taglist
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

    -- Create the wibox
    s.mywibox = awful.wibar {
        position = "top",
        screen   = s,
        widget   = {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                mylauncher,
                s.mytaglist,
                s.mypromptbox,
            },
            s.mytasklist, -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                mykeyboardlayout,
                wibox.widget.systray(),
                mytextclock,
                s.mylayoutbox,
            },
        }
    }
end)

-- Wibar end }}}

-- Mouse Bindings {{{

-- mouse button number identifiers:
-- use xev command to see values
-- 1: left click; 2: middle click; 3: right click
-- 4: Scroll up; 5: Scroll down;
-- 6: Side scroll down; 7: Side scroll up
-- 8: Close side button; 9: Far side button
awful.mouse.append_global_mousebindings({
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})

-- Mouse Bindings end }}}

-- Key bindings {{{

-- use xev to see button values for system
-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "s",
              function ()
                  my_hotkeys_popup:show_help()
              end,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),
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

-- client keys ~ only work when a client/window is focused
client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

client.connect_signal("request::default_keybindings", function()
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

-- Keybindings end }}}

-- Rules {{{

-- use xprop to find class name for a client
--      - look for WM_CLASS(STRING)
--      - str1: instance name; str2: class name
--      - NOTE: use the second str, e.g. class name
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }

    -- Floating clients.
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name    = {
                "Event Tester",  -- xev.
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }

    -- Add titlebars to normal clients and dialogs
    -- ruled.client.append_rule {
    --     id         = "titlebars",
    --     rule_any   = { type = { "normal", "dialog" } },
    --     properties = { titlebars_enabled = false     }
    -- }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- ruled.client.append_rule {
    --     rule       = { class = "Firefox"     },
    --     properties = { screen = 1, tag = "2" }
    -- }
end)

-- Rules end }}}

-- Titlebars {{{

-- Add a titlebar if titlebars_enabled is set to true in the rules.
-- client.connect_signal("request::titlebars", function(c)
--     -- buttons for the titlebar
--     local buttons = {
--         awful.button({ }, 1, function()
--             c:activate { context = "titlebar", action = "mouse_move"  }
--         end),
--         awful.button({ }, 3, function()
--             c:activate { context = "titlebar", action = "mouse_resize"}
--         end),
--     }
--
--     awful.titlebar(c).widget = {
--         { -- Left
--             awful.titlebar.widget.iconwidget(c),
--             buttons = buttons,
--             layout  = wibox.layout.fixed.horizontal
--         },
--         { -- Middle
--             { -- Title
--                 halign = "center",
--                 widget = awful.titlebar.widget.titlewidget(c)
--             },
--             buttons = buttons,
--             layout  = wibox.layout.flex.horizontal
--         },
--         { -- Right
--             awful.titlebar.widget.floatingbutton (c),
--             awful.titlebar.widget.maximizedbutton(c),
--             awful.titlebar.widget.stickybutton   (c),
--             awful.titlebar.widget.ontopbutton    (c),
--             awful.titlebar.widget.closebutton    (c),
--             layout = wibox.layout.fixed.horizontal()
--         },
--         layout = wibox.layout.align.horizontal
--     }
-- end)

-- Titlebars end }}}

-- Notifications {{{

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)

-- Notifications end }}}

-- Sloppy Focus {{{

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)

-- Sloppy Focus end }}}
