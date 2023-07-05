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

    -- Alpha gretting screen at startup
    {
        'goolord/alpha-nvim',
        event = "VimEnter",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function ()
            require("config.alpha")
        end
    },

    -- Updated statusline
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("config.lualine")
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

    -- Treesitter for syntax highlighting and much more...
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            require("config.treesitter")
        end
    },

    -- LSP setup
    {
        "VonHeikemen/lsp-zero.nvim",
        dependencies = {
            -- LSP Support
            {"neovim/nvim-lspconfig"},             -- Required
            {"williamboman/mason.nvim"},           -- Optional
            {"williamboman/mason-lspconfig.nvim"}, -- Optional

            -- Autocompletion
            {"hrsh7th/nvim-cmp"},         -- Required
            {"hrsh7th/cmp-nvim-lsp"},     -- Required
            {"hrsh7th/cmp-buffer"},       -- Optional
            {"hrsh7th/cmp-path"},         -- Optional
            {"saadparwaiz1/cmp_luasnip"}, -- Optional
            {"hrsh7th/cmp-nvim-lua"},     -- Optional

            -- Snippets
            {"L3MON4D3/LuaSnip"},             -- Required
            {"rafamadriz/friendly-snippets"}, -- Optional
        },
        config = function ()
            require("config.lsp")
        end
    },

    -- Comments
    {
        "numToStr/Comment.nvim",
        opts = {}
    }
}

