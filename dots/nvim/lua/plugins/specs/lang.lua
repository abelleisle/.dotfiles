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

    { -- Make markdown look pretty
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
            file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
    },

    { -- Edit hex
        "RaafatTurki/hex.nvim",
        enabled = (vim.fn.executable("xxd") == 1),
        config = function()
            require("hex").setup()
        end,
    },
}
