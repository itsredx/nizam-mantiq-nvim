-- ── Commands ─────────────────────────────────────────────────────────
-- Auto-setup on load
require("mantiq").setup()

-- User command to display Mantiq & Nizam logos/assets
vim.api.nvim_create_user_command("MantiqLogo", function()
    require("mantiq.assets").show_logo()
end, { desc = "Display Mantiq & Nizam logos and asset paths" })
