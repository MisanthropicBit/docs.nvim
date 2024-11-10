---@type table<string, DocsSource>
return {
    devdocs = {
        callback = function(context)
            local base_url = "https://devdocs.io/#q=%s%%20%s"
            local url_params = "#q="

            if context.filetype then
                url_params = url_params .. context.filetype .. "%%20"
            end

            url_params = url_params .. context.query

            return {
                url = base_url .. url_params
            }
        end
    }
}