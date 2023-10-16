----------------------
--[[ Client Rules ]]--
----------------------

-- Imports
local awful = require("awful")
local ruled = require("ruled")
local gears = require("gears")
-- local beautiful = require("beautiful")

-- Metatable
local _M = {}


-- use xprop to find class name for a client
--      - look for WM_CLASS(STRING)
--      - str1: instance name; str2: class name
--      - NOTE: use the second str, e.g. class name

-- Rules to apply to new clients.
function _M.get()
    local rules = {
        -- all clients will match this rule.
        {
            id         = "global",
            rule       = { },
            properties = {
                focus     = awful.client.focus.filter,
                raise     = true,
                screen    = awful.screen.preferred,
                placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                shape     = gears.shape.rounded_rect
            }
        },

        -- floating clients.
        {
            id       = "floating",
            rule_any = {
                instance = { "copyq", "pinentry" },
                class    = {
                    "arandr", "blueman-manager", "gpick", "kruler", "sxiv",
                    "tor browser", "wpa_gui", "veromix", "xtightvncviewer"
                },
                -- note that the name property shown in xprop might be set slightly after creation of the client
                -- and the name shown there might not match defined rules here.
                name    = {
                    "event tester",  -- xev.
                },
                role    = {
                    "alarmwindow",    -- thunderbird's calendar.
                    "configmanager",  -- thunderbird's about:config.
                    "pop-up",         -- e.g. google chrome's (detached) developer tools.
                }
            },
            properties = { 
                floating = true,
                shape    = gears.shape.rounded_rect,
            }
        },

        -- set firefox to always map on the tag named "2" on screen 1.
        -- {
        --     rule       = { class = "firefox"     },
        --     properties = { screen = 1, tag = "2" }
        -- },
    }

    return rules
end

return setmetatable({}, {
    __call = function(_,...)
        return _M.get(...) ---@diagnostic disable-line: redundant-parameter
    end
})

-- vim:fileencoding=utf-8:shiftwidth=4:tabstop=4:foldmethod=marker
