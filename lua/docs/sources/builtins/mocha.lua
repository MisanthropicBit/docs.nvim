local config = require("docs.config")
local filetypes = require("docs.sources.filetypes")

return {
    name = "mocha",
    description = "Documentation for the Mocha javascript testing framework",
    icon = "test.js",
    url = config.generic_search_url("https://jestjs.io"),
    iskeyword = filetypes.javascript.iskeyword,
}