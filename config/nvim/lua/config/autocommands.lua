local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Remove trailing whitespace on save (for all files)
local TrailingWhitespace = augroup("TrailingWhitespace", { clear = true })
autocmd({ "BufWritePre" }, {
    group = TrailingWhitespace,
    pattern = "*",
    command = [[%s/\s\+$//e]]
})

-- Highlight on yank
local HighlightGroup = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    group = HighlightGroup,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank()
    end
})

-- Local setting for markdown files
local MarkdownConfig = augroup("MarkdownConfig", { clear = true })
autocmd({ "BufEnter", "BufWinEnter" }, {
    group = MarkdownConfig,
    pattern = "*.md",
    callback = function()
        vim.cmd("silent! loadview")
    end
})

autocmd("BufWinLeave", {
    group = MarkdownConfig,
    pattern = "*.md",
    callback = function()
        vim.cmd("mkview")
    end
})

