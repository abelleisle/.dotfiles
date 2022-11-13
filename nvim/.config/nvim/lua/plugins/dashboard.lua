local M = {}

M.config = function()
    -- local g = vim.g
    -- local fn = vim.fn
    -- local db = require('dashboard')
    --
    -- local plugins_count = fn.len(fn.globpath("~/.local/share/nvim/site/pack/packer/start", "*", 0, 1))
    --
    -- g.dashboard_disable_at_vimenter = 1 -- dashboard is disabled by default
    -- db.hide_statusline = 1
    -- g.dashboard_default_executive = "telescope"
    -- db.custom_header = {
    --     "                                   ",
    --     "                                   ",
    --     "                                   ",
    --     "   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ",
    --     "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
    --     "          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ",
    --     "           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
    --     "          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
    --     "   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
    --     "  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
    --     " ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
    --     " ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ",
    --     "    ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆       ",
    --     "       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ",
    --     "                                   "
    -- }
    --
    -- db.custom_center = {
    --     a = {description = {"  Find File                 SPC f f"}, command = "Telescope find_files"},
    --     b = {description = {"  Recents                   SPC f o"}, command = "Telescope oldfiles"},
    --     c = {description = {"  Find Word                 SPC f w"}, command = "Telescope live_grep"},
    --     d = {description = {"洛 New File                  SPC f n"}, command = "DashboardNewFile"},
    --     e = {description = {"  Bookmarks                 SPC b m"}, command = "Telescope marks"},
    --     f = {description = {"  Load Last Session         SPC s l"}, command = "SessionLoad"}
    -- }
    --
    -- db.custom_footer = {
    --     "   ",
    --     -- "NvChad Loaded " .. plugins_count .. " plugins",
    --     "NvChad v0.5"
    -- }
end

return M
