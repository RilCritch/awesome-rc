-----------------------------
--[[ Layouts for Clients ]]--
-----------------------------

-- Imports
local awful = require("awful")
local lain = require("lain.layout")
local bling = require("bling.layout")

-- Metatable
local _M = {}

-- Defining layouts
function _M.get ()
    local layouts = {
        -- ultrawide
        lain.centerwork, -- master_width_policy
        -- bling.vertical, -- master_width_policy; master_count

        -- corner
        -- awful.layout.suit.corner.ne,

        -- stack
        -- awful.layout.suit.tile.left,
        -- awful.layout.suit.tile.bottom,

        -- max
        -- awful.layout.suit.max,
        -- awful.layout.suit.max.fullscreen,

        -- floating
        -- awful.layout.suit.floating,
    }

    return layouts
end

return setmetatable({}, {
    __call = function(_,...)
        return _M.get(...) ---@diagnostic disable-line: redundant-parameter
    end
})

-- vim:fileencoding=utf-8:shiftwidth=4:tabstop=4:foldmethod=marker
