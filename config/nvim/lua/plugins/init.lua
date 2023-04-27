return {
    -- Colorscheme
    {
        "shaunsingh/nord.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            -- Target event 'BufEnter' since the 'Colorscheme' event will get overridden
            -- when the actual colorscheme is loaded, which happens after the autocmd fires
            vim.cmd([[
                 augroup CustomColors
                     autocmd!
                     autocmd VimEnter * highlight CursorLineNR guifg=#ffe162
                 augroup end
              ]])

            vim.g.nord_borders = true
            vim.g.nord_disable_background = true

            require("nord").set()
        end
    },

    -- Updated statusline
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = {
                    icons_enabled = false,
                    theme = "nord",
                    component_separators = "|",
                    section_separators = ""
                }
            })
        end
    },

    -- Git
    {
        "lewis6991/gitsigns.nvim",
        config = function ()
            require("gitsigns").setup({ })
        end
    },

    -- Fuzzy Finder (files, lsp, etc)
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function ()
            require("config.telescope")
        end
    },
}

