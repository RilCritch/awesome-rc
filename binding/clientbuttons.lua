--[[ Imports ]]--
local awful = require("awful")

local modkey = RC.vars.modkey

--[[ Metatable ]]--
local _M = {}

--[[ Buttons ]]--
-- mouse button number identifiers:
-- use xev command to see values
-- 1: left click; 2: middle click; 3: right click
-- 4: Scroll up; 5: Scroll down;
-- 6: Side scroll down; 7: Side scroll up
-- 8: Close side button; 9: Far side button
function _M.get ()
    local buttons = {
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    }

    return buttons
end

return setmetatable({}, {
    __call = function(_,...)
        return _M.get(...) ---@diagnostic disable-line: redundant-parameter
    end
})

-- vim:fileencoding=utf-8:shiftwidth=4:tabstop=4:foldmethod=marker
