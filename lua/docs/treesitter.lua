local treesitter = {}

local has_nvim_treesitter, nvim_treesitter = pcall(require, "nvim-treesitter")

if has_nvim_treesitter then
    function treesitter.get_node_text_at_cursor()
        local ts_utils = require("nvim-treesitter.ts_utils")
        local node = ts_utils.get_node_at_cursor()
        local text = ts_utils.get_node_text(node)

        return text
    end
else
    function treesitter.get_node_text_at_cursor()
        -- TODO:
        return nil
    end
end

return treesitter
