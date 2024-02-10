return {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
        local status_ok, conform = pcall(require, "conform")
        if not status_ok then
            return
        end

        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                markdown = { "prettier" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })
    end,
}
