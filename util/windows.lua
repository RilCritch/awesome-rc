--[[ Utility functions for client/window manipulation ]]--

local win_utils = {}

local screen_w=screen.primary.geometry.width
local screen_h=screen.primary.geometry.height


--[[ checker functions ]]--

--[[ Checks if value is between 0.00 - 1.00
       - value:   expected to be a float
       - returns: false if not a percent value
]]--              true  if a percent value
local function isPercent(value)
    if value > 0.0 and value < 1.0 then
        return true
    else
        return false
    end
end


--[[ centering floating windows ]]--

--[[ align x-axis:
       - alignment: float [0.0-1.0] 0.0:left; 0.5:center; 1.0:right;
]]--   - width:     int   [positive; < screen.width]

function win_utils.align_x(alignment, width)
    alignment = alignment or 0.5 -- alignment defaults to 0.5
    if not isPercent(alignment) then -- even if incorrect value
        alignment = 0.5
    end

    if width == nil or width <= 150 or width >= screen_w then -- width is required
        error("Width is required and 150 <= width <= screen width")
    end

    local x = (screen_w - width) * alignment

    return math.floor(x)
end

--[[ align y-axis:
       - alignment: float [0.0-1.0] 0.0:left; 0.5:center; 1.0:right;
]]--   - height:    int   [positive; < screen.height]
function win_utils.align_y(alignment, height)
end

return win_utils
