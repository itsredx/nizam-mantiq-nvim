-- ── Icons ─────────────────────────────────────────────────────────────
local M = {}

--- Get theme-appropriate icon colors based on vim.o.background
-- @return table
local function get_theme_colors()
    local is_light = (vim.o.background == "light")
    if is_light then
        return {
            mq = { color = "#005F87", cterm_color = "24", hl = "MiniIconsBlue" },
            nz = { color = "#2E7D32", cterm_color = "28", hl = "MiniIconsGreen" },
        }
    else
        return {
            mq = { color = "#88C0D0", cterm_color = "67", hl = "MiniIconsCyan" },
            nz = { color = "#A3BE8C", cterm_color = "108", hl = "MiniIconsGreen" },
        }
    end
end

--- Apply icon settings for nvim-web-devicons and mini.icons
local function update_icons()
    local colors = get_theme_colors()

    -- Update nvim-web-devicons
    local has_devicons, devicons = pcall(require, "nvim-web-devicons")
    if has_devicons then
        devicons.set_icon({
            mq = {
                icon = "󰛄",
                color = colors.mq.color,
                cterm_color = colors.mq.cterm_color,
                name = "Mantiq",
            },
            nz = {
                icon = "󰛅",
                color = colors.nz.color,
                cterm_color = colors.nz.cterm_color,
                name = "Nizam",
            },
        })

        -- Directly mutate devicons internal table if present to prevent caching delays
        local icons_tbl = devicons.get_icons()
        if type(icons_tbl) == "table" then
            icons_tbl["mq"] = { icon = "󰛄", color = colors.mq.color, cterm_color = colors.mq.cterm_color, name = "Mantiq" }
            icons_tbl["nz"] = { icon = "󰛅", color = colors.nz.color, cterm_color = colors.nz.cterm_color, name = "Nizam" }
        end
    end

    -- Update mini.icons
    local has_mini, mini_icons = pcall(require, "mini.icons")
    if has_mini and type(mini_icons.tweak_lsp_kind) == "function" then
        pcall(function()
            if mini_icons.config and mini_icons.config.extension then
                mini_icons.config.extension.mq = { glyph = "󰛄", hl = colors.mq.hl }
                mini_icons.config.extension.nz = { glyph = "󰛅", hl = colors.nz.hl }
            end
        end)
    end
end

--- Setup devicon mappings and background change autocommand
function M.setup()
    update_icons()

    -- Listen for background theme switches (dark <-> light)
    vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "background",
        callback = function()
            update_icons()
        end,
    })
end

-- Run update_icons immediately on load to ensure early-loading file managers catch the icons
update_icons()

return M
