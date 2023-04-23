-- :help option-list

-- Enable mouse mode
vim.opt.mouse = "a"

-- Set line numbers
vim.opt.number = true

-- Set relative line numbers
vim.opt.relativenumber = true

-- Highlight all matches on previous search pattern
vim.opt.hlsearch = false

-- Convert tabs to spaces
vim.opt.expandtab = true

-- The number of spaces inserted for each indentation
vim.opt.shiftwidth = 4

-- Insert 4 spaces for a tab
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Always show tabs
vim.opt.showtabline = 2

-- Set term gui colors (most terminals support this)
vim.opt.termguicolors = true

-- Show 8 lines at bottom before scrolling off
vim.opt.scrolloff = 8

-- Minimum number of colums to scroll horizontally
vim.opt.sidescrolloff = 8

-- Force all horizontal splits to go below current window
vim.opt.splitbelow = true

-- Force all vertical splits to go to the right of current window
vim.opt.splitright = true

-- Ignore case in search patterns
vim.opt.ignorecase = true

-- Enable persistent undo
vim.opt.undofile = true

-- Creates a backup file
vim.opt.backup = false

-- Create a swapfile
vim.opt.swapfile = false

-- Allows neovim to access the system clipboard
vim.opt.clipboard = "unnamedplus"

-- Highlight the current line
vim.opt.cursorline = true

-- Always show the sign column, otherwise it would shift the text each time
vim.opt.signcolumn = "yes"

-- More space in the neovim command line for displaying messages
vim.opt.cmdheight = 2

-- Smart case
vim.opt.smartcase = true

-- Make indenting smarter again
vim.opt.smartindent = true

-- Faster completion (4000ms default)
vim.opt.updatetime = 200

-- More powerfule backspacing
vim.opt.backspace = { "indent", "eol", "start" }

-- Set completeopt to have a better completion experience
vim.opt.completeopt = { "menuone", "noselect" }

-- Show <Tab> and <EOL>
vim.opt.list = true

-- Characters for displaying in list mode
vim.opt.listchars = { tab = "▸\\", trail = "•" }

-- Allow specified keys to cross line boundaries
vim.opt.whichwrap:append("<,>,[,],h,l")

-- Characters included in keywords
vim.opt.iskeyword:append("-")

-- Current buffer can be put in bg w/o writing to disk
vim.opt.hidden = true

-- The encoding written to a file
vim.opt.fileencoding = "utf-8"


--[[

-- So that `` is visible in markdown files
vim.opt.conceallevel = 0

-- Pop up menu height
vim.opt.pumheight = 15

-- Time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.timeoutlen = 1000

-- If a file is being edited by another program (or was written to
-- while editing with another program), it is not allowed to be edited
vim.opt.writebackup = false


--]]
