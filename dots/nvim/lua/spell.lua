local G = {}

G.spellpath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"

function G.userdict()
    local words = {}

    for word in io.open(G.spellpath, "r"):lines() do
        table.insert(words, word)
    end

    return words
end

function G.init()
    local opt = vim.opt
    opt.wrap = true
    opt.linebreak = true
    opt.list = false
    opt.textwidth = 0
    opt.colorcolumn = ""
    opt.spell = false
    opt.spelllang = "en_us"
    opt.spellfile = G.spellpath
end

return G
