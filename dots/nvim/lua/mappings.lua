local M = {} -- Global to return
local _map = {} -- Local table to store config functions

------------------------------------------------------------------------
--                              HELPERS                               --
------------------------------------------------------------------------
-- TODO: consolidate these functions
local default_key_options = { noremap = true, silent = true }

local function map(mode, lhs, rhs, opts)
    local options = default_key_options
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    if type(lhs) == "string" then
        vim.keymap.set(mode, lhs, rhs, options)
    elseif type(lhs) == "table" then
        for _, key in pairs(lhs) do
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
            desc = desc,
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

    ----------------------------------
    --     INDENT AND BRACES        --
    ----------------------------------
    -- Indent selected block and wrap with braces
    local indent_and_wrap_braces = require("utils").indent.indent_and_wrap_braces
    map({ "n", "x" }, "<leader>sb", indent_and_wrap_braces, Opt("Wrap block with braces"))
end

------------------------------------------------------------------------
--                             NAVIGATION                             --
------------------------------------------------------------------------
_map.navigation = function()
    -----------------
    --  NAVIGATOR  --
    -----------------
    local has_navigator, navigator = pcall(require, "Navigator")
    if has_navigator then
        map({ "n", "t" }, { "<A-h>", "<A-Left>" }, navigator.left, Opt("Navigation: Left a window"))
        map({ "n", "t" }, { "<A-k>", "<A-Up>" }, navigator.up, Opt("Navigation: Up a window"))
        map({ "n", "t" }, { "<A-l>", "<A-Right>" }, navigator.right, Opt("Navigation: Right a window"))
        map({ "n", "t" }, { "<A-j>", "<A-Down>" }, navigator.down, Opt("Navigation: Down a window"))
        map({ "n", "t" }, "<A-p>", navigator.previous, Opt("Navigation: Go to previous window"))
    else
        map({ "n", "t" }, { "<A-h>", "<A-Left>" }, "<C-w>h", Opt("Navigation: Left a window"))
        map({ "n", "t" }, { "<A-k>", "<A-Up>" }, "<C-w>k", Opt("Navigation: Up a window"))
        map({ "n", "t" }, { "<A-l>", "<A-Right>" }, "<C-w>l", Opt("Navigation: Right a window"))
        map({ "n", "t" }, { "<A-j>", "<A-Down>" }, "<C-w>j", Opt("Navigation: Down a window"))
        map({ "n", "t" }, "<A-p>", "<C-w>p", Opt("Navigation: Go to previous window"))
    end

    ------------------------------
    -- LSP Signature Navigation --
    ------------------------------
    local has_noice, noice = pcall(require, "noice.lsp")
    if has_noice then
        vim.keymap.set({ "n", "i", "s" }, "<c-d>", function()
            if not noice.scroll(4) then
                return "<c-d>"
            end
        end, { silent = true, expr = true })
        vim.keymap.set({ "n", "i", "s" }, "<c-u>", function()
            if not noice.scroll(-4) then
                return "<c-u>"
            end
        end, { silent = true, expr = true })
    end

    -----------------------
    --  MODE NAVIGATION  --
    -----------------------
    map("i", "jk", "<Esc>", Opt("Navigation: Exit insert mode"))
    map("i", "zx", "<Esc>", Opt("Navigation: Exit insert mode"))

    ------------------------
    --  SPLIT NAVIGATION  --
    ------------------------
    map("n", "<C-w>%", ":vsplit<CR>", Opt("Navigation: Vertical Split"))
    map("n", '<C-w>"', ":split<CR>", Opt("Navigation: Horizontal Split"))

    -----------------
    --  CLIPBOARD  --
    -----------------
    -- N/A

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

            require("telescope.pickers")
                .new({}, {
                    prompt_title = "Harpoon",
                    finder = require("telescope.finders").new_table({
                        results = file_paths,
                    }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                })
                :find()
        end

        map("n", "<Leader>ro", function()
            hp_telescope(hp():list())
        end, Opt("Show Harpoon (Telescope)"))
        map("n", "<Leader>o", function()
            hp().ui:toggle_quick_menu(hp():list())
        end, Opt("Show Harpoon"))

        map("n", "<Leader>ra", function()
            local path = require("plenary.path")
            local letter = vim.fn.input("Enter letter for this buffer: ")
            if letter and letter ~= "" and letter:match("^[a-zA-Z]$") then
                local buf_name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
                local root = vim.loop.cwd()
                local np = path:new(buf_name):make_relative(root)
                hp():list():add({
                    value = np,
                    context = { row = 1, col = 0 },
                    letter = letter:lower(),
                })
                vim.notify("Added to harpoon with letter: " .. letter:lower())
            else
                vim.notify("Invalid letter. Please enter a single letter.", vim.log.levels.WARN)
            end
        end, Opt("Add file to Harpoon with letter"))

        local letters = "abcdefghijklmnopqrstuvwxyz"
        for i = 1, #letters do
            local letter = letters:sub(i, i)
            map("n", "<Leader><Leader>" .. letter, function()
                local list = hp():list()
                for idx, item in ipairs(list.items) do
                    if item.letter == letter then
                        hp():list():select(idx)
                        return
                    end
                end
                vim.notify("No harpoon entry found for letter: " .. letter, vim.log.levels.WARN)
            end, Opt("Harpoon file with letter " .. letter))
        end
    end
end

M.harpoon_extend = function()
    local harpoon = require("harpoon")
    -- Add keybinds to the harpoon picker
    harpoon:extend({
        UI_CREATE = function(cx)
            local list = harpoon:list()
            local length = list:length()
            for i = 1, length do
                local key = i
                map("n", tostring(key), function()
                    list:select(i)
                end, { buffer = cx.bufnr })
            end
            map("n", "%", function()
                harpoon.ui:select_menu_item({ vsplit = true })
            end, { buffer = cx.bufnr })

            map("n", '"', function()
                harpoon.ui:select_menu_item({ split = true })
            end, { buffer = cx.bufnr })
        end,
    })
end

------------------------------------------------------------------------
--                              DISPLAY                               --
------------------------------------------------------------------------
_map.display = function()
    -----------------------
    --  HIDE HIGHLIGHTS  --
    -----------------------
    map("n", "<Leader>h", ":noh<CR>", Opt('Display: Hide "find" highlight'))

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
    -- Telescope keybinds are now defined in lua/plugins/plugins/telescope.lua
    -- for lazy loading on keymap trigger

    -----------------
    --  GIT SIGNS  --
    -----------------
    pmap("n", "<Leader>vb", '<cmd>lua require"gitsigns".blame_line()<CR>', Opt("Git: Blame this line"))
    -- Git status and commits are now mapped in telescope.lua

    ----------------
    -- GIT Linker --
    ----------------
    local gl_func = function(range)
        return function()
            require("gitlinker").get_buf_range_url(range, {
                action_callback = require("gitlinker.actions").copy_to_clipboard,
            })
            if range == "v" then
                vim.fn.feedkeys(":", "nx") -- Return to normal mode
            end
        end
    end

    pmap("n", "<leader>vl", gl_func("n"), Opt("Git: Copy Permalink"))
    pmap("x", "<leader>vl", gl_func("v"), Opt("Git: Copy Permalink"))

    --------------
    --  WINDOW  --
    --------------
    map("n", "<Leader>w", "<C-w>", { remap = true, desc = "Window operations" })
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
        return "<Cmd>lua " .. str .. "<CR>"
    end

    local lOpts = function(desc)
        return Opt("LSP: " .. desc)
    end

    -- goto bindings
    buf_set_keymap("n", "gD", buf_run("vim.lsp.buf.declaration()"), lOpts("goto declaration"))
    buf_set_keymap("n", "gd", buf_run("vim.lsp.buf.definition()"), lOpts("goto definition"))
    buf_set_keymap("n", "gi", buf_run("vim.lsp.buf.implementation()"), lOpts("goto implementation"))
    buf_set_keymap("n", "gl", buf_run("vim.lsp.buf.type_definition()"), lOpts("goto type definition"))
    buf_set_keymap("n", "gr", buf_run("vim.lsp.buf.references()"), lOpts("see all object references"))

    -- Hints, diagnostics, etc..
    buf_set_keymap("n", "<Leader>k", buf_run("vim.lsp.buf.signature_help()"), lOpts("signature"))
    buf_set_keymap("n", "<Leader>K", buf_run("vim.lsp.buf.hover()"), lOpts("start hover"))
    buf_set_keymap("n", "<Leader>e", buf_run("vim.diagnostic.open_float()"), lOpts("open diagnostic float (window)"))

    -- Usage jumping
    buf_set_keymap("n", "<Leader>l[", buf_run("vim.lsp.diagnostic.goto_prev()"), lOpts("goto previous use"))
    buf_set_keymap("n", "<Leader>l]", buf_run("vim.lsp.diagnostic.goto_next()"), lOpts("goto next use"))

    -- Workspace operations
    buf_set_keymap("n", "<Leader>lwa", buf_run("vim.lsp.buf.add_workspace_folder()"), lOpts("add workspace folder"))
    buf_set_keymap(
        "n",
        "<Leader>lwr",
        buf_run("vim.lsp.buf.remove_workspace_folder()"),
        lOpts("remove workspace folder")
    )
    buf_set_keymap(
        "n",
        "<Leader>lwl",
        buf_run("print(vim.inspect(vim.lsp.buf.list_workspace_folders()))"),
        lOpts("list workspace folders")
    )

    -- Workspace operations
    buf_set_keymap("n", "<Leader>lr", buf_run("vim.lsp.buf.rename()"), lOpts("rename LSP object"))
    buf_set_keymap("n", "<Leader>lq", buf_run("vim.lsp.diagnostic.set_loclist()"), lOpts("set the location list ???"))

    -- Set some keybinds conditional on server capabilities
    if client.server_capabilities.document_formatting then
        buf_set_keymap("n", "<Leader>lf", buf_run("vim.lsp.buf.formatting()"), lOpts("format buffer"))
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
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },

        -- Built-in completion
        { mode = "i", keys = "<C-x>" },

        -- `g` key
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },

        -- Marks
        { mode = "n", keys = "'" },
        { mode = "n", keys = "`" },
        { mode = "x", keys = "'" },
        { mode = "x", keys = "`" },

        -- Registers
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },

        -- Window commands
        { mode = "n", keys = "<C-w>" },
        -- { mode = 'n', keys = '<Leader>w' },

        -- `z` key
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
    },
    -- Additional clue hints
    clues = {
        { mode = "n", keys = "<Leader>l", desc = "LSP: Extra" },
        { mode = "n", keys = "<Leader>lw", desc = "Workspace" },
        { mode = "n", keys = "<Leader>v", desc = "VCS (git)" },
        { mode = "x", keys = "<Leader>v", desc = "VCS (git)" },
        { mode = "n", keys = "<Leader>s", desc = "Surround" },
        { mode = "x", keys = "<Leader>s", desc = "Surround" },
        { mode = "n", keys = "<Leader>p", desc = "Misc. Pickers" },
        { mode = "n", keys = "<Leader><Leader>", desc = "Harpoon" },
        { mode = "n", keys = "<Leader>a", desc = "Code Companion" },
        { mode = "v", keys = "<Leader>a", desc = "Code Companion" },
    },
}

