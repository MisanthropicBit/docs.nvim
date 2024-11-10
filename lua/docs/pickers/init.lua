local pickers = {}

local sources = require("docs.sources")

---@class Picker
---@field pick_source fun(query: string, doc_sources: DocsSource[])

local function builtin_picker()
    return {
        pick_source = function(context, doc_sources)
            vim.ui.select(doc_sources, {
                prompt = "Select doc source> ",
                format_item = function(item)
                    return item.name
                end,
            }, function(choice)
                if not choice then
                    return
                end

                sources.run(doc_sources[1], { query = context.query })
            end)
        end
    }
end

---@param name string
function pickers.get_picker(name)
    if name == "builtin" then
        return builtin_picker()
    end

    local _, picker = pcall(require, "docs.pickers." .. name)

    return picker
end

return pickers