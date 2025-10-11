local M = {}

M.events = {
    OpenFile = { "BufReadPost", "BufNewFile" },
    InsertMode = { "InsertEnter" },
    EnterWindow = { "BufEnter" }, -- BufEnter is kinda not lazy
    CursorMove = { "CursorMoved" },
    Modified = { "TextChanged", "TextChangedI" },
}

M.setup = function()
    -- Use this to change pack location for architecture
    -- local packloc, packloc_count = vim.opt.packpath._value:gsub("/site", "/site_arm")
    -- print(packloc)

    ----------------------
    --  LAZY BOOTSTRAP  --
    ----------------------

    -- Bootstrap lazy.nvim
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                { out, "WarningMsg" },
                { "\nPress any key to exit..." },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end
    end
    vim.opt.rtp:prepend(lazypath)

    -- If we can't install plugins, don't bother
    vim.g.plugins_installed = vim.fn.has("nvim-0.11.2") ~= 0
    if not vim.g.plugins_installed then
        vim.notify("Neovim v0.11.2 is required for our packages to work", vim.log.levels.ERROR)
        return
    end

    require("lazy").setup({
        spec = {
            -- Plugin groups
            { import = "plugins.specs" },
            -- Individual plugin configuration
            { import = "plugins.plugins" },
        },
        -- defaults = {
        --     lazy = false,
        -- }
        git = {
            timeout = 600, -- kill processes that take more than 2 minutes
        },
    })
end

return M
