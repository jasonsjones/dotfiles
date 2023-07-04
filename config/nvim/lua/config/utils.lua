local M = {}

-- Toggle spell check on/off and set language to en_us
function M.toggle_spell_check()
    if vim.o.spell then
        vim.wo.spell = false
        print("Spell check disabled")
    else
        vim.wo.spell = true
        print("Spell check enabled")
    end
end

return M

