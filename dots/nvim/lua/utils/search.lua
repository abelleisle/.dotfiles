local highlight_timer = nil

-- ensure n and N highlight for only a brief time
local function searchAndOpenFold(key)
    vim.cmd('normal! ' .. key)

    if string.find(vim.o.foldopen, "search") and vim.fn.foldclosed('.') ~= -1 then
        vim.cmd('normal! zv')
    end

    require('utils.search').turn_off_highlight_after_expiration()
end


local M = {
    setup = function ()
        if vim.g.search_highlight_timeout_ms == nil then
            vim.g.search_highlight_timeout_ms = 1000
        end

        vim.keymap.set('n', 'n', function() searchAndOpenFold('n') end, {noremap = true, silent = true})
        vim.keymap.set('n', 'N', function() searchAndOpenFold('N') end, {noremap = true, silent = true})

        -- ensure the initial lookup using / or ? highlight for only a brief time
        vim.api.nvim_create_autocmd("CmdlineLeave", {
            callback = function()
                local cmd_type = vim.fn.expand("<afile>")
                vim.schedule(
                    function()
                        if cmd_type ~= nil and (cmd_type == '/' or cmd_type == '?') then
                            require('utils.search').turn_off_highlight_after_expiration()
                        end
                    end
                )
            end
        })
    end,

    turn_off_highlight_after_expiration = function()
        -- Cancel the existing timer if it exists
        if highlight_timer then
            vim.fn.timer_stop(highlight_timer)
        end

        local highlight_expiration_time = vim.g.search_highlight_timeout_ms

        -- Set a new timer
        highlight_timer = vim.fn.timer_start(highlight_expiration_time, function()
            vim.cmd('nohlsearch')
        end)
    end,
}

return M
