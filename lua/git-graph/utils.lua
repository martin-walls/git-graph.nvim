local M = {}

---Splits the given string into an array of lines.
---@param str string
---@return table
M.lines = function(str)
    local result = {}
    for line in str:gmatch("[^\n]+") do
        table.insert(result, line)
    end
    return result
end

return M
