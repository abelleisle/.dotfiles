local function map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local opt = {noremap = true, silent = true}

-- dont copy any deleted text , this is disabled by default so uncomment the below mappings if you want them

--map("n", "dd", [=[ "_dd ]=], opt)
--map("v", "dd", [=[ "_dd ]=], opt)
map("v", "x", [=[ "_x ]=], opt)

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
require('Navigator').setup({
    auto_save = 'nil',
    disable_on_zoom = true
})

map('n', "<C-h>", "<CMD>lua require('Navigator').left()<CR>", opt)
map('n', "<C-k>", "<CMD>lua require('Navigator').up()<CR>", opt)
map('n', "<C-l>", "<CMD>lua require('Navigator').right()<CR>", opt)
map('n', "<C-j>", "<CMD>lua require('Navigator').down()<CR>", opt)
map('n', "<A-p>", "<CMD>lua require('Navigator').previous()<CR>", opt)

-----------------------
--  MODE NAVIGATION  --
-----------------------
--vim.cmd("inoremap jk <Esc>")
map('i', "jk", "<Esc>", opt)

------------------------
--  SPLIT NAVIGATION  --
------------------------
map('n', "<Leader>%", ":vsplit<CR>", opt)
map('n', "<Leader>\"", ":split<CR>", opt)

------------------
--  EASY ALIGN  --
------------------
--Start interactive EasyAlign in visual mode (e.g. vipga)
vim.cmd("xmap ga <Plug>(EasyAlign)")
--map("x", "ga", "<Plug>(EasyAlign)", opt)

--Start interactive EasyAlign for a motion/text object (e.g. gaip)
vim.cmd("nmap ga <Plug>(EasyAlign)")
--map("n", "ga", "<Plug>(EasyAlign)", opt)

-----------------
--  CLIPBOARD  --
-----------------

-- copy whole file content
map("n", "<C-a>", [[ <Cmd> %y+<CR>]], opt)

------------
--  LEAP  --
------------
local mini = {
    jump2d = require('mini.jump2d'),
    jump2d_char = function()
        local mj = require('mini.jump2d')
        return mj.start(mj.builtin_opts.single_character)
    end
}
vim.keymap.set({"n", "v"}, "<cr>", mini.jump2d_char,opt)

------------------------------------------------------------------------
--                              DISPLAY                               --
------------------------------------------------------------------------

-----------------------
--  HIDE HIGHLIGHTS  --
-----------------------
map("n", "<Leader>n", ":noh<CR>", opt)

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
map("n", "<Leader>t", ":NvimTreeToggle<CR>", opt)

--------------
--  FORMAT  --
--------------
map("n", "<Leader>fm", ":Neoformat<CR>", opt)

-----------------
--  DASHBOARD  --
-----------------

map("n", "<Leader>ft", [[<Cmd> TodoTelescope<CR>]], opt)
map("n", "<Leader>db", [[<Cmd> Dashboard<CR>]], opt)
map("n", "<Leader>fn", [[<Cmd> DashboardNewFile<CR>]], opt)
map("n", "<Leader>bm", [[<Cmd> DashboardJumpMarks<CR>]], opt)
map("n", "<C-s>l", [[<Cmd> SessionLoad<CR>]], opt)
map("n", "<C-s>s", [[<Cmd> SessionSave<CR>]], opt)

-----------------
--  TELESCOPE  --
-----------------

local ts = {
    builtin    = require('telescope.builtin'),
    extensions = require('telescope').extensions,
    grep_fuzzy = function()
        require('telescope.builtin').grep_string({
            prompt_title = "Fuzzy Find",
            shorten_path = true,
            word_match = "-w",
            only_sort_text = true,
            search = ''
        })
    end
}

--map("n", "<Leader>fw", [[<Cmd> Telescope live_grep<CR>]], opt)
vim.keymap.set('n', '<Leader>fw', ts.builtin.live_grep,                  opt)
vim.keymap.set('n', '<Leader>fz', ts.grep_fuzzy,                         opt)
vim.keymap.set('n', '<Leader>gt', ts.builtin.git_status,                 opt)
vim.keymap.set('n', '<Leader>cm', ts.builtin.git_commits,                opt)
vim.keymap.set('n', '<C-p>',      ts.builtin.find_files,                 opt)
vim.keymap.set('i', '<C-p>',      ts.builtin.find_files,                 opt)
vim.keymap.set('n', '<Leader>fp', ts.extensions.media_files.media_files, opt)
vim.keymap.set('n', '<Leader>fb', ts.builtin.buffers,                    opt)
vim.keymap.set('n', '<Leader>fh', ts.builtin.help_tags,                  opt)
vim.keymap.set('n', '<Leader>fo', ts.builtin.oldfiles,                   opt)
vim.keymap.set('n', '<Leader>fk', ts.builtin.keymaps,                    opt)
vim.keymap.set('n', '<Leader>f#', ts.builtin.grep_string,                opt)

----------------------------------
--  BURN ARROWS and PGUP/PGDWN  --
----------------------------------
map("n", "<Up>", "<Nop>", {})
map("n", "<Left>", "<Nop>", {})
map("n", "<Right>", "<Nop>", {})
map("n", "<Down>", "<Nop>", {})
map("n", "<PageUp>", "<Nop>", {})
map("n", "<PageDown>", "<Nop>", {})

map("i", "<Up>", "<Nop>", {})
map("i", "<Left>", "<Nop>", {})
map("i", "<Right>", "<Nop>", {})
map("i", "<Down>", "<Nop>", {})
map("i", "<PageUp>", "<Nop>", {})
map("i", "<PageDown>", "<Nop>", {})

