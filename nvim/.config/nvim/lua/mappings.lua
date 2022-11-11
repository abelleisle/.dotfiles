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
vim.cmd("inoremap jk <Esc>")

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

---------------
--  TRUEZEN  --
---------------
map("n", "<leader>zz", ":TZAtaraxis<CR>", opt)
map("n", "<leader>zm", ":TZMinimalist<CR>", opt)
map("n", "<leader>zf", ":TZFocus<CR>", opt)

--map("n", "<C-s>", ":w <CR>", opt)

----------------
--  COMMENTS  --
----------------
map("n", "<leader>/", ":CommentToggle<CR>", opt)
map("v", "<leader>/", ":CommentToggle<CR>", opt)

------------------
--  COMPLETION  --
------------------

-- local remap = vim.api.nvim_set_keymap
-- local npairs = require('nvim-autopairs')
-- 
-- npairs.setup({ map_bs = false })
-- 
-- vim.g.coq_settings = { keymap = { recommended = false } }
-- 
-- -- these mappings are coq recommended mappings unrelated to nvim-autopairs
-- remap('i', '<esc>', [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
-- remap('i', '<c-c>', [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })
-- remap('i', '<tab>', [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true })
-- remap('i', '<s-tab>', [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true })
-- 
-- -- skip it, if you use another global object
-- _G.MUtils= {}
-- 
-- MUtils.CR = function()
--   if vim.fn.pumvisible() ~= 0 then
--     if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
--       return npairs.esc('<c-y>')
--     else
--       return npairs.esc('<c-e>') .. npairs.autopairs_cr()
--     end
--   else
--     return npairs.autopairs_cr()
--   end
-- end
-- remap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })
-- 
-- MUtils.BS = function()
--   if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
--     return npairs.esc('<c-e>') .. npairs.autopairs_bs()
--   else
--     return npairs.autopairs_bs()
--   end
-- end
-- remap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })

-- local remap = vim.api.nvim_set_keymap
-- local npairs = require('nvim-autopairs')
-- 
-- vim.g.completion_confirm_key = ""
-- 
-- _G.newl=function()
--     return npairs.autopairs_cr()
-- end
-- 
-- remap('i' , '<CR>','v:lua.newl()', {expr = true , noremap = true})
-- 
-- local t = function(str)
--     return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end
-- 
-- _G.expand_tab = function()
--   if vim.fn.pumvisible() == 1 then
--     if vim.fn.complete_info({"selected"})["selected"] == -1 then
--       return t "<C-n><Plug>(completion_confirm_completion)"
--     else
--       return t "<Plug>(completion_confirm_completion)"
--     end
--   elseif vim.api.nvim_eval([[ UltiSnips#CanJumpForwards() ]]) == 1 then
--       return t "<cmd>call UltiSnips#JumpForwards()<CR>"
--   else
--     return t "<Tab>"
--   end
-- end
-- 
-- _G.s_expand_tab = function()
--     if vim.api.nvim_eval([[ UltiSnips#CanJumpBackwards() ]]) == 1 then
--         return t "<cmd>call UltiSnips#JumpBackwards()<CR>"
--     else
--         return t "<S-Tab>"
--     end
-- end
-- 
-- vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.expand_tab()", {expr = true})
-- vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.expand_tab()", {expr = true})
-- vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_expand_tab()", {expr = true})
-- vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_expand_tab()", {expr = true})

-----------------
--  NVIM TREE  --
-----------------
map("n", "<Leader>t", ":NvimTreeToggle<CR>", opt)

--------------
--  FORMAT  --
--------------
map("n", "<Leader>fm", [[<Cmd> Neoformat<CR>]], opt)

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

