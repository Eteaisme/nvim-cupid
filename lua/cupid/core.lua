local M = {}

local function depth_of_line(line, arrow, indent_width)
	if not line then
		return nil
	end
	if line:match("^%s*" .. arrow) then
		local spaces = #(line:match("^(%s*)") or "")
		return math.floor(spaces / indent_width)
	end
	return nil
end

function M.current_depth(opts)
	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	local cur = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]

	-- if current line starts with arrow, use its true depth
	local d = depth_of_line(cur, opts.arrow, opts.indent_width)
	if d ~= nil then
		return d
	end

	-- if blank, look one line up for context
	if cur == "" and row > 0 then
		local prev = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
		local pd = depth_of_line(prev, opts.arrow, opts.indent_width)
		if pd ~= nil then
			return pd
		end
	end

	-- default depth under a title
	return 1
end

function M.update_vertical_connectors(opts)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for i, line in ipairs(lines) do
		if line:match("^%s*" .. opts.arrow) then
			local spaces = #(line:match("^(%s*)") or "")
			local depth = math.floor(spaces / opts.indent_width)
			local pos = depth * opts.indent_width
			if pos > 0 and (#line < pos or line:sub(pos, pos) ~= opts.vertical) then
				local updated = line:sub(1, pos - 1) .. opts.vertical .. line:sub(pos + 1)
				vim.api.nvim_buf_set_lines(0, i - 1, i, false, { updated })
			end
		end
	end
end

return M
