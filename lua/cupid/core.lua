local M = {}

function M.compute_depth(lines, arrow, indent_width)
	for i = #lines, 1, -1 do
		local line = lines[i]
		local match = line:match("^(%s*)" .. arrow)
		if match then
			return #match / indent_width -- exact current level
		end
	end
	return 0
end

function M.update_vertical_connectors(options)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for i = 1, #lines do
		local line = lines[i]
		if line:match("^%s*" .. options.arrow) then
			local depth = (#line:match("^(%s*)") or "") / options.indent_width
			local pos = math.max(0, depth * options.indent_width - 1)
			if pos > 0 and (#line < pos or line:sub(pos, pos) ~= options.vertical) then
				local updated = line:sub(1, pos - 1) .. options.vertical .. line:sub(pos + 1)
				vim.api.nvim_buf_set_lines(0, i - 1, i, false, { updated })
			end
		end
	end
end

return M
