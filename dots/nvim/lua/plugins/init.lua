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

    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
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
            {import = "plugins.specs"},
            {import = "plugins.plugins"},
        },
        -- defaults = {
        --     lazy = false,
        -- }
        git = {
            timeout = 600, -- kill processes that take more than 2 minutes
        },
    })
    -- require("lazy").setup("plugins")
end

return M
