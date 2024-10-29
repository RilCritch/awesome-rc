-- vim:fileencoding=utf-8:shiftwidth=4:tabstop=4:foldmethod=marker

-- -> Utilites for handling colors

local gears_color = require("gears.color")

local color_util = {}


-- Test if a color is pango compatible
function color_util.check_pango_color(check_color)
    local test_result = gears_color.ensure_pango_color(check_color, nil)
    local result

    if test_result == nil then
        result = false
    else
        result = true
    end

    return result
end

return color_util
