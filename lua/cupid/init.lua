local core = require("cupid.core")

local M = {}

M.options = {
	arrow = "-->",
	vertical = "|",
	indent_width = 4,
	add_vertical = true,
}

M.enabled = false

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

function M.toggle()
	M.enabled = not M.enabled
	if M.enabled then
		vim.notify("Cupid enabled 💘")
		vim.api.nvim_set_keymap("i", "<CR>", "v:lua.CupidHandleEnter()", { expr = true, noremap = true })
	else
		vim.notify("Cupid disabled ❌")
		pcall(vim.api.nvim_del_keymap, "i", "<CR>")
	end
end

function _G.CupidHandleEnter()
	if not M.enabled then
		return "\n"
	end

	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	local lines = vim.api.nvim_buf_get_lines(0, 0, row, false)
	local depth = core.compute_depth(lines, M.options.arrow, M.options.indent_width)
	local indent = string.rep(" ", depth * M.options.indent_width)

	if M.options.add_vertical then
		core.add_vertical_connectors(lines, depth, M.options)
	end

	return "\n" .. indent .. M.options.arrow .. " "
end

return M
