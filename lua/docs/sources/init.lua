local sources = {}

local config = require("docs.config")
local message = require("docs.message")
local process = require("docs.process")

---@class DocsConfigResolveContext
---@field query string
---@field filetype string
---@field mods string

local alias_recursion_limit = 10

local function process_on_exit_handler(success, result, code)
    if not success then
        -- TODO: Log as well
        message.error(("Command failed with code %d: %s"):format(
            code, table.concat(result.stderr, "\n")
        ))
    end
end

--- Resolve a source alias
---@param source DocsSource
---@param seen string[]
---@param recursion_counter integer
---@return DocsSource?
local function resolve_source(source, seen, recursion_counter)
    if recursion_counter >= alias_recursion_limit then
        message.error("Alias recursion limit reached (%s): " .. table.concat(seen, " => "))
        return nil
    end

    if type(source) == "string" then
        if vim.tbl_contains(seen, source) then
            message.error("Alias loop detected (%s): " .. table.concat(seen, " => "))
            return nil
        end

        table.insert(seen, source)

        return resolve_source(config.sources[source], seen, recursion_counter + 1)
    end

    return source
end

---@param filetype string
---@return DocsSource[]?
function sources.get_for_filetype(filetype)
    local custom_source = config.custom[filetype]

    -- Use a custom config if there is one
    if custom_source then
        return custom_source
    end

    local filetype_sources = config.filetype[filetype]

    if filetype_sources and #filetype_sources > 0 then
        local resolved_sources = {}

        for filetype_source in filetype_sources do
            local resolved_source = resolve_source(filetype_source, {}, 0)

            if not resolved_source then
                return { config.fallback }
            end

            table.insert(resolved_sources, resolved_source)
        end

        return resolved_sources
    end

    return { config.fallback }
end

---@param source DocsUrlSource
---@param context DocsConfigResolveContext
---@async
local function resolve_url_source(source, context)
    config.open_url(source.url:format(context.query), process_on_exit_handler)
end

---@param source DocsShellSource
---@param context DocsConfigResolveContext
---@async
local function resolve_shell_source(source, context)
    process.spawn(source.shell, {
        args = { context.query },
        on_exit = process_on_exit_handler,
    })
end

---@param source DocsCommandSource
---@param context DocsConfigResolveContext
local function resolve_command_source(source, context)
    local _query = source.query or context.query
    local args ---@type string[]

    if type(_query) == "string" then
        args = { _query }
    else
        args = _query
    end

    vim.cmd(("silent %s %s %s"):format(context.mods, source.command, table.concat(args, " ")))
end

---@param source DocsSourceCallbackSource
---@param context DocsConfigResolveContext
local function resolve_callback_source(source, context)
    local new_source = source.callback({ query = context.query, filetype = context.filetype })

    sources.run(new_source, context)
end

--- Resolve a docs source
function sources.resolve(source_name)
    return resolve_source(source_name, {}, 0)
end

--- Run a docs source
---@async
---@param source DocsSource
---@param context DocsConfigResolveContext
function sources.run(source, context)
    if source.url ~= nil then
        ---@cast source DocsUrlSource
        resolve_url_source(source, context)
    elseif source.shell ~= nil then
        ---@cast source DocsShellSource
        resolve_shell_source(source, context)
    elseif config.command ~= nil then
        ---@cast source DocsCommandSource
        resolve_command_source(source, context)
    elseif type(config.config_callback) == 'function' then
        ---@cast source DocsSourceCallbackSource
        resolve_callback_source(source, context)
    elseif type(config.callback) == "function" then
        config.callback({
            query = context.query,
            filetype = context.filetype
        })
    else
        message.error(("Failed to resolve source for filetype '%s'"):format(context.filetype))
    end
end

-- sources.builtins = function()
--     return require("docs.sources.builtins")
-- end

-- sources.filetypes = function()
--     return require("docs.sources.filetypes")
-- end

return sources