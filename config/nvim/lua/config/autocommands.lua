local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Remove trailing whitespace on save (for all files)
local TrailingWhitespace = augroup("TrailingWhitespace", { clear = true })
autocmd({ "BufWritePre" }, {
    group = TrailingWhitespace,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- Highlight on yank
local HighlightGroup = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    group = HighlightGroup,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Local setting for markdown files
local MarkdownConfig = augroup("MarkdownConfig", { clear = true })
autocmd({ "BufEnter", "BufWinEnter" }, {
    group = MarkdownConfig,
    pattern = "*.md",
    callback = function()
        vim.cmd("silent! loadview")
        vim.opt.wrap = true
        vim.opt.linebreak = true
        vim.opt.list = false
        -- Set up folding for markdown
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt.foldlevel = 99
        -- Customize fold appearance using Tokyo Night colors
        vim.cmd([[highlight Folded guifg=#7aa2f7 guibg=#24283b]])
        vim.cmd([[highlight FoldColumn guifg=#7aa2f7 guibg=#1a1b26]])
    end,
})

autocmd("BufWinLeave", {
    group = MarkdownConfig,
    pattern = "*.md",
    callback = function()
        vim.cmd("mkview")
        vim.opt.wrap = false
        vim.opt.linebreak = false
        vim.opt.list = true
    end,
})

local ZellijIntegration = augroup("ZellijIntegration", { clear = true })
autocmd("VimEnter", {
    group = ZellijIntegration,
    pattern = "*",
    callback = function()
        vim.fn.system({ "zellij", "action", "switch-mode", "locked" })
    end,
})

autocmd("VimLeavePre", {
    group = ZellijIntegration,
    pattern = "*",
    callback = function()
        if vim.env.ZELLIJ ~= nil then
            vim.fn.system({ "zellij", "action", "switch-mode", "normal" })
        end
    end,
})
