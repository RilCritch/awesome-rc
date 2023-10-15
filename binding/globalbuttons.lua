--------------------------------
--[[ Global Button Bindings ]]--
--------------------------------

--[[ Imports ]]--
local awful = require("awful")

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
        awful.button({ }, 4, awful.tag.viewprev),
        awful.button({ }, 5, awful.tag.viewnext),
    }

    return buttons
end

--[[ Return Metatable ]]--
return setmetatable({}, {
    __call = function(_,...)
        return _M.get(...) ---@diagnostic disable-line: redundant-parameter
    end
})

-- vim:fileencoding=utf-8:shiftwidth=4:tabstop=4:foldmethod=marker
