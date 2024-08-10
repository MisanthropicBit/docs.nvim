local open = {}

local process = require("docs.process")

--- Open a path, url or similar
---@return string[]?
local function get_open_command()
    -- Taken from oil.nvim
    if vim.fn.has("mac") == 1 then
        return { "open" }
    elseif vim.fn.has("win32") == 1 then
        if vim.fn.executable("rundll32") == 1 then
            return { "rundll32", "url.dll,FileProtocolHandler" }
        else
            return nil
        end
    elseif vim.fn.executable("wslview") == 1 then
        return { "wslview" }
    elseif vim.fn.executable("xdg-open") == 1 then
        return { "xdg-open" }
    else
        return nil
    end
end

---@param path string
function open.open_external(path, on_exit)
    local command = get_open_command()

    if not command then
        vim.notify(
            ("Could not open '%s', no handler found"):format(path),
            vim.log.levels.ERROR
        )
        return
    end

    process.spawn(table.concat(command, " "), {
        args = { path },
        on_exit = on_exit
    })
end

return open