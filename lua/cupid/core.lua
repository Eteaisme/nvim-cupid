local M = {}

local function depth_of_line(line, arrow, indent_width)
	if not line then
		return nil
	end
	if line:match("^%s*" .. arrow) then
		local spaces = line:match("^(%s*)") or ""
		return math.floor(#spaces / indent_width)
	end
	return nil
end

function M.current_depth(opts)
	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	local cur = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]
	local depth = depth_of_line(cur, opts.arrow, opts.indent_width)
	if depth ~= nil then
		return depth
	end
	if cur == "" then
		local prev = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
		local pd = depth_of_line(prev, opts.arrow, opts.indent_width)
		if pd ~= nil then
			return pd
		end
	end
	return 1
end

function M.update_vertical_connectors(options)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for i = 1, #lines do
		local line = lines[i]
		if line:match("^%s*" .. options.arrow) then
			local spaces = line:match("^(%s*)") or ""
			local depth = math.floor(#spaces / options.indent_width)
			local pos = math.max(0, depth * options.indent_width - 1)
			if pos > 0 and (#line < pos or line:sub(pos, pos) ~= options.vertical) then
				local updated = line:sub(1, pos - 1) .. options.vertical .. line:sub(pos + 1)
				vim.api.nvim_buf_set_lines(0, i - 1, i, false, { updated })
			end
		end
	end
end

return M
