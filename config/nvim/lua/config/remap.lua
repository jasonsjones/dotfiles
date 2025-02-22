local opts = { silent = true }

-- Remap space a leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", opts)

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

--    Insert     --
-- Use 'kj' to enter normal mode
vim.keymap.set("i", "kj", "<ESC>", opts)

-- Undo break points
vim.keymap.set("i", ",", ",<c-g>u", opts)
vim.keymap.set("i", ".", ".<c-g>u", opts)
vim.keymap.set("i", "!", "!<c-g>u", opts)
vim.keymap.set("i", "?", "?<c-g>u", opts)

--    Normal     --
vim.keymap.set("n", "<leader>fe", vim.cmd.Lexplore, { desc = "[F]ile [E]xplorer" })
vim.keymap.set(
    "n",
    "<leader>sc",
    ':lua require("config.utils").toggle_spell_check()<CR>',
    { desc = "Toggle spell check", silent = true }
)
vim.keymap.set(
    "n",
    "<leader>li",
    ':lua require("config.ledger").generate_transaction_info()<CR>',
    { desc = "[L]edger: Generate useful [i]nformation for the current transaction", silent = true }
)

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Terminal mode window navigation
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", opts)
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", opts)

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)

--    Visual     --
-- Press kj fast to enter normal mode
vim.keymap.set("v", "kj", "<ESC>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Move text up and down
vim.keymap.set("v", "<A-k>", ":m .-2<CR>==", opts)
vim.keymap.set("v", "<A-j>", ":m .+1<CR>==", opts)

-- Retain yanked text after paste
vim.keymap.set("v", "p", '"_dP', opts)

--    Visual Block     --
-- Move text up and down
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", opts)
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)
