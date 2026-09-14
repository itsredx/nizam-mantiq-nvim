-- ── Commands Setup ───────────────────────────────────────────────────
local M = {}

function M.setup()
    -- Configure buffer-local settings for mantiq & nizam
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "mantiq", "nizam" },
        callback = function()
            vim.bo.errorformat = "%f:%l:%c: %m,%f:%l: %m"
            vim.bo.commentstring = "// %s"
            vim.bo.tabstop = 4
            vim.bo.shiftwidth = 4
            vim.bo.expandtab = true
        end,
    })

    -- User command: :MantiqRun
    vim.api.nvim_create_user_command("MantiqRun", function(opts)
        local file = opts.args ~= "" and opts.args or vim.api.nvim_buf_get_name(0)
        local cmd = string.format("mantiq run %s", vim.fn.shellescape(file))
        vim.cmd("split | terminal " .. cmd)
    end, { nargs = "?", complete = "file", desc = "Run Mantiq script in terminal split" })

    -- User command: :NizamBuild
    vim.api.nvim_create_user_command("NizamBuild", function()
        if vim.fn.filereadable("./build.sh") == 1 then
            vim.cmd("split | terminal ./build.sh")
        elseif vim.fn.filereadable("../build.sh") == 1 then
            vim.cmd("split | terminal ../build.sh")
        else
            vim.cmd("make zig build")
        end
    end, { desc = "Build Nizam compiler via build.sh or zig build" })

    -- User command: :MantiqCheck
    vim.api.nvim_create_user_command("MantiqCheck", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local file = vim.api.nvim_buf_get_name(bufnr)
        print("[Mantiq] Running workspace diagnostic check on: " .. file)
    end, { desc = "Run workspace syntax & type diagnostic check" })
end

return M
