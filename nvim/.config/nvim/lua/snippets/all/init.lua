local box = require("snippets.all.box")

local snippets = function()
    local snips = {}  -- Where to store the snippets
    local sources = { -- Where we get our snippets from
        box
    }

    -- Add all the snippets from sources
    for s = 1,#sources do
        for i = 1,#sources[s] do
            table.insert(snips, sources[s][i])
        end
    end

    return snips
end

return snippets()
