local M = {}

M.config = function()
    require("telescope").setup {
        defaults = {
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case"
            },
            prompt_prefix = "  ",
            selection_caret = "  ",
            entry_prefix = "  ",
            initial_mode = "insert",
            selection_strategy = "reset",
            sorting_strategy = "descending",
            layout_strategy = "horizontal",
            layout_config = {
                horizontal = {
                    prompt_position = "top",
                    preview_width = 0.55,
                    results_width = 0.8
                },
                vertical = {
                    mirror = false
                },
                width = 0.87,
                height = 0.80,
                preview_cutoff = 120
            },
            --file_sorter = require "telescope.sorters".get_fuzzy_file,
            file_ignore_patterns = {
                "%.git/*",
                "%.vim/*",
                "docs/doxygen/*",
                "doxygen/*",
                "zig-cache/*",
                "zig-out/*"
            },
            --generic_sorter = require "telescope.sorters".get_generic_fuzzy_sorter,
            --path_display = {"smart", "shorten"}, -- TODO: truncate when required by shortening path
            dynamic_preview_title = true,
            winblend = 0,
            border = {},
            borderchars = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
            color_devicons = true,
            use_less = true,
            set_env = {["COLORTERM"] = "truecolor"}, -- default = nil,
            file_previewer = require "telescope.previewers".vim_buffer_cat.new,
            grep_previewer = require "telescope.previewers".vim_buffer_vimgrep.new,
            qflist_previewer = require "telescope.previewers".vim_buffer_qflist.new,
            -- Developer configurations: Not meant for general override
            buffer_previewer_maker = require "telescope.previewers".buffer_previewer_maker,
            preview = {
                treesitter = true
            },
        },
        extensions = {
            fzf = {
                fuzzy = true, -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = "smart_case" -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            },
            media_files = {
                filetypes = {"png", "webp", "jpg", "jpeg"},
                find_cmd = "rg" -- find command (defaults to `fd`)
            },
        },
        pickers = {
            find_files = {
                hidden = true,
            },
            --grep_string = {
            --    shorten_path = true,
            --    word_match = "-w",
            --    only_sort_text = true,
            --    search = ''
            --},
            -- find_files = {
            --     find_command = {
            --         "rg", "--ignore", "--hidden", "--files"
            --     }
            -- }
        }
    }

    require("telescope").load_extension("fzf")
    require("telescope").load_extension("media_files")
    require("telescope").load_extension("notify")
    require("telescope").load_extension("noice")
end

return M
