-- ── Plugin Setup ───────────────────────────────────────────────────
local M = {}

M.icons = require("mantiq.icons")
M.assets = require("mantiq.assets")
M.lsp = require("mantiq.lsp")
M.commands = require("mantiq.commands")

function M.setup(opts)
    opts = opts or {}

    -- Setup devicons for file managers
    M.icons.setup()

    -- Setup buffer options & user commands
    M.commands.setup()

    -- Setup LSP Language Server client connection
    M.lsp.setup(opts)

    -- Register .mq and .nz filetypes
    vim.filetype.add({
        extension = {
            mq = "mantiq",
            nz = "nizam",
        },
    })

    -- Both filetypes use the same tree-sitter parser
    if vim.treesitter.language.register then
        pcall(vim.treesitter.language.register, "mantiq", "nizam")
        pcall(vim.treesitter.language.register, "mantiq", "mantiq")
    end

    -- Register parser with nvim-treesitter if available
    local ok, parsers = pcall(require, "nvim-treesitter.parsers")
    if ok and parsers then
        local parser_config = nil
        if type(parsers.get_parser_configs) == "function" then
            pcall(function() parser_config = parsers.get_parser_configs() end)
        elseif type(parsers.get_parser_configs) == "table" then
            parser_config = parsers.get_parser_configs
        end

        if parser_config then
            parser_config.mantiq = {
                install_info = {
                    url = opts.parser_path or (vim.fn.stdpath("data") .. "/tree-sitter-mantiq"),
                    files = { "src/parser.c" },
                    generate_requires_npm = false,
                },
                filetype = { "mantiq", "nizam" },
            }
            parser_config.nizam = parser_config.mantiq
        end
    end

    -- Enable tree-sitter highlighting for both filetypes
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "mantiq", "nizam" },
        callback = function(ev)
            pcall(vim.treesitter.start, ev.buf, "mantiq")
        end,
    })
end

return M
