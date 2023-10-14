-------------------------
-- Layouts for Clients --
-------------------------

-- Imports
local awful = require("awful")

-- Simple table return
return {
    -- tile layouts
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.right,
    -- awful.layout.suit.tile.top,

    -- fair layouts
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.fair,

    -- corner layouts
    awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,

    -- max layouts
    awful.layout.suit.max,
    awful.layout.suit.magnifier,
    -- awful.layout.suit.max.fullscreen,

    -- spiral layouts
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,

    -- floating
    -- awful.layout.suit.floating,
}

--[[ Way that https://epsi-rns.github.io/desktop/2019/06/16/awesome-modularized-structure.html recommends {{{
-- Metatable
local _M = {}

-- Defining layouts
function _M.get ()
    local layouts = {
        -- tile layouts
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        -- awful.layout.suit.tile.right,
        -- awful.layout.suit.tile.top,

        -- fair layouts
        awful.layout.suit.fair.horizontal,
        -- awful.layout.suit.fair,

        -- corner layouts
        awful.layout.suit.corner.ne,
        -- awful.layout.suit.corner.nw,
        -- awful.layout.suit.corner.sw,
        -- awful.layout.suit.corner.se,

        -- max layouts
        awful.layout.suit.max,
        awful.layout.suit.magnifier,
        -- awful.layout.suit.max.fullscreen,

        -- spiral layouts
        -- awful.layout.suit.spiral,
        -- awful.layout.suit.spiral.dwindle,

        -- floating
        -- awful.layout.suit.floating,
    }

    return layouts
end

-- Returning 
return setmetatable({}, { __call = function(_,...) return _M.get(...) end })
--]]
-- }}}

-- vim:fileencoding=utf-8:shiftwidth=4:tabstop=4:foldmethod=marker
