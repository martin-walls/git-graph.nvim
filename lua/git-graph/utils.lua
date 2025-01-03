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

---@param str string
---@return string
local function trim_end(str)
    local res = string.gsub(str, "^(.-)%s*$", "%1")
    return res
end

---@param lines table
---@return table
M.format_graph = function(lines)
    for i, line in ipairs(lines) do
        -- local j, _ = string.find(line, "%w%w%w%w%w%w%w - ")
        --
        -- if j == nil then
        --     line = string.gsub(line, "%*", "")
        --     line = string.gsub(line, "|", "")
        --     line = string.gsub(line, "\\", "╲")
        --
        --     lines[i] = line
        -- else
        --     local prefix = string.sub(line, 1, j - 2);
        --     local body = string.sub(line, j - 1);
        --
        --     prefix = string.gsub(prefix, "%*", "")
        --     prefix = string.gsub(prefix, "|", "")
        --     prefix = string.gsub(prefix, "\\", "╲")
        --
        --
        --
        --     lines[i] = prefix .. body
        -- end

        lines[i] = trim_end(line)
    end
    return lines
end

-- TODO: strip trailing whitespace

return M
