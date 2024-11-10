local health = {}

local config = require("docs.config")

local min_neovim_version = "0.8.0"

local report_start = vim.health.report_start
local report_ok = vim.health.report_ok
local report_error = vim.health.report_error
local report_warn = vim.health.report_warn

if vim.fn.has("nvim-0.10") == 1 then
    report_start = vim.health.start
    report_ok = vim.health.ok
    report_error = vim.health.error
    report_warn = vim.health.warn
end

local function check_dependency(name)
    local has_dep, dep = pcall(require, name)

    if has_dep then
        report_ok(("'%s' installed"):format(dep))
    else
        report_warn(("'%s' not installed"):format(dep))
    end
end

function health.check()
    report_start("docs")

    if vim.fn.has("nvim-" .. min_neovim_version) == 1 then
        report_ok(("has neovim %s+"):format(min_neovim_version))
    else
        report_error("docs.nvim requires at least neovim " .. min_neovim_version)
    end

    local ok, error = config.validate(config)

    if ok then
        report_ok("found no errors in config")
    else
        report_error("config has errors: " .. error)
    end

    check_dependency("nvim-web-devicons")
    check_dependency("nvim-treesitter")
end

return health