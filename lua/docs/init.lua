local docs = {}

local config = require("docs.config")
local cword = require("docs.cword")
local message = require("docs.message")
local pickers = require("docs.pickers")
local sources = require("docs.sources")

-- TODO: Combine the two functions below?

-- Open docs for the word under the cursor
function docs.open_at_cursor(options)
    local filetype = options.fargs[2] or vim.bo.filetype
    local source = sources.get_for_filetype(filetype)
    local _cword = cword.get(source)

    docs.open(_cword, filetype, options.mods)
end

-- Open docs from a command invocation
---@async
---@param options table
function docs.open_docs_from_command(options)
    local fargs = options.fargs
    local query, filetype, doc_sources = fargs[1], vim.bo.filetype, nil

    -- TODO: Check if doc_sources is a filetype or a builtin
    if #fargs == 1 then
        filetype = vim.bo.filetype
    else
        filetype = fargs[2]
    end

    if filetype and #filetype > 0 then
        doc_sources = sources.get_for_filetype(filetype)
    end

    if not doc_sources or #doc_sources == 0 then
        -- TODO: Change to config.fallback
        doc_sources = { require("docs.sources.builtins.devdocs") }
        -- vim.notify("No available documentation source", vim.log.levels.ERROR)
        -- return
    end

    local context = {
        query = query,
        filetype = filetype,
        mods = options.mods,
    }

    if #doc_sources > 1 then
        vim.print(vim.inspect(config))
        local picker = pickers.get_picker(config.picker)
        vim.print(vim.inspect(picker))

        if not picker then
            message.error(("Invalid picker option in config: '%s'"):format(config.picker))
        else
            picker.pick_source(context, doc_sources)
        end
    else
        sources.run(doc_sources[1], context)
    end
end

return docs