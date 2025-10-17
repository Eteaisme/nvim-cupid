if vim.g.loaded_cupid then
	return
end
vim.g.loaded_cupid = true

vim.api.nvim_create_user_command("CupidHello", function()
	print("Hello from Cupid!")
end, {})
