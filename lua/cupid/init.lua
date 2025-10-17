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

function M.insert_element()
	core.insert_element(M.options)
end

return M
