-- ── LSP Server Setup ──────────────────────────────────────────────────
local M = {}

function M.setup(opts)
    opts = opts or {}
    local lsp_opts = opts.lsp or {}

    if lsp_opts.enable == false then
        return
    end

    local server_path = lsp_opts.server_path
    if not server_path or server_path == "" then
        local workspace_server = vim.fn.findfile("mantiq-vscode/out/server.js", ".;")
        if workspace_server ~= "" then
            server_path = vim.fn.fnamemodify(workspace_server, ":p")
        else
            local local_server = vim.fn.expand("~/.local/lib/mantiq/server.js")
            if vim.fn.filereadable(local_server) == 1 then
                server_path = local_server
            elseif vim.fn.filereadable("/usr/local/lib/mantiq/server.js") == 1 then
                server_path = "/usr/local/lib/mantiq/server.js"
            end
        end
    end

    if not server_path or vim.fn.filereadable(server_path) == 0 then
        return
    end

    local wasm_path = lsp_opts.wasm_path
    if not wasm_path or wasm_path == "" then
        local adjacent_wasm = vim.fn.fnamemodify(server_path, ":h:h") .. "/tree-sitter-mantiq.wasm"
        if vim.fn.filereadable(adjacent_wasm) == 1 then
            wasm_path = adjacent_wasm
        else
            local local_wasm = vim.fn.expand("~/.local/lib/mantiq/tree-sitter-mantiq.wasm")
            if vim.fn.filereadable(local_wasm) == 1 then
                wasm_path = local_wasm
            elseif vim.fn.filereadable("/usr/local/lib/mantiq/tree-sitter-mantiq.wasm") == 1 then
                wasm_path = "/usr/local/lib/mantiq/tree-sitter-mantiq.wasm"
            end
        end
    end

    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "mantiq", "nizam" },
        callback = function(ev)
            local root_files = vim.fs.find({
                ".git",
                "MANTIQ.mq",
                "NIZAM.nz",
                "mantiq",
                "mantiqz",
                "compiler-service",
                "mantiq_nizam",
                "mantiq-compiler",
            }, { upward = true, path = ev.file })
            local root_dir = #root_files > 0 and vim.fs.dirname(root_files[1]) or vim.fn.getcwd()

            local init_options = lsp_opts.initializationOptions or {}
            if wasm_path and wasm_path ~= "" and not init_options.wasmPath then
                init_options.wasmPath = wasm_path
            end

            vim.lsp.start({
                name = "mantiq_lsp",
                cmd = { "node", server_path, "--stdio" },
                root_dir = root_dir,
                init_options = init_options,
                settings = lsp_opts.settings or {},
                on_attach = function(client, bufnr)
                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
                    end

                    map("n", "gd", vim.lsp.buf.definition, "Mantiq: Go to Definition")
                    map("n", "K", vim.lsp.buf.hover, "Mantiq: Hover Documentation")
                    map("n", "<leader>rn", vim.lsp.buf.rename, "Mantiq: Rename Symbol")
                    map("n", "<leader>ca", vim.lsp.buf.code_action, "Mantiq: Code Action")
                    map("n", "<leader>fm", function() vim.lsp.buf.format({ async = true }) end, "Mantiq: Format Document")
                    map("i", "<C-k>", vim.lsp.buf.signature_help, "Mantiq: Signature Help")
                end,
            })
        end,
    })
end

return M
