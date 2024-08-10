local pickers = {}

local config = require("docs.config")
local message = require("docs.message")
local sources = require("docs.sources.builtins.init")

local function builtin_picker(query, filetype, mods, filetype_sources)
    vim.ui.select(filetype_sources, {
        prompt = "Select doc source> ",
        format_item = function(item)
        end,
    }, function(choice)
        sources.resolve(choice, {
            query = query,
            filetype = filetype,
            mods = mods,
        })
    end)
end

function pickers.get_picker()
    if type(config.picker) == "string" then
        if config.picker == "builtin" then
            return builtin_picker
        end

        local has_picker, picker = pcall(require, "docs.pickers." .. config.picker)

        if not has_picker then
            message.error(("Invalid picker option in config: '%s'"):format(config.picker))
        else
            return picker.pick_source
        end
    end
end

return pickers
