-- Dependencies
local win_utils = require("util.position_util.win_utils")
local value_tests = require("util.math_util.value_tests")

--[[ --| Positioniting Utility Module |-- ]]--
local position_util = {}

--[[ Function Declarations ]]-- {{{

-- Local Utility Functions
local geometryOptions
local axisOptions

-- Module Functions
-- local geometryValueValidation
-- local axisValue
-- local calculateGeometry
-- local test
-- }}}

--[[ Assign Funcitons to Module Table ]]--

-- position_util.geometryValueValidation = geometryValueValidation
-- position_util.axisValue = axisValue
-- position_util.calculateGeometry = calculateGeometry
-- position_util.test = test


---[[ Local Variables ]]--- {{{

-- Placement option values
local placement_options = {
    x = {
            right  = 0.0,
            center = 0.5,
            left   = 1.0
        },
    y = {
            top    = 0.0,
            center = 0.5,
            bottom = 1.0
        }
}

-- Geometry region options
local geometry_options = {
    workarea = win_utils.get_workarea_geometry(), -- only accounts for the area where clients can exist
    screen   = win_utils.get_geometry(),          -- accounts for the entire screen allowing you to go over any element on the screen
}
-- }}}

---[[ Local Utility Functions ]]--- {{{

-- Argument Parsing

geometryOptions = function(choice)
    local geometry = geometry_options[choice] or nil
    return geometry
end

axisOptions = function(axis_presets, choice)
    local axis_percent

    if value_tests.isNumber(choice) and value_tests.isPercent(choice) then
        axis_percent = choice
    else
        axis_percent = axis_presets[choice] or nil
    end

    return axis_percent
end
-- }}}

---[[ Module Functions ]]---

--[[ Axis Value Calculation -- {{{
      > Calculate the value of the an axis based on the axis_percentage, window_size, and screen_size
      > NOTE: It's preffered to this function through the geometryValueValidation or calculateGeometry as these methods check the values
      > Before running this method stand alone ensure the values are valid, so the calculation is correct
--    > ARGUMENTS:
--       > screen_size: screen.geometry size for the axis you are testing when you call the function
--          > NOTE: VALID VALUES: Integers representing either screen width or height. Use win_utils for retrieve this
--          > VALID VALUES: Integers in the format that awesomewm uses for geometry
--          > screen width or
--          > screen height
--       > axis_percentage: the desired position of the axis that is being tested in percentage form
--          > NOTE: VALID VALUES: Percentage representing window position on x or y axis => 0.0 -> 1.0
--          > x-axis position or
--          > y-axis position
--       > window_size: the desired size of the window in the axis that is being tested
--          > NOTE: VALID VALUES: Integers in the format that awesomewm uses for geometry for window width or height
--          > WARN: This value must not exceed or be below the screen_size
--          > window width or
--          > window height
--
--    > RETURN:
--       > value os axis calculated to fulfill the desired position
--]] -- }}}
function position_util.axisValue(screen_size, axis_percentage, window_size)
    local size_diff = screen_size - window_size
    local axis_value = ( size_diff * axis_percentage )
    axis_value = math.max(0, math.min(axis_value, screen_size - window_size))
    return axis_value
end

--[[ Value validation -- {{{
--    > Validation of geometry arguments to ensure calculations can be made successfully
--    > Once the values are validated the axis value is calculated to ensure the desired position is achieved  
--    > NOTE: its important you send values that are on the same axis. For example, screen_width, x-axis position, and window_width
--    > ARGUMENTS:
--       > screen_size: screen.geometry size for the axis you are testing when you call the function
--          > NOTE: VALID VALUES: Integers representing either screen width or height. Use win_utils for retrieve this
--          > VALID VALUES: Integers in the format that awesomewm uses for geometry
--          > screen width or
--          > screen height
--       > axis_percentage: the desired position of the axis that is being tested in percentage form
--          > NOTE: VALID VALUES: Percentage representing window position on x or y axis => 0.0 -> 1.0
--          > x-axis position or
--          > y-axis position
--       > window_size: the desired size of the window in the axis that is being tested
--          > NOTE: VALID VALUES: Integers in the format that awesomewm uses for geometry for window width or height
--          > WARN: This value must not exceed or be below the screen_size
--          > window width or
--          > window height
--
--    > RETURN: (Table with axis and size pair)
--       > This table is the axis and window size pare that go together, i.e. x-axis and width
--       > Window geometry axis pair table:
--          > { axis_value = physical axis value, window size = either width or height }
--]] -- }}}
function position_util.geometryValueValidation(screen_size, axis_percentage, window_size)
    -- Validate argument values
    if not value_tests.isNumber(screen_size) then
        return { false, { error = "Invalid argument: screen_size", hint = "Screen size must be a valid number for width or height" } }
    end

    if not value_tests.isPercent(axis_percentage) then
        return { false, { error = "Invalid argument: axis_percentage", hint = "The axis percentage must be between 0.0 and 1.0 representing the position" } }
    end

    if window_size > screen_size or window_size < 0 then
        return { false, { error = "Invalid argument: window_size", hint = "The window size must be positive and smaller than the screen_size" } }
    end

    -- Calculate the axis value
    local axis_value = position_util.axisValue(screen_size, axis_percentage, window_size)

    -- Ensure the axis_value and window_size do not go off the screen
    local window_end_position = axis_value + window_size
    if window_end_position > screen_size then
        return { false, { error = "Logic error: geometry calculation", hint = "The axis_value and window size combine to be larger than screen_size"} }
    end

    -- Return the axis and window size table
    return { axis_value, window_size }

