return {
    {
        -- Colorscheme
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
    }
}
