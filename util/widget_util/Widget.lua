-- Dependencies
local class = require("middleclass")
local wibox = require("wibox")
local awful = require("awful")

--[[ --| Widget Class |-- ]]--

local WidgetClass = class('WidgetClass')

-- The goal of this class is to slowly build out a good widget class framework, to make creation of custom widgets super easy
-- This 'Widget' class is meant to be a starting point to more in-depth and involved widget related classes.


-- [[ Widget Initialization and Parameter Setting ]] --

-- Create the base wibox container upon creation of a new object
function WidgetClass:initialize(height, width)
    self.w = wibox{}
    self.w.screen = awful.screen.focused{}
    self.w.height = height
    self.w.width = width
end

return WidgetClass
