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

map("n", "<Leader>fw", [[<Cmd> Telescope live_grep<CR>]], opt)
map("n", "<Leader>ft", [[<Cmd> TodoTelescope<CR>]], opt)
map("n", "<Leader>db", [[<Cmd> Dashboard<CR>]], opt)
map("n", "<Leader>fn", [[<Cmd> DashboardNewFile<CR>]], opt)
map("n", "<Leader>bm", [[<Cmd> DashboardJumpMarks<CR>]], opt)
map("n", "<C-s>l", [[<Cmd> SessionLoad<CR>]], opt)
map("n", "<C-s>s", [[<Cmd> SessionSave<CR>]], opt)

-----------------
--  TELESCOPE  --
-----------------

map("n", "<Leader>gt", [[<Cmd> Telescope git_status <CR>]], opt)
map("n", "<Leader>cm", [[<Cmd> Telescope git_commits <CR>]], opt)
map("n", "<C-p>", [[<Cmd> Telescope find_files find_command=rg,--ignore,--hidden,--files <CR>]], opt)
map("i", "<C-p>", [[<Cmd> Telescope find_files find_command=rg,--ignore,--hidden,--files <CR>]], opt)
map("n", "<Leader>fp", [[<Cmd>lua require('telescope').extensions.media_files.media_files()<CR>]], opt)
map("n", "<Leader>fb", [[<Cmd>Telescope buffers<CR>]], opt)
map("n", "<Leader>fh", [[<Cmd>Telescope help_tags<CR>]], opt)
map("n", "<Leader>fo", [[<Cmd>Telescope oldfiles<CR>]], opt)
map("n", "<Leader>fk", [[<Cmd>Telescope keymaps<CR>]], opt)
map("n", "<Leader>f#", [[<Cmd>Telescope grep_string<CR>]], opt)

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

