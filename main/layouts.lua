-----------------------------
--[[ Layouts for Clients ]]--
-----------------------------

-- Imports
local awful = require("awful")
local lain = require("lib.lain.layout")
local bling = require("lib.bling.layout")

-- Metatable
local _M = {}

-- Defining layouts
function _M.get ()
    local layouts = {
        -- Center
        lain.centerwork, -- center stack left
        bling.centered, -- center stack right

        -- Stacks
        awful.layout.suit.tile.right,
        awful.layout.suit.tile.left,

        -- Special Stacks
        bling.vertical,
        bling.equalarea,

        -- Others
        awful.layout.suit.floating,


        -- Testing
    }

    return layouts
end

return setmetatable({}, {
    __call = function(_,...)
        return _M.get(...) ---@diagnostic disable-line: redundant-parameter
    end
})

-- vim:fileencoding=utf-8:shiftwidth=4:tabstop=4:foldmethod=marker
