local M = {}    -- Global to return
local _map = {} -- Local table to store config functions

------------------------------------------------------------------------
--                              HELPERS                               --
------------------------------------------------------------------------
-- TODO: consolidate these functions
local default_key_options = {noremap = true, silent = true}

local function map(mode, lhs, rhs, opts)
    local options = default_key_options
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    if type(lhs) == "string" then
        vim.keymap.set(mode, lhs, rhs, options)
    elseif type(lhs) == "table" then
        for _,key in pairs(lhs) do
            vim.keymap.set(mode, key, rhs, options)
        end
    end
end

local function pmap(mode, lhs, rhs, opts)
    if vim.g.plugins_installed then
        map(mode, lhs, rhs, opts)
    end
end

local function Opt(desc)
    local opt_desc = default_key_options

    if desc then
        opt_desc = vim.tbl_extend("force", default_key_options, {
            desc = desc
        })
    end

    return opt_desc
end

------------------------------------------------------------------------
--                                MISC                                --
------------------------------------------------------------------------
_map.misc = function()
    ----------------------------------
    --        COPY & PASTE          --
    ----------------------------------
    -- dont copy any deleted text , this is disabled by default so uncomment the below mappings if you want them
    --map("n", "dd", [=[ "_dd ]=], opt)
    --map("v", "dd", [=[ "_dd ]=], opt)
    map("v", "x", [=[ "_x ]=])

    -- OPEN TERMINALS --
    --map("n", "<C-l>", [[<Cmd>vnew term://bash <CR>]], opt) -- term over right
    --map("n", "<C-x>", [[<Cmd> split term://bash | resize 10 <CR>]], opt) --  term bottom
    --map("n", "<C-t>t", [[<Cmd> tabnew | term <CR>]], opt) -- term newtab

    ----------------------------------
    --  BURN ARROWS and PGUP/PGDWN  --
    ----------------------------------
    -- map("n", "<Up>", "<Nop>", {})
    -- map("n", "<Left>", "<Nop>", {})
    -- map("n", "<Right>", "<Nop>", {})
    -- map("n", "<Down>", "<Nop>", {})
    map("n", "<PageUp>", "<Nop>", {})
    map("n", "<PageDown>", "<Nop>", {})
    --
    -- map("i", "<Up>", "<Nop>", {})
    -- map("i", "<Left>", "<Nop>", {})
    -- map("i", "<Right>", "<Nop>", {})
    -- map("i", "<Down>", "<Nop>", {})
    map("i", "<PageUp>", "<Nop>", {})
    map("i", "<PageDown>", "<Nop>", {})
end

------------------------------------------------------------------------
--                             NAVIGATION                             --
------------------------------------------------------------------------
_map.navigation = function()

    -----------------
    --  NAVIGATOR  --
    -----------------
    local has_navigator, navigator = pcall(require, 'Navigator')
    if has_navigator then
        map({'n','t'}, {"<C-h>", "<C-Left>"},  navigator.left,     Opt("Navigation: Left a window"))
        map({'n','t'}, {"<C-k>", "<C-Up>"},    navigator.up,       Opt("Navigation: Up a window"))
        map({'n','t'}, {"<C-l>", "<C-Right>"}, navigator.right,    Opt("Navigation: Right a window"))
        map({'n','t'}, {"<C-j>", "<C-Down>"},  navigator.down,     Opt("Navigation: Down a window"))
        map({'n','t'}, "<A-p>",                navigator.previous, Opt("Navigation: Go to previous window"))
    else
        map({'n','t'}, {"<C-h>", "<C-Left>"},  "<C-w>h",           Opt("Navigation: Left a window"))
        map({'n','t'}, {"<C-k>", "<C-Up>"},    "<C-w>k",           Opt("Navigation: Up a window"))
        map({'n','t'}, {"<C-l>", "<C-Right>"}, "<C-w>l",           Opt("Navigation: Right a window"))
        map({'n','t'}, {"<C-j>", "<C-Down>"},  "<C-w>j",           Opt("Navigation: Down a window"))
        map({'n','t'}, "<A-p>",                "<C-w>p",           Opt("Navigation: Go to previous window"))
    end

    -----------------------
    --  MODE NAVIGATION  --
    -----------------------
    map('i', "jk", "<Esc>", Opt("Navigation: Exit insert mode"))
    map('i', "zx", "<Esc>", Opt("Navigation: Exit insert mode"))

    ------------------------
    --  SPLIT NAVIGATION  --
    ------------------------
    map('n', "<C-w>%", ":vsplit<CR>", Opt("Navigation: Vertical Split"))
    map('n', "<C-w>\"", ":split<CR>", Opt("Navigation: Horizontal Split"))

    -----------------
    --  CLIPBOARD  --
    -----------------
    -- N/A

    ------------
    --  LEAP  --
    ------------
    if vim.g.plugins_installed then
        require("leap").create_default_mappings()
    end -- vim.g.plugins_installed

    ---------------
    --  HARPOON  --
    ---------------
    if vim.g.plugins_installed then
        local h = nil
        local hp = function()
            if h == nil then
                h = require("harpoon")
            end
            return h
        end

        local hp_telescope = function(hp_files)
            local conf = require("telescope.config").values
            local file_paths = {}
            for _, item in ipairs(hp_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
            }):find()
        end

        map("n", "<Leader><Leader>o",
            function() hp_telescope(hp():list()) end,
            Opt("Show Harpoon (Telescope)")
        )
        map("n", "<Leader>o",
            function() hp().ui:toggle_quick_menu(hp():list()) end,
            Opt("Show Harpoon")
        )

        map("n", "<Leader><Leader>a",
            function() hp():list():append() end,
            Opt("Append file to Harpoon")
        )

        for i=1,10 do
            local key = i
            if i == 10 then
                key = 0
            end

            map("n", "<Leader><Leader>"..key,
                function() hp():list():select(i) end,
                Opt("Harpoon file "..i)
            )
        end
    end
end

M.harpoon_extend = function()
    local harpoon = require("harpoon")
    -- Add keybinds to the harpoon picker
    harpoon:extend({
        UI_CREATE = function(cx)
            for i=1,10 do
                local key = i
                if i == 10 then
                    key = 0
                end

                map("n", tostring(key),
                    function() harpoon:list():select(i) end,
                    { buffer = cx.bufnr }
                )
            end
            map("n", "%",
                function() harpoon.ui:select_menu_item({ vsplit = true }) end,
                { buffer = cx.bufnr }
            )

            map("n", "\"",
                function() harpoon.ui:select_menu_item({ split = true }) end,
                { buffer = cx.bufnr }
            )
        end
    })
end

------------------------------------------------------------------------
--                              DISPLAY                               --
------------------------------------------------------------------------
_map.display = function()
    -----------------------
    --  HIDE HIGHLIGHTS  --
    -----------------------
    map("n", "<Leader>n", ":noh<CR>", Opt("Display: Hide \"find\" highlight"))

    ----------------
    --  COMMENTS  --
    ----------------
    -- This is mapped in the Comment setups

    ------------------
    --  COMPLETION  --
    ------------------
    -- This is mapped in plugins.cmp

    -----------------
    --  NVIM TREE  --
    -----------------
    pmap("n", "<Leader>t", ":NvimTreeToggle<CR>", Opt("Display: Show the file tree"))

    --------------
    --  FORMAT  --
    --------------
    -- pmap("n", "<Leader>m", ":Neoformat<CR>", Opt("Display: Format the current file"))
    pmap("n", "<Leader>!", ":ToggleAlternate<CR>", Opt("Toggle boolean"))

    -----------------
    --  DASHBOARD  --
    -----------------
    -- pmap("n", "<Leader>ft", [[<Cmd> TodoTelescope<CR>]], Opt("Display: Show all TODOs in current project"))
    -- map("n", "<Leader>db", [[<Cmd> Dashboard<CR>]], opt)
    -- map("n", "<Leader>fn", [[<Cmd> DashboardNewFile<CR>]], opt)
    -- map("n", "<Leader>bm", [[<Cmd> DashboardJumpMarks<CR>]], opt)
    -- map("n", "<C-s>l", [[<Cmd> SessionLoad<CR>]], opt)
    -- map("n", "<C-s>s", [[<Cmd> SessionSave<CR>]], opt)
end

------------------------------------------------------------------------
--                              PROJECT                               --
------------------------------------------------------------------------
_map.project = function()
    ------------------
    --  TELESCROPE  --
    ------------------
    if vim.g.plugins_installed then
        local ts = {
            builtin    = function() return require('telescope.builtin') end,
            extensions = function() return require('telescope').extensions end,
            grep_fuzzy = function()
                require('telescope.builtin').grep_string({
                    prompt_title = "Fuzzy Find",
                    shorten_path = true,
                    word_match = "-w",
                    only_sort_text = true,
                    search = ''
                })
            end,
            grep_string = function()
                require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ")})
            end
        }

        -- File pickers
        vim.keymap.set('n', '<Leader>f',  ts.builtin().find_files,                 Opt("Telescope: Fuzzy file finder"))
        vim.keymap.set('n', '<Leader>b',  ts.builtin().buffers,                    Opt("Telescope: Show active buffers"))

        -- Extra pickers
        vim.keymap.set('n', '<Leader>pz', ts.grep_fuzzy,                           Opt("Telescope: Fuzzy finder"))
        vim.keymap.set('n', '<Leader>pm', ts.extensions().media_files.media_files, Opt("Telescope: Show media files"))
        vim.keymap.set('n', '<Leader>ph', ts.builtin().help_tags,                  Opt("Telescope: interactive help menu"))
        vim.keymap.set('n', '<Leader>po', ts.builtin().oldfiles,                   Opt("Telescope: Previously edited files"))

        -- Global search/help
        vim.keymap.set('n', '<Leader>/',  ts.builtin().live_grep,                  Opt("Telescope: Live grep"))
        vim.keymap.set('n', '<Leader>,',  ts.grep_string,                          Opt("Telescope: Grep string (statusline)"))
        vim.keymap.set('n', '<Leader>?',  ts.builtin().keymaps,                    Opt("Telescope: Show all keybinds"))
        vim.keymap.set('n', '<Leader>*',  ts.builtin().grep_string,                Opt("Telescope: Find word under cursor"))
        vim.keymap.set('n', '<Leader>d',  ts.builtin().lsp_document_symbols,       Opt("Telescope: Show LSP symbols in current file"))
    end

    -----------------
    --  GIT SIGNS  --
    -----------------
    pmap("n", "<Leader>hb", '<cmd>lua require"gitsigns".blame_line()<CR>', Opt("Git: Blame this line"))
    pmap("n", "<Leader>hs", '<cmd>Telescope git_status<CR>',               Opt("Git: Git status"))
    pmap("n", "<Leader>hc", '<cmd>Telescope git_commits<CR>',              Opt("Git: Git commits"))

    --------------
    --  WINDOW  --
    --------------
    map("n", "<Leader>w", "<C-w>", {remap = true; desc = "Window operations"})
end

------------------------------------------------------------------------
--                                LSP                                 --
------------------------------------------------------------------------
M.lsp_configure = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- This is a bit hacky, but we have to resolve `vim.lsp.buf` at runtime
    -- so the operation completes on the active buffer NOT. If we pass
    -- `vim.lsp.buf.declaration`, it will resolve at mapping time, not at
    -- run time.
    local function buf_run(str)
        return "<Cmd>lua "..str.."<CR>"
    end

    local lOpts = function(desc) return Opt("LSP: "..desc) end

    -- goto bindings
    buf_set_keymap("n", "gD",        buf_run("vim.lsp.buf.declaration()"),                                lOpts("goto declaration"))
    buf_set_keymap("n", "gd",        buf_run("vim.lsp.buf.definition()"),                                 lOpts("goto definition"))
    buf_set_keymap("n", "gi",        buf_run("vim.lsp.buf.implementation()"),                             lOpts("goto implementation"))
    buf_set_keymap("n", "gl",        buf_run("vim.lsp.buf.type_definition()"),                            lOpts("goto type definition"))
    buf_set_keymap("n", "gr",        buf_run("vim.lsp.buf.references()"),                                 lOpts("see all object references"))

    -- Hints, diagnostics, etc..
    buf_set_keymap("n", "<Leader>k",  buf_run("vim.lsp.buf.signature_help()"),                             lOpts("signature"))
    buf_set_keymap("n", "<Leader>K",  buf_run("vim.lsp.buf.hover()"),                                      lOpts("start hover"))
    buf_set_keymap("n", "<Leader>e",  buf_run("vim.diagnostic.open_float()"),                              lOpts("open diagnostic float (window)"))

    -- Usage jumping
    buf_set_keymap("n", "<Leader>l[", buf_run("vim.lsp.diagnostic.goto_prev()"),                           lOpts("goto previous use"))
    buf_set_keymap("n", "<Leader>l]", buf_run("vim.lsp.diagnostic.goto_next()"),                           lOpts("goto next use"))

    -- Workspace operations
    buf_set_keymap("n", "<Leader>lwa", buf_run("vim.lsp.buf.add_workspace_folder()"),                       lOpts("add workspace folder"))
    buf_set_keymap("n", "<Leader>lwr", buf_run("vim.lsp.buf.remove_workspace_folder()"),                    lOpts("remove workspace folder"))
    buf_set_keymap("n", "<Leader>lwl", buf_run("print(vim.inspect(vim.lsp.buf.list_workspace_folders()))"), lOpts("list workspace folders"))

    -- Workspace operations
    buf_set_keymap("n", "<Leader>lr", buf_run("vim.lsp.buf.rename()"),                                     lOpts("rename LSP object"))
    buf_set_keymap("n", "<Leader>lq", buf_run("vim.lsp.diagnostic.set_loclist()"),                         lOpts("set the location list ???"))

    -- Set some keybinds conditional on server capabilities
    if client.server_capabilities.document_formatting then
        buf_set_keymap("n", "<Leader>lf", buf_run("vim.lsp.buf.formatting()"),       lOpts("format buffer"))
    elseif client.server_capabilities.document_range_formatting then
        buf_set_keymap("n", "<Leader>lr", buf_run("vim.lsp.buf.range_formatting()"), lOpts("format range"))
    end

end

------------------------------------------------------------------------
--                              CONFIG                                --
------------------------------------------------------------------------
M.setup = function()
    _map.misc()
    _map.navigation()
    _map.display()
    _map.project()
end

-----------------
--  mini.clue  --
-----------------
M.clue = {
    -- Clue popup triggers
    triggers = {
        -- Leader triggers
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },

        -- Built-in completion
        { mode = 'i', keys = '<C-x>' },

        -- `g` key
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },

        -- Marks
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },

        -- Registers
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },

        -- Window commands
        { mode = 'n', keys = '<C-w>' },
        -- { mode = 'n', keys = '<Leader>w' },

        -- `z` key
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },
    },
    -- Additional clue hints
    clues = {
        { mode = 'n', keys = '<Leader>l',  desc = 'LSP: Extra'},
        { mode = 'n', keys = '<Leader>lw', desc = 'Workspace'},
        { mode = 'n', keys = '<Leader>h',  desc = 'git'},
        { mode = 'n', keys = '<Leader>s',  desc = 'Surround'},
        { mode = 'n', keys = '<Leader>p',  desc = 'Misc. Pickers'},
        { mode = 'n', keys = '<Leader><Leader>',  desc = 'Harpoon'},
    }
}

return M
