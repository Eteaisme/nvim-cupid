local M = {}

local function compute_depth(lines, arrow, indent_width)
	local depth = 0
	for i = #lines, 1, -1 do
		local line = lines[i]
		local match = line:match("^(%s*)" .. arrow)
		if match then
			depth = #match / indent_width + 1
			break
		end
	end
	return depth
end

function M.insert_element(options)
	local row = vim.api.nvim_win_get_cursor(0)[1] - 1 -- Lua index
	local lines = vim.api.nvim_buf_get_lines(0, 0, row, false)

	local depth = compute_depth(lines, options.arrow, options.indent_width)
	local indent = string.rep(" ", depth * options.indent_width)

	local new_line = indent .. options.arrow .. " "
	vim.api.nvim_buf_set_lines(0, row, row, false, { new_line })
	vim.api.nvim_win_set_cursor(0, { row + 1, #new_line })
end

return M
