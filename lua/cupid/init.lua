local core = require("cupid.core")

local M = {}

M.options = {
	arrow = "-->",
	vertical = "|",
	indent_width = 4,
}

M.enabled = false

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

function M.toggle()
	M.enabled = not M.enabled
	if M.enabled then
		vim.notify("Cupid enabled 💘")
	else
		vim.notify("Cupid disabled ❌")
	end
end

function M.handle_enter()
	if not M.enabled then
		return
	end
	core.insert_element(M.options)
end

vim.api.nvim_create_autocmd("TextChangedI", {
	pattern = "*",
	callback = function()
		M.handle_enter()
	end,
})

return M
