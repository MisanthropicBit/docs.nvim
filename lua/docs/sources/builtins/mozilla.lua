local sources = require("docs.sources")

return {
    name = "mozilla",
    description = "Mozilla developer documentation",
    icon_name = "jsx",
    -- TODO: Support different languages
    url = "https://developer.mozilla.org/en-US/search?q=%s",
    iskeyword = sources.filetypes.javascript.iskeyword,
}