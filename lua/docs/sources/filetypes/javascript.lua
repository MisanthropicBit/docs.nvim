local builtins = require("docs.sources.builtins")

return {
    mozilla = {
        name = "mozilla",
        icon = "",
        url = function(context)
            local lang = context.language or "en"

            return ("https://developer.mozilla.org/%s/search?topic=api&topic=js&q=%%s"):format(lang)
        end,
        iskeyword = { "." },
    },
    -- jest = builtins.jest,
    -- mocha = builtins.mocha,
    npm = builtins.npm,
    -- react = builtins.react,
    -- sinon = builtins.sinon,
}