if vim.g.loaded_cupid then
	return
end
vim.g.loaded_cupid = true

local cupid = require("cupid")

vim.api.nvim_create_user_command("CupidToggle", function()
	cupid.toggle()
end, {})

vim.api.nvim_create_user_command("CupidNewElement", function()
	cupid.insert_element()
end, {})
