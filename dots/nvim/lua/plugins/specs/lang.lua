--------------------
--  LANG HELPERS  --
--------------------
return {
    { -- Automatically compile (la)tex
        "lervag/vimtex",
        ft = { "tex" },
    },

    { -- Preview markdown
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },

    { -- Edit hex
        "RaafatTurki/hex.nvim",
        enabled = (vim.fn.executable("xxd") == 1),
        config = function()
            require("hex").setup()
        end,
    },

}
