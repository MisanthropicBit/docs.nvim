local docs = require("docs")
local builtins = require("docs.sources.builtins")

local function format_source(source)
    return source.name
end

--- Completion function for commands
---@param _ any
---@param cmdline string
---@return string[]
local function complete(_, cmdline)
    local result = vim.api.nvim_parse_cmd(cmdline, {})

    if (#result.args == 1 and cmdline:match("%s+$")) or #result.args > 1 then
        -- local custom_sources = vim.tbl_map(format_source, vim.tbl_keys(config.custom))

        return builtins.names() -- vim.list_extend(builtin_sources, custom_sources)
    end

    return {}
end

vim.api.nvim_create_user_command("Docs", docs.open_docs_from_command, {
    desc =
    "Query documentation. First argument is a topic, the second is an optional supported filetype. If not given, takes the filetype of the current file",
    nargs = "+",
    range = true,
    complete = complete,
})

vim.api.nvim_create_user_command("DocsCursor", docs.open_at_cursor, {
    desc = "Query documentation for the word under the cursor",
    nargs = "?",
})