-- ── Assets ─────────────────────────────────────────────────────────────
local M = {}

--- Get the plugin root directory path
-- @return string
local function get_plugin_root()
    local source = debug.getinfo(1, "S").source:sub(2)
    local path = vim.fn.fnamemodify(source, ":h:h:h")
    return path
end

--- Get absolute filepath for specified asset
-- @param lang string "mantiq" or "nizam"
-- @param variant string "auto", "dark", "light", "icon", "icon_dark", or "icon_light"
-- @return string
function M.get_path(lang, variant)
    lang = (lang or "mantiq"):lower()
    variant = (variant or "auto"):lower()

    if variant == "auto" then
        variant = (vim.o.background == "light") and "light" or "dark"
    end

    local root = get_plugin_root()
    if variant == "icon" then
        return root .. "/assets/" .. lang .. "/icon.png"
    elseif variant == "icon_light" then
        return root .. "/assets/" .. lang .. "/icon_light.png"
    elseif variant == "icon_dark" then
        return root .. "/assets/" .. lang .. "/icon_dark.png"
    elseif variant == "light" then
        local name = lang:sub(1,1):upper() .. lang:sub(2) .. "_Light.png"
        return root .. "/assets/" .. lang .. "/" .. name
    else
        local name = lang:sub(1,1):upper() .. lang:sub(2) .. "_Dark.png"
        return root .. "/assets/" .. lang .. "/" .. name
    end
end

--- ASCII logos for terminal buffer display
M.ascii = {
    mantiq = {
        "  ███╗   ███╗ █████╗ ███╗   ██╗████████╗██╗ ██████╗ ",
        "  ████╗ ████║██╔══██╗████╗  ██║╚══██╔══╝██║██╔═══██╗",
        "  ██╔████╔██║███████║██╔██╗ ██║   ██║   ██║██║   ██║",
        "  ██║╚██╔╝██║██╔══██║██║╚██╗██║   ██║   ██║██║▄▄ ██║",
        "  ██║ ╚═╝ ██║██║  ██║██║ ╚████║   ██║   ██║╚██████╔╝",
        "  ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝ ╚══▀▀═╝ ",
    },
    nizam = {
        "  ███╗   ██╗██╗███████╗ █████╗ ███╗   ███╗",
        "  ████╗  ██║██║╚══███╔╝██╔══██╗████╗ ████║",
        "  ██╔██╗ ██║██║  ███╔╝ ███████║██╔████╔██║",
        "  ██║╚██╗██║██║ ███╔╝  ██╔══██║██║╚██╔╝██║",
        "  ██║ ╚████║██║███████╗██║  ██║██║ ╚═╝ ██║",
        "  ╚═╝  ╚═══╝╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝",
    },
}

--- Display Mantiq & Nizam logo banner in a floating buffer
function M.show_logo()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "filetype", "mantiq-logo")

    local current_mode = vim.o.background:upper()
    local lines = {
        "",
        "  === MANTIQ & NIZAM LANGUAGE SUPPORT (" .. current_mode .. " THEME) ===",
        "",
    }

    for _, l in ipairs(M.ascii.mantiq) do
        table.insert(lines, l)
    end
    table.insert(lines, "")
    for _, l in ipairs(M.ascii.nizam) do
        table.insert(lines, l)
    end

    table.insert(lines, "")
    table.insert(lines, "  PNG Assets Path (Current Theme: " .. current_mode .. "):")
    table.insert(lines, "  - Mantiq (Active): " .. M.get_path("mantiq", "auto"))
    table.insert(lines, "  - Nizam (Active):  " .. M.get_path("nizam", "auto"))
    table.insert(lines, "  - Mantiq Light:    " .. M.get_path("mantiq", "light"))
    table.insert(lines, "  - Mantiq Dark:     " .. M.get_path("mantiq", "dark"))
    table.insert(lines, "  - Nizam Light:     " .. M.get_path("nizam", "light"))
    table.insert(lines, "  - Nizam Dark:      " .. M.get_path("nizam", "dark"))
    table.insert(lines, "")

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local width = 64
    local height = #lines + 2
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        style = "minimal",
        border = "rounded",
        title = " Mantiq & Nizam ",
        title_pos = "center",
    })

    vim.api.nvim_buf_add_highlight(buf, -1, "Title", 1, 0, -1)
end

return M
