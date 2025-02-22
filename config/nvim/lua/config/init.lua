require("config.lazy")
require("config.options")
require("config.remap")
require("config.autocommands")
require("config.globals")
require("config.utils")
require("config.ledger")
require("config.lsp")

-- if in a zellij session, lock the switch mode to not interfere with
-- other <C-*> keymaps in neovim
-- if vim.env.ZELLIJ ~= nil then
--     vim.fn.system({ "zellij", "action", "switch-mode", "locked" })
-- end
