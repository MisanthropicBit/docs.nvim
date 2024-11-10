---@type Picker
local fzf_lua = {}

local ansi = require("docs.ansi")
local message = require("docs.message")
local sources = require("docs.sources")

local has_fzf_lua, _fzf_lua = pcall(require, "fzf-lua")
local has_web_devicons, web_devicons = pcall(require, "nvim-web-devicons")

local IndexedPreviewer

if has_fzf_lua then
    local builtin = require("fzf-lua.previewer.builtin")
    IndexedPreviewer = builtin.base:extend()

    function IndexedPreviewer:new(o, opts, fzf_win)
        IndexedPreviewer.super.new(self, o, opts, fzf_win)
        setmetatable(self, IndexedPreviewer)
        return self
    end

    function IndexedPreviewer:gen_winopts()
        local new_winopts = {
            wrap = true,
            number = false,
        }

        return vim.tbl_extend("force", self.winopts, new_winopts)
    end

    function IndexedPreviewer:populate_preview_buf(entry_str)
        local tmpbuf = self:get_tmp_buffer()

        vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, {
            -- TODO: Better parsing
            self.opts.item_map[vim.split(entry_str, " ")[2]].description or "No description"
        })

        self:set_preview_buf(tmpbuf)
        self.win:update_scrollbar()
    end
end

---@param item DocsSource
---@return string
local function make_source_item(item, context)
    local icon, gui_color, term_color

    if item.icon then
        icon = item.icon

        if has_web_devicons then
            icon, gui_color, term_color = web_devicons.get_icon_colors_by_filetype(context.filetype)
        end
    elseif item.icon_name then
        icon, gui_color, term_color = web_devicons.get_icon_colors(item.icon_name)
    else
        if has_web_devicons then
            icon, gui_color, term_color = web_devicons.get_icon_colors_by_filetype(context.filetype)
        end
    end

    local color = ""

    if gui_color then
        if vim.o.termguicolors then
            color = ansi.rgb_string_to_ansi(gui_color, false)
        end
    else
        if term_color then
            color = ansi.term_color_to_ansi(term_color, false)
        end
    end

    if icon then
        return ("%s%s%s %s"):format(color, icon, ansi.reset(), item.name)
    end

    return item.name
end

local function compare_doc_sources_by_name(source1, source2)
    return source1.name < source2.name
end

--- Pick an item from a list of items with fzf-lua
---@generic T
---@param context DocsConfigResolveContext
---@param items T
---@param make_item fun(item: T, context: DocsConfigResolveContext): string
function fzf_lua.pick(context, items, make_item)
    local item_map = {}

    table.sort(items, compare_doc_sources_by_name)

    local formatted_items = vim.tbl_map(function(item)
        item_map[item.name] = item
        return make_item(item, context)
    end, items)

    local fzf_lua_options = vim.tbl_deep_extend("force", {
        prompt = "Select doc source > ",
        winopts = {
            title = "docs.nvim",
            title_pos = "center",
            -- TODO: Adapt to size of contents
            height = 0.33,
            width = 0.25,
            preview = {
                layout = "vertical",
            },
        },
        previewer = IndexedPreviewer,
        item_map = item_map,
        actions = {
            default = function()
                local source = sources.get_for_filetype(context.filetype)
                vim.print(vim.inspect(source))

                sources.run(source, context)
            end,
        },
    }, {}) -- config.picker.options or {})

    _fzf_lua.fzf_exec(formatted_items, fzf_lua_options)
end

---@generic T
---@param context DocsConfigResolveContext
---@param items T[]
function fzf_lua.pick_source(context, items)
    if not has_fzf_lua then
        message.error("Fzf-lua is not installed")
        return
    end

    fzf_lua.pick(context, items, make_source_item)
end

return fzf_lua