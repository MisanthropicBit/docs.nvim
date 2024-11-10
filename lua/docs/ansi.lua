local ansi = {}

--- Return the ansi escape sequence for resetting escape sequences
---@return string
function ansi.reset()
    return "\x1b[0m"
end

function ansi.rgb_string_to_ansi(color, is_bg)
    local rgb = color:match("^#?([a-fA-F0-9]+)$")

    if not rgb then
        error("Invalid rgb string: " .. color)
    end

    local r = tonumber(rgb:sub(1, 2), 16)
    local g = tonumber(rgb:sub(3, 4), 16)
    local b = tonumber(rgb:sub(5, 6), 16)
    local ansi_code = is_bg and "48;2" or "38;2"

    return ("\x1b[%s;%s;%s;%sm"):format(ansi_code, r, g, b)
end

return ansi