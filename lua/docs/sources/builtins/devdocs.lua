return {
    callback = function(context)
        return {
            url = ("https://devdocs.io/#q=%s%%%%20%s"):format(context.filetype, context.query),
        }
    end,
}