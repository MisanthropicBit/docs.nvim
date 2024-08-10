local builtins = {}

function builtins.names()
    return {
        "bing",
        "chai",
        "devdocs",
        "duckduckgo",
        -- "google",
        -- "jest",
        -- "knex",
        -- "mocha",
        -- "momentjs",
        -- "mozilla",
        "npm",
        "pytest",
        -- "react",
        "sinon",
    }
end

setmetatable(builtins, {
    ---@diagnostic disable-next-line: unused-local
    __index = function(tbl, key)
        return require("docs.sources.builtins." .. key)
    end,
})

return builtins