local lsp_status_ok, lsp = pcall(require, "lsp-zero")
if not lsp_status_ok then
    return
end

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
    return
end

local REMAP_DESC = {
    def = "Go to definition",
    hover = "Display hover information about the symbol under the cursor",
    workspace = "List all the symbols in the current workspace in the quick fix window",
    open_float = "Show diagnostics in a floating window",
    next = "Go to next diagnostic",
    prev = "Go to previous diagnostic",
    refs = "List all the references to the symbols under the cursor in the quick fix window",
    code_action = "Selects a code action available at the current cursor position",
    rename = "Rename all references to the symbol under the cursor",
    sig_help = " Displays signature information about the symbol under the cursor in a floating window"
}

local function shallow_copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_val in pairs(orig) do
            copy[orig_key] = orig_val
        end
    else
        copy = orig
    end
    return copy
end

local function add_desc_to_keymap(opts, desc)
    local opts_desc = shallow_copy(opts)
    opts_desc["desc"] = desc
    return opts_desc
end

lsp.preset("recommended")

lsp.ensure_installed({
    "lua_ls",
    "tsserver"
})

-- Fix undefined global 'vim'
lsp.configure("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }
            }
        }
    }
})

local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
    ["<Enter>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
})

lsp.set_preferences({
    suggest_lsp_servers = false,
})

lsp.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd",
        function() vim.lsp.buf.definition() end,
        add_desc_to_keymap(opts, REMAP_DESC.def)
    )

    vim.keymap.set("n", "K",
        function() vim.lsp.buf.hover() end,
        add_desc_to_keymap(opts, REMAP_DESC.hover)
    )

    vim.keymap.set("n", "<leader>vws",
        function() vim.lsp.buf.workspace_symbol() end,
        add_desc_to_keymap(opts, REMAP_DESC.workspace)
    )

    vim.keymap.set("n", "<leader>vd",
        function() vim.diagnostic.open_float() end,
        add_desc_to_keymap(opts, REMAP_DESC.open_float)
    )

    vim.keymap.set("n", "[d",
        function() vim.diagnostic.goto_next() end,
        add_desc_to_keymap(opts, REMAP_DESC.next)
    )

    vim.keymap.set("n", "]d",
        function() vim.diagnostic.goto_prev() end,
        add_desc_to_keymap(opts, REMAP_DESC.prev)
    )

    vim.keymap.set("n", "<leader>vca",
        function() vim.lsp.buf.code_action() end,
        add_desc_to_keymap(opts, REMAP_DESC.code_action)
    )

    vim.keymap.set("n", "<leader>vrr",
        function() vim.lsp.buf.references() end,
        add_desc_to_keymap(opts, REMAP_DESC.refs)
    )

    vim.keymap.set("n", "<leader>vrn",
        function() vim.lsp.buf.rename() end,
        add_desc_to_keymap(opts, REMAP_DESC.rename)
    )

    vim.keymap.set("i", "<C-h>",
        function() vim.lsp.buf.signature_help() end,
        add_desc_to_keymap(opts, REMAP_DESC.sig_help)
    )

end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})

