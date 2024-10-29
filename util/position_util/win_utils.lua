--[[ Utility functions for client/window manipulation ]]--

local awful = require("awful")
local value_tests = require("util.math_util.value_tests")

local win_utils = {}

--[[ Retrieve Screen / Window Information ]]--

-- Retrieve focused screen
function win_utils.getScreen()
    return awful.screen.focused{}
end

-- Get screen geometry -> {x, y, width, height}
function win_utils.get_geometry()
    local screen_geometry = win_utils.getScreen().geometry
    return screen_geometry
end

-- Get screen work area geometry
function win_utils.get_workarea_geometry()
    local workarea_geometry = win_utils.getScreen().workarea
    return workarea_geometry
end

-- Get screen dimensions
function win_utils.getScreenWidth()
    return win_utils.get_geometry().width
end

function win_utils.getScreenHeight()
    return win_utils.get_geometry().height
end

-- Get workarea dimensions
function win_utils.getWorkareaWidth()
    return win_utils.get_workarea_geometry().width
end

function win_utils.getWorkareaHeight()
    return win_utils.get_workarea_geometry().height
end

-- Retrieve other screen data
function win_utils.getScreenDpi()
    return win_utils.getScreen().dpi
end

--[[ align x-axis:
       - alignment: float [0.0-1.0] 0.0:left; 0.5:center; 1.0:right;
]]--   - width:     int   [positive; < screen.width]

function win_utils.align_x(alignment, width)
    alignment = alignment or 0.5 -- alignment defaults to 0.5
    if not value_tests.isPercent(alignment) then -- even if incorrect value
        alignment = 0.5
    end

    local screen_geometry = win_utils.get_geometry()
    local s_width = screen_geometry.width

    if width == nil or width > s_width or width <= 0 then -- width is required
        error("Width is required and must be width <= the screen width and larger than 0")
    end

    local x = (s_width - width) * alignment

    return math.floor(x)
end

--[[ align y-axis:
       - alignment: float [0.0-1.0] 0.0:left; 0.5:center; 1.0:right;
]]--   - height:    int   [positive; < screen.height]
function win_utils.align_y(alignment, height)
    alignment = alignment or 0.5
    if not value_tests.isPercent(alignment) then
        alignment = 0.5
    end

    local screen_geometry = win_utils.get_geometry()
    local s_height = screen_geometry.height

    if height == nil or height > s_height or height <= 0 then
        error("Height is required and must be height <= the screen height and larger than 0")
    end

    local y = (s_height - height) * alignment

    return math.floor(y)
end


return win_utils
