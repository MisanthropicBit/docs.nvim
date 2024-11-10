local config = {}

local open = require("docs.open")
local message = require("docs.message")

local config_loaded = false

---@class DocsConfig
---@field builtins boolean
---@field picker "builtin" | "fzf-lua" | "telescope"
---@field icons boolean
---@field sources table<string, DocsSource[]>
---@field fallback DocsSource
---@field open_url fun(path: string): nil

-- TODO: Allow multiple sources per filetype/custom

--- Check if a value is a valid string option
---@param value any
---@return boolean
function config.valid_string_option(value)
    return value ~= nil and type(value) == "string" and #value > 0
end

local function validate_source(value)
    if value == nil or type(value) ~= "table" then
        return false
    end

    return value.url or value.command or value.shell or value.callback
end

--- Validate a config
---@param _config DocsConfig
---@return boolean
---@return any?
function config.validate(_config)
    -- stylua: ignore start
    return pcall(vim.validate, {
        builtins = {
            _config.builtins,
            "boolean",
        },
        picker = {
            _config.picker,
            "string",
        },
        icons = {
            _config.icons,
            "boolean",
        },
        sources = {
            _config.sources,
            function(config_sources)
                if type(config_sources) == "table" then
                    return false
                end

                for source in config_sources do
                    if not validate_source(source) then
                        return false
                    end
                end

                return true
            end,
        },
        fallback = {
            _config.sources,
            validate_source,
        },
        open_url = {
            _config.open_url,
            "function",
        }
    })
    -- stylua: ignore end
end

--- Used in testing
---@private
function config._default_config()
    ---@type DocsConfig
    return {
        builtins = true,
        picker = "builtin",
        icons = false,
        sources = {},
        fallback = require("docs.sources.builtins.devdocs"),
        open_url = open.open_external,
        custom = {},
    }
end

local _user_config = config._default_config()

---@param user_config? DocsConfig
---@return boolean
function config.configure(user_config)
    vim.print(vim.inspect(user_config))
    _user_config = vim.tbl_deep_extend("keep", user_config or {}, config._default_config())
    _user_config.picker = "fzf-lua"

    -- local ok, error = config.validate(_user_config)
    --
    -- if not ok then
    --     message.error("Errors found in config: " .. error)
    -- else
    --     config_loaded = true
    -- end
    --
    if type(_user_config.builtins) == "boolean" and _user_config.builtins then
        for _, name in ipairs(require("docs.sources.builtins").names()) do
            _user_config.sources[name] = require("docs.sources.builtins")[name]
        end
    end

    return true -- ok
end

setmetatable(config, {
    __index = function(_, key)
        -- Lazily load configuration so there is no need to call configure explicitly
        if not config_loaded then
            config.configure()
        end

        return _user_config[key]
    end,
})

return config