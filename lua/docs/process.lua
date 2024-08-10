local process = {}

local uv = vim.loop

local signals = {}

---@class DocsProcessResult
---@field stdout string[]
---@field stderr string[]

---@class DocsProcessOptions
---@field args? string[]
---@field cwd? string
---@field stdin? string | string[]
---@field on_exit fun(success: boolean, result: DocsProcessResult, code: integer, signal: integer): nil

---@type table<uv_process_t, true?>
local running = {}

local function create_on_read_handler(result, stdio)
    ---@diagnostic disable-next-line: unused-local
    return function(err, data)
        if data then
            local sub, _ = data:gsub("\r\n", "\n")
            table.insert(result[stdio], sub)
        end
    end
end

--- Spawn an asynchronous process
---@param command string
---@param options DocsProcessOptions?
---@return uv_process_t|nil
function process.spawn(command, options)
    local stdin = uv.new_pipe()
    local stdout = uv.new_pipe()
    local stderr = uv.new_pipe()
    local handle = nil
    local pid = nil
    local result = {
        stdout = {},
        stderr = {},
    }
    local _options = options or {}

    handle, pid = uv.spawn(command, {
        stdio = { stdin, stdout, stderr },
        args = _options.args,
        cwd = _options.cwd,
    }, function(code, signal)
        if handle then
            handle:close()
        end

        stdin:close()
        stdout:close()
        stderr:close()

        local on_exit = _options.on_exit

        if on_exit then
            if type(on_exit) == "function" then
                on_exit(code == 0, result, code, signal)
            else
                -- TODO: Safe to do here?
                error("Process got non-function for option 'on_exit'")
            end
        end
    end)

    if not handle then
        return handle
    end

    running[handle] = true

    uv.read_start(stdout, create_on_read_handler(result, "stdout"))
    uv.read_start(stderr, create_on_read_handler(result, "stderr"))

    if _options.stdin then
        uv.write(stdin, _options.stdin)

        uv.shutdown(stdin, function()
            if handle then
                uv.close(handle, function()
                    vim.print("process closed", handle, pid)
                end)
            end
        end)
    end

    return handle
end

---@param handle uv_process_t
function process.kill(handle)
    if handle and not handle:is_closing() then
        running[handle] = nil
        uv.process_kill(handle, signals.sigint)

        return true
    end

    return false
end

function process.kill_all()
    for handle in pairs(running) do
        process.kill(handle)
    end
end

return process
