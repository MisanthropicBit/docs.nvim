local icons = {}

local ansi = require("docs.ansi")

local has_web_devicons, web_devicons = pcall(require, "nvim-web-devicons")

--- Get an icon by name or filetype
---@param name string
function icons.get(name)
    if not has_web_devicons then
        return nil
    end

    local icon, gui_color, term_color = web_devicons.get_icon_colors(name)

    if not icon then
        icon, gui_color, term_color = web_devicons.get_icon_colors_by_filetype(name)
    end

    if icon then
        local color = ""

        if vim.o.termguicolors and gui_color then
            color = ansi.rgb_string_to_ansi(gui_color, false)
        else
            color = ansi.term_color_to_ansi(term_color, false)
        end

        return icon, color
    end

    return nil
end

return icons