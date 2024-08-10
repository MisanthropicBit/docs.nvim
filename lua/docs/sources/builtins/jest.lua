local config = require("docs.config")
local filetypes = require("docs.sources.filetypes")

return {
    name = "jest",
    description = "Documentation for the Jest javascript testing framework",
    icon = "test.js",
    url = config.generic_search_url("https://jestjs.io"),
    iskeyword = filetypes.javascript.iskeyword,
}
