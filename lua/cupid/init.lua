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
		vim.api.nvim_set_keymap("i", "<CR>", "v:lua.CupidHandleEnter('sibling')", { expr = true, noremap = true })
		vim.api.nvim_set_keymap("i", "<S-CR>", "v:lua.CupidHandleEnter('child')", { expr = true, noremap = true })
		vim.api.nvim_create_autocmd("InsertLeave", {
			pattern = "*",
			callback = function()
				if M.enabled and M.options.add_vertical then
					core.update_vertical_connectors(M.options)
				end
			end,
			group = vim.api.nvim_create_augroup("CupidVertical", { clear = true }),
		})
	else
		vim.notify("Cupid disabled ❌")
		pcall(vim.api.nvim_del_keymap, "i", "<CR>")
		pcall(vim.api.nvim_del_keymap, "i", "<S-CR>")
		vim.api.nvim_clear_autocmds({ group = "CupidVertical" })
	end
end

function _G.CupidHandleEnter(kind)
	if not M.enabled then
		return "\n"
	end

	local depth = core.current_depth(M.options)
	if kind == "child" then
		depth = depth + 1
	end

	-- fixed: compute exact spaces by depth * indent_width
	local indent_spaces = math.floor(depth) * M.options.indent_width
	local indent = string.rep(" ", indent_spaces)

	return "\n" .. indent .. M.options.arrow .. " "
end

return M
