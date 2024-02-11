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

-- dont copy any deleted text , this is disabled by default so uncomment the below mappings if you want them

--map("n", "dd", [=[ "_dd ]=], opt)
--map("v", "dd", [=[ "_dd ]=], opt)
map("v", "x", [=[ "_x ]=])

-- OPEN TERMINALS --
--map("n", "<C-l>", [[<Cmd>vnew term://bash <CR>]], opt) -- term over right
--map("n", "<C-x>", [[<Cmd> split term://bash | resize 10 <CR>]], opt) --  term bottom
--map("n", "<C-t>t", [[<Cmd> tabnew | term <CR>]], opt) -- term newtab

------------------------------------------------------------------------
--                             NAVIGATION                             --
------------------------------------------------------------------------

-----------------
--  NAVIGATOR  --
-----------------
local has_navigator, navigator = pcall(require, 'Navigator')
if has_navigator then
    navigator.setup({
        auto_save = 'nil',
        disable_on_zoom = true
    })

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
--vim.cmd("inoremap jk <Esc>")
map('i', "jk", "<Esc>", Opt("Navigation: Exit insert mode"))
map('i', "zx", "<Esc>", Opt("Navigation: Exit insert mode"))

------------------------
--  SPLIT NAVIGATION  --
------------------------
map('n', "<Leader>%", ":vsplit<CR>", Opt("Navigation: Vertical Split"))
map('n', "<Leader>\"", ":split<CR>", Opt("Navigation: Horizontal Split"))

-----------------
--  CLIPBOARD  --
-----------------

-- copy whole file content
map("n", "<C-a>", [[ <Cmd> %y+<CR>]], Opt("Navigation: Copy entire file to clipboard"))

------------
--  LEAP  --
------------

if vim.g.plugins_installed then
    local mini = {
        jump2d = require('mini.jump2d'),
        jump2d_char = function()
            local mj = require('mini.jump2d')
            return mj.start(mj.builtin_opts.single_character)
        end,
        jump2d_start = function()
            local mj = require("mini.jump2d")
            return mj.start(mj.builtin_opts.default)
        end,
        jump2d_line = function()
            local mj = require("mini.jump2d")
            return mj.start(mj.builtin_opts.line_start)
        end,
        jump2d_word = function()
            local mj = require("mini.jump2d")
            return mj.start(mj.builtin_opts.word_start)
        end,
        jump2d_twochar = function()
            local gettwocharstr = function()
                local _, char0 = pcall(vim.fn.getcharstr)
                local _, char1 = pcall(vim.fn.getcharstr)

                return char0..char1
            end
            local pattern = vim.pesc(gettwocharstr())

            local mj = require("mini.jump2d")
            return mj.start({
                spotter = mj.gen_pattern_spotter(pattern),
                allowed_lines   = {
                    cursor_before = true,
                    cursor_after = true,
                    blank = false,
                    fold = false,
                },
                allowed_windows = {
                    not_current = false
                }
            })
        end
    }

    vim.keymap.set({"n", "v"}, "s",                 mini.jump2d_twochar, Opt("Navigation: Jump to a 2-char pair"))
    vim.keymap.set({"n", "v"}, "<Leader><Leader>s", mini.jump2d_char,    Opt("Navigation: Jump to a single character"))
    vim.keymap.set({"n", "v"}, "<Leader><Leader>f", mini.jump2d_start,   Opt("Navigation: Jump to any object"))
    vim.keymap.set({"n", "v"}, "<Leader><Leader>l", mini.jump2d_line ,   Opt("Navigation: Jump to any line on screen"))
    vim.keymap.set({"n", "v"}, "<Leader><Leader>w", mini.jump2d_word ,   Opt("Navigation: Jump to any word"))
end -- vim.g.plugins_installed

------------------------------------------------------------------------
--                              DISPLAY                               --
------------------------------------------------------------------------

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
pmap("n", "<Leader>fm", ":Neoformat<CR>", Opt("Display: Format the current file"))

-----------------
--  DASHBOARD  --
-----------------

-- pmap("n", "<Leader>ft", [[<Cmd> TodoTelescope<CR>]], Opt("Display: Show all TODOs in current project"))
-- map("n", "<Leader>db", [[<Cmd> Dashboard<CR>]], opt)
-- map("n", "<Leader>fn", [[<Cmd> DashboardNewFile<CR>]], opt)
-- map("n", "<Leader>bm", [[<Cmd> DashboardJumpMarks<CR>]], opt)
-- map("n", "<C-s>l", [[<Cmd> SessionLoad<CR>]], opt)
-- map("n", "<C-s>s", [[<Cmd> SessionSave<CR>]], opt)

-----------------
--  TELESCOPE  --
-----------------

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

    --map("n", "<Leader>fw", [[<Cmd> Telescope live_grep<CR>]], opt)
    vim.keymap.set('n', '<Leader>ff', ts.builtin().live_grep,                  Opt("Telescope: Live grep"))
    vim.keymap.set('n', '<Leader>fz', ts.grep_fuzzy,                           Opt("Telescope: Fuzzy finder"))
    vim.keymap.set('n', '<Leader>gt', ts.builtin().git_status,                 Opt("Telescope: Git status"))
    vim.keymap.set('n', '<Leader>cm', ts.builtin().git_commits,                Opt("Telescope: Git commits"))
    vim.keymap.set('n', '<C-p>',      ts.builtin().find_files,                 Opt("Telescope: Fuzzy file finder"))
    vim.keymap.set('i', '<C-p>',      ts.builtin().find_files,                 Opt("Telescope: Fuzzy file finder"))
    vim.keymap.set('n', '<Leader>fp', ts.extensions().media_files.media_files, Opt("Telescope: Show media files"))
    vim.keymap.set('n', '<Leader>fb', ts.builtin().buffers,                    Opt("Telescope: Show active buffers"))
    vim.keymap.set('n', '<Leader>fh', ts.builtin().help_tags,                  Opt("Telescope: interactive help menu"))
    vim.keymap.set('n', '<Leader>fo', ts.builtin().oldfiles,                   Opt("Telescope: Previously edited files"))
    vim.keymap.set('n', '<Leader>fk', ts.builtin().keymaps,                    Opt("Telescope: Show all keybinds"))
    vim.keymap.set('n', '<Leader>fw', ts.builtin().grep_string,                Opt("Telescope: Find word under cursor"))
    vim.keymap.set('n', '<Leader>fs', ts.grep_string,                          Opt("Telescope: Grep string using statusline"))
    vim.keymap.set('n', '<Leader>ft', ts.builtin().lsp_document_symbols,       Opt("Telescope: Show LSP symbols in current file"))
end

-----------------
--  GIT SIGNS  --
-----------------

-- vim.keymap.set("n", "]c",         {expr = true, '&diff ? \']c\' : \'<cmd>lua require"gitsigns".next_hunk()<CR>\''}, opt)
-- vim.keymap.set("n", "[c",         {expr = true, '&diff ? \'[c\' : \'<cmd>lua require"gitsigns".prev_hunk()<CR>\''}, opt)
pmap("n", "<leader>hs", '<cmd>lua require"gitsigns".stage_hunk()<CR>')
pmap("n", "<leader>hu", '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>')
pmap("n", "<leader>hr", '<cmd>lua require"gitsigns".reset_hunk()<CR>')
pmap("n", "<leader>hp", '<cmd>lua require"gitsigns".preview_hunk()<CR>')
pmap("n", "<leader>hb", '<cmd>lua require"gitsigns".blame_line()<CR>')

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

