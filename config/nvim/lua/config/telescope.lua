local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end
local builtin = require("telescope.builtin")

telescope.setup({
    defaults = {
        file_ignore_patterns = {
            "node_modules",
            "dist"
        },
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false
            }
        }
    }
})

vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string,  { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sb", builtin.buffers,  { desc = "[S]earch bB]uffers" })

