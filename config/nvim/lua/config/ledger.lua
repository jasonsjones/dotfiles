local M = {}

local NAMESPACE = "ledger_info"

local RegEx = {
    EMPTY_LINE = "^$",
    DATE = "^%d%d/%d%d",
    EXPENSES = "^%s*Expenses:",
    TOTAL_AMOUNT = "; %$(%d+%.%d%d)",
    EXPENSE_AMOUNT = "%$(%d+%.%d%d)"
}

local function get_transaction_boundaries()
    -- Find the starting and ending lines of the current transaction
    local tx_start_line = vim.fn.search(RegEx.EMPTY_LINE, 'bn')
    if tx_start_line == 0 then
        -- Transaction not found
        return 0, 0
    end

    local tx_end_line = vim.fn.search(RegEx.EMPTY_LINE, 'n')

    return tx_start_line + 1, tx_end_line - 1
end

local function is_transaction_line(line)
    return string.match(line, RegEx.DATE)
end

local function is_expense_line(line)
    return string.match(line, RegEx.EXPENSES)
end

local function includes_total_amount(line)
    return string.match(line, RegEx.TOTAL_AMOUNT)
end

local function parse_amount(line)
    local _, _, amountStr = string.find(line, RegEx.EXPENSE_AMOUNT)

    return tonumber(amountStr)
end

local function show_virtual_text(line_num, total_amount, cumulative_amount)
    local bufnr = vim.fn.bufnr()
    local namespace_id = vim.api.nvim_create_namespace(NAMESPACE)
    local col_num = 0
    local amount_remaining = math.abs(total_amount - cumulative_amount)

    local opts1 = {
        id = 1,
        virt_text = {
            {
                string.format(
                    "%20s $%8.2f",
                    "Cumulative Amount: ",
                    cumulative_amount
                ),
                "Comment"
            }
        },
        virt_text_pos = "right_align"
    }

    local opts2 = {
        id = 2,
        virt_text = {
            {
                string.format(
                    "%20s $%8.2f",
                    "Amount Remaining: ",
                    amount_remaining
                ),
                "Comment"
            },
        },
        virt_text_pos = "right_align"
    }

    vim.api.nvim_buf_set_extmark(bufnr, namespace_id, line_num, col_num, opts1)
    vim.api.nvim_buf_set_extmark(bufnr, namespace_id, line_num + 1, col_num, opts2)
end

-- Generate useful information for the current transaction
function M.generate_transaction_info()
    local start_line, end_line = get_transaction_boundaries()
    local line_for_display = start_line
    local total_amount = 0.00
    local cumulative_amount = 0.00

    for line = start_line, end_line do
        local line_str = vim.fn.getline(line)

        if is_transaction_line(line_str) then
            line_for_display = line - 1
            if includes_total_amount(line_str) then
                total_amount = parse_amount(line_str)
            end

        end

        if is_expense_line(line_str) then
            local amount = parse_amount(line_str)
            if not amount then
                amount = 0.00
            end
            cumulative_amount = cumulative_amount + amount
        end
    end

    show_virtual_text(line_for_display, total_amount, cumulative_amount)
end

return M

