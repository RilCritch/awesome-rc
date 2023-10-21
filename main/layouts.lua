-----------------------------
--[[ Layouts for Clients ]]--
-----------------------------

-- Imports
local awful = require("awful")
local bling = require("bling")

-- Metatable
local _M = {}

-- Defining layouts
function _M.get ()
    local layouts = {
        -- bling layouts
        bling.layout.centered,
        bling.layout.mstab,
        bling.layout.equalarea,

        -- max layouts
        awful.layout.suit.max,
        awful.layout.suit.magnifier,

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
