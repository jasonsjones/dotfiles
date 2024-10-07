return {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local status_ok, oil = pcall(require, "oil")
        if not status_ok then
            return
        end

        oil.setup({
            view_options = {
                show_hidden = true,
            },
        })

        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
}
