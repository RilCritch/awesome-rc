-----------------------------
--[[ Layouts for Clients ]]--
-----------------------------

-- Imports
local awful = require("awful")
local lain = require("lain")

-- Metatable
local _M = {}

-- Defining layouts
function _M.get ()
    local layouts = {
        -- center
        lain.layout.centerwork,

        -- corner
        awful.layout.suit.corner.ne,

        -- master-stack
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,

        -- max
        awful.layout.suit.max,
        awful.layout.suit.max.fullscreen,

        -- floating
        awful.layout.suit.floating,
    }

    return layouts
end

return setmetatable({}, {
    __call = function(_,...)
        return _M.get(...) ---@diagnostic disable-line: redundant-parameter
    end
})

-- vim:fileencoding=utf-8:shiftwidth=4:tabstop=4:foldmethod=marker
