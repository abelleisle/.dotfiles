local has_sessions, sessions = pcall(require, "mini.sessions")
if has_sessions then
    -- Stole this from mini.sessions
    local vim_has_stuff = function()
        -- Don't autoread session if Neovim is opened to show something. That is
        -- when at least one of the following is true:
        -- - Current buffer has any lines (something opened explicitly).
        -- NOTE: Usage of `line2byte(line('$') + 1) > 0` seemed to be fine, but it
        -- doesn't work if some automated changed was made to buffer while leaving it
        -- empty (returns 2 instead of -1). This was also the reason of not being
        -- able to test with child Neovim process from 'tests/helpers'.
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
        if #lines > 1 or (#lines == 1 and lines[1]:len() > 0) then
            return true
        end

        -- - Several buffers are listed (like session with placeholder buffers). That
        --   means unlisted buffers (like from `nvim-tree`) don't affect decision.
        local listed_buffers = vim.tbl_filter(function(buf_id)
            return vim.fn.buflisted(buf_id) == 1
        end, vim.api.nvim_list_bufs())
        if #listed_buffers > 1 then
            return true
        end

        -- - There are files in arguments (like `nvim foo.txt` with new file).
        if vim.fn.argc() > 0 then
            return true
        end

        return false
    end

    -- Start mini.sessions
    sessions.setup()

    -- Only open session if there is a session and vim has no args/files open
    local latest_session = sessions.get_latest()
    if latest_session ~= nil and not vim_has_stuff() then
        sessions.read()
    end
end
