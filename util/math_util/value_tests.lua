-- Dependencies

--[[ --| Value Testing Utilites |-- ]]--
local value_tests = {}

-- Percentage test
function value_tests.isPercent(value)
    if value > 0.0 and value < 1.0 then
        return true
    else
        return false
    end
end

-- Number Test
function value_tests.isNumber(value)
    local numberValue = tonumber(value)

    if numberValue then
        return true
    else
        return false
    end
end


return value_tests
