local M = {}

function M.compute_depth(lines, arrow, indent_width)
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

function M.update_vertical_connectors(options)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for i = 1, #lines do
		local line = lines[i]
		if line:match("^%s*" .. options.arrow) then
			local depth = (#line:match("^(%s*)") or "") / options.indent_width
			local indent_pos = depth * options.indent_width - 1
			if indent_pos > 0 and (#line < indent_pos or line:sub(indent_pos, indent_pos) ~= options.vertical) then
				local updated_line = line:sub(1, indent_pos - 1) .. options.vertical .. line:sub(indent_pos + 1)
				vim.api.nvim_buf_set_lines(0, i - 1, i, false, { updated_line })
			end
		end
	end
end

return M
