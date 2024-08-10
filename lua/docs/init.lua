local docs = {}

local config = require("docs.config")
local cword = require("docs.cword")
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
    local query, filetype, doc_sources

    if #fargs > 1 then
        query, doc_sources = fargs[1], { sources.resolve(fargs[2]) }
        -- TODO: Check if doc_sources is a filetype or a builtin
    else
        filetype, doc_sources = vim.bo.filetype, sources.get_for_filetype(filetype)
    end

    vim.print(config.sources)
    vim.print(query, doc_sources, filetype)

    if not doc_sources or #doc_sources == 0 then
        vim.notify("No available documentation source", vim.log.levels.ERROR)
        return
    end

    if #doc_sources > 1 then
        pickers.get_picker()(doc_sources)
    else
        sources.run(doc_sources[1], {
            query = query,
            filetype = filetype,
            mods = options.mods,
        })
    end
end

return docs