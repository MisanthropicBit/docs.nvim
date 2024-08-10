local cword = require("docs.cword")
local treesitter = require("docs.tresitter")

return {
    -- TODO: Handle generating from cursor i.e. no user input
    callback = function(context)
        local path = vim.fn.expand("%:t")

        if path:match("package[A-Za-z0-9-_.]*.json") then
            local word = cword.get(nil)

            local ok, version = pcall(vim.version.parse, word)

            if ok then
                -- TODO: Handle other semantic versions
                local prev_sibling = treesitter.get_previous_sibling(version.node)
                local url = "https://www.npmjs.com/package/%s/v/%d.%d.%d"

                return {
                    url = url:format(
                        prev_sibling.text,
                        version.major,
                        version.minor,
                        version.patch
                    )
                }
            else
                return {
                    url = ("https://www.npmjs.com/package/%s"):format(version.text)
                }
            end
        end
    end
}
