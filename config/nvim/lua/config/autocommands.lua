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
