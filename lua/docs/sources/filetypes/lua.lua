local nvim_doc_prefixes = {
    "diagnostic",
    "filetype",
    "fs",
    "health",
    "highlight",
    "keymap",
    "log",
    "loop",
    "lsp",
    "treesitter",
    "ui",
    "uv",
}

local function is_supported_nvim_prefix(parts)
    if parts[1] == "vim" then
        if vim.tbl_contains(nvim_doc_prefixes, parts[2]) then
            return {
                command = "help ",
                query = table.concat(parts, ".")
            }
        else
            return {
                command = "help ",
                query = parts[#parts]
            }
        end
    end

    return nil
end

return {
    ---@diagnostic disable-next-line: unused-local
    config_callback = function(query, filetype)
        if query:find("n?vim") ~= nil then
            local parts = vim.fn.split(query, "\\.")
            local result = is_supported_nvim_prefix(parts)

            if result ~= nil then
                return result
            end

            return { command = "help" }
        elseif query:find([[uv.]]) then
            return {
                command = "help ",
                query = query
            }
        end

        -- Use fallback with lua v5.1 documentation
        return fallback.config_callback(query, filetype .. "5.1")
    end,
    iskeyword = { "." },
}