------------
--  LEAP  --
------------
M.leap = {
    { "s", mode = { "n", "x", "o" }, desc = "Leap Forward to" },
    { "S", mode = { "n", "x", "o" }, desc = "Leap Backward to" },
    { "gs", mode = { "n", "x", "o" }, desc = "Leap from Windows" },
}

-----------------
--  TELESCOPE  --
-----------------
M.telescope = {
    -- File pickers
    {
        "<Leader>f",
        function()
            require("telescope.builtin").find_files()
        end,
        desc = "Telescope: Fuzzy file finder",
    },
    {
        "<Leader>b",
        function()
            require("telescope.builtin").buffers()
        end,
        desc = "Telescope: Show active buffers",
    },
    { "<Leader>n", M.grep_file, desc = "Telescope: Search current file" },

    -- Extra pickers
    { "<Leader>pz", M.grep_fuzzy, desc = "Telescope: Fuzzy finder" },
    {
        "<Leader>pm",
        function()
            require("telescope").extensions.media_files.media_files()
        end,
        desc = "Telescope: Show media files",
    },
    {
        "<Leader>ph",
        function()
            require("telescope.builtin").help_tags()
        end,
        desc = "Telescope: interactive help menu",
    },
    {
        "<Leader>po",
        function()
            require("telescope.builtin").oldfiles()
        end,
        desc = "Telescope: Previously edited files",
    },

    -- Global search/help
    {
        "<Leader>/",
        function()
            require("telescope.builtin").live_grep()
        end,
        desc = "Telescope: Live grep",
    },
    { "<Leader>,", M.grep_string, desc = "Telescope: Grep string (statusline)" },
    {
        "<Leader>?",
        function()
            require("telescope.builtin").keymaps()
        end,
        desc = "Telescope: Show all keybinds",
    },
    {
        "<Leader>*",
        function()
            require("telescope.builtin").grep_string()
        end,
        desc = "Telescope: Find word under cursor",
    },
    {
        "<Leader>d",
        function()
            require("telescope.builtin").lsp_document_symbols()
        end,
        desc = "Telescope: Show LSP symbols in current file",
    },

    -- Git pickers
    { "<Leader>vs", "<cmd>Telescope git_status<CR>", desc = "Git: Git status" },
    { "<Leader>vc", "<cmd>Telescope git_commits<CR>", desc = "Git: Git commits" },
}

return M
