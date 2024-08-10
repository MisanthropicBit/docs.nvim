local fzf_lua = {}

local ansi = require("docs.ansi")
local config = require("docs.config")
local message = require("docs.message")
local sources = require("docs.sources")

local has_fzf_lua, _fzf_lua = pcall(require, "fzf-lua")
local has_web_devicons, web_devicons = pcall(require, "nvim-web-devicons")

---@param item DocsSource
---@return string
local function make_source_item(item)
    local icon, gui_color, term_color

    if item.icon then
        icon = item.icon
    elseif item.icon_name then
        if not has_web_devicons then
            -- TODO:
        end

        icon, gui_color, term_color = web_devicons.get_icon_colors(item.icon_name)
    else
        if has_web_devicons then
            icon, gui_color, term_color = web_devicons.get_icon_colors_by_filetype(
                item.filetype
            )
        end
    end

    local color = ""

    if vim.o.termguicolors and gui_color then
        color = ansi.rgb_string_to_ansi(gui_color, false)
    else
        color = ansi.term_color_to_ansi(term_color, false)
    end

    if icon then
        return ("%s%s%s %s"):format(color, icon, ansi.reset(), item.name)
    end

    return item.name
end

--- Pick an item from a list of items with fzf-lua
---@generic T
---@param query T
---@param items T
---@param make_item fun(item: T): string
function fzf_lua.pick(query, items, make_item)
    local formatted_items = vim.tbl_map(make_item, items)

    local fzf_lua_options = vim.tbl_deep_extend("force", {
        prompt = "Select doc > ",
        winopts = {
            title = "docs.nvim",
            title_pos = "center",
            height = 0.33,
            width = 0.25,
            preview = {
                layout = "vertical",
            },
        },
        actions = {
            default = function(selected)
                local source = sources.get_for_filetype(selected[1])

                ---@cast source DocsSource
                sources.run(source, {
                    query = query,
                    filetype = selected[1],
                    mods = "",
                })
            end,
        },
        fzf_opts = {
            ["--preview"] = _fzf_lua.shell.action(function(parts)
                return parts[1].description
            end)
        },
    }, config.picker.options)

    _fzf_lua.fzf_exec(formatted_items, fzf_lua_options)
end

function fzf_lua.pick_source(query, items)
    if not has_fzf_lua then
        message.error("Fzf-lua is not installed")
        return
    end

    fzf_lua.pick(query, items, make_source_item)
end

return fzf_lua