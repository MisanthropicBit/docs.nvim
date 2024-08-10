local config = require("docs.config")
local filetypes = require("docs.sources.filetypes")

return {
    name = "react",
    description = "Documentation for the React javascript frontend framework",
    icon_name = "jsx",
    url = config.generic_search_url("https://jestjs.io"),
    iskeyword = filetypes.javascript.iskeyword,
}
