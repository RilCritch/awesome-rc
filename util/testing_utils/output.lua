-- Dependencies

--[[ --| Text Output Utilities To Make Debugging Easier |-- ]]--
local output = {}

--[[ Table Printing ]]--

-- basic table print
function output.table(tbl)
    local result = ""
    for k, v in pairs(tbl) do
        result = result .. k .. ": " .. tostring(v) .. " | "
    end
    return result
end

return output