end

--[[ Calculate Geometry -- {{{
--    > Calculate the geometry for a window in awesome window manager
--    > ARGUMENTS: (args{}) optional
--       > geometry_region: 'screen' or 'workarea' -> default: 'workarea'
--
--       > x_align: alignment of the window on the x-axis -> default: 'center' or 0.5
--          > pre-defined locations: 'left', 'center', 'right'
--          > percentage: 0.0 -> 1.0 defining the location
--       > y_align: alignment of the window on the y-axis -> default: 'center' or 0.5
--          > pre-defined locations: 'top', 'center', 'bottom'
--          > percentage: 0.0 -> 1.0 defining the location
--
--       > width: width of the window as an integer -> default: 640
--       > height: height of the window as an integer -> default: 480
--
--    > RETURN: (table)
--       > Using the specified values this function calculates the geometry of a window that is aligned how you want it to be.
--       > Error messages will inform you if there were invalid arguments or failures in the calculation of the geometry.
--       > Geometry Table:
--          > { x = x-axis location, y = y-axis location, width = width value, height = height value }
--]] -- }}}
function position_util.calculateGeometry(args)
    -- Screen Geometry ~ default: "workarea"
    local geometry_region = args.geometry_region or "workarea"
    local screen_geometry = geometryOptions(geometry_region)
    if screen_geometry == nil then
        return { false, { error = "Invalid arg: geometry_region", hint = "Select either 'workarea' or 'screen'" } }
    end

    -- Axis Positions ~ default: "center"
    -- args
    local x_align = args.x_align or "center" -- x alignment ~ default is center (0.5)
    local y_align = args.y_align or "center" -- y alignment ~ default is center (0.5)

    -- parsing axis percentage from arguments
    local x_perc = axisOptions(placement_options.x, x_align)
    local y_perc = axisOptions(placement_options.y, y_align)

    -- ensure the original argument was valid ~ percentage will be nil if there as a non valid argument
    if x_perc == nil then
        return { false, { error = "Invalid: argument: x_align", hint = "Please select a valide position preset or a percentage" } }
    end
    if y_perc == nil then
        return { false, { error = "Invalid: argument: x_align", hint = "Please select a valide position preset or a percentage" } }
    end

    -- Window Size Arguments ~ default: width = 640 | height = 480
    local window_width = args.width or 640 -- window width ~ default is 640
    local window_height = args.height or 480 -- window height ~ default is 480

    -- Validate and Retrieve Calculated Geometry
    local x, width
    local y, height

    local horizontal_calc = position_util.geometryValueValidation(screen_geometry.width, x_perc, window_width)
    if horizontal_calc[1] then
        x = horizontal_calc[1]
        width = horizontal_calc[2]
    else
        return horizontal_calc -- route the error message to the one calling this function
    end

    local vertical_calc = position_util.geometryValueValidation(screen_geometry.height, y_perc, window_height)
    if vertical_calc[1] then
        y = vertical_calc[1]
        height = vertical_calc[2]
    else
        return vertical_calc -- route the error message to the one calling this function
    end

    return { x = x, y = y, width = width, height = height }
end

-- Test
function position_util.test()
    return "Why the fuck is this shit not working"
end

return position_util
