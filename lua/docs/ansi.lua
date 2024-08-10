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

    local r = rgb:sub(1, 2)
    local g = rgb:sub(3, 4)
    local b = rgb:sub(5, 6)

    local ansi_code = is_bg and "48" or "38"
    return ("\x1b[%s;2;%s;%s;%sm"):format(ansi_code, r, g, b)
end

return ansi