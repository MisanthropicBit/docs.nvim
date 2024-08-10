local cword = {}

local treesitter = require("docs.treesitter")

--- Get the word under the cursor
---@param iskeyword string?
---@return string
function cword.get(iskeyword)
    local ts_cword = treesitter.get_node_text_at_cursor()

    if ts_cword then
        return ts_cword
    end

    if iskeyword ~= nil then
        vim.opt_local.iskeyword:append(iskeyword)
    end

    local _cword = vim.fn.expand("<cword>")

    if iskeyword ~= nil then
        vim.opt_local.iskeyword:remove(iskeyword)
    end

    return _cword
end

return cword
