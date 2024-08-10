---@alias DocsSourceAlias string

---@class DocsUrlSource
---@field url string?
---@field iskeyword string[]?
---@field aliases DocsSourceAlias[]
---@field name string
---@field description? string
---@field icon string
---@field icon_name string

---@class DocsCommandSource
---@field command string?
---@field query string?
---@field iskeyword string[]?
---@field aliases DocsSourceAlias[]

---@class DocsShellSource
---@field shell string?
---@field iskeyword string[]?
---@field aliases DocsSourceAlias[]

---@class DocsCallbackContext
---@field query string
---@field filetype string

---@class DocsSourceCallbackSource
---@field callback fun(context: DocsCallbackContext): DocsSource
---@field iskeyword string[]?
---@field aliases DocsSourceAlias[]

---@class DocsCallbackSource
---@field callback fun(query: string, filetype: string)
---@field iskeyword string[]?
---@field aliases DocsSourceAlias[]

---@alias DocsSource
--- | DocsUrlSource
--- | DocsCommandSource
--- | DocsShellSource
--- | DocsSourceCallbackSource
--- | DocsCallbackSource
--- | DocsSourceAlias
