local M = {}

local function get_transaction_boundaries()
    local blankRegex = "^$"
    -- Find the starting and ending lines of the current transaction
    local tx_start_line = vim.fn.search(blankRegex, 'bn')
    if tx_start_line == 0 then
        -- Transaction not found
        return 0, 0
    end

    local tx_end_line = vim.fn.search(blankRegex, 'n')

    return tx_start_line + 1, tx_end_line - 1
end

local function is_transaction_line(line)
    local is_match = string.match(line, "^%d%d/%d%d")
    return is_match
end

local function is_expense(line)
    local is_match = string.match(line, "^%s*Expenses:")
    return is_match
end

local function includes_total_amount(line)
    local amountRE = "; %$(%d+%.%d%d)"
    local is_match = string.match(line, amountRE)
    return is_match
end

local function parse_amount(line)
    local amountRE = "%$(%d+%.%d%d)"
    local _, _, amountStr = string.find(line, amountRE)

    return tonumber(amountStr)
end

local function show_virtual_text(line_num, total_amount, cumulative_amount)
    local bufnr = vim.fn.bufnr()
    local namespace_id = vim.api.nvim_create_namespace("ledger_info")
    local col_num = 0
    local opts = {
        id = 1,
        virt_text = {
            {
                string.format(
                    "Cumulative Amount: $%.2f | Amount Remaining: $%.2f",
                    cumulative_amount,
                    math.abs(total_amount - cumulative_amount)
                ),
                "Comment"
            }
        },
        virt_text_pos = "eol"
    }

    vim.api.nvim_buf_set_extmark(bufnr, namespace_id, line_num, col_num, opts)
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

        if is_expense(line_str) then
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

