local M = {}
local grid = {}

for i = 1, 1000 do
	grid[i] = {}
end

local function load_data(file)
	local data = {}

	for line in file:lines() do
		line = line:gsub("turn ", ""):gsub("through ", "")
		local row = {}
		local matches = line:gmatch("[^%s,]+")
		for match in matches do
			table.insert(row, tonumber(match) or match)
		end
		table.insert(data, row)
	end
	return data
end

M["1"] = function(file)
	local data = load_data(file)
	for _, tbl in ipairs(data) do
		local rule, a1, a2, b1, b2 = unpack(tbl)

		--technically doing it with the grid rotated 90° but it doesn't matter
		for i = a1 + 1, b1 + 1 do
			for j = a2 + 1, b2 + 1 do
				if rule == "on" then
					grid[i][j] = true
				elseif rule == "off" then
					grid[i][j] = false
				else
					grid[i][j] = not grid[i][j]
				end
			end
		end
	end

	local result = 0
	for i = 1, 1000 do
		for j = 1, 1000 do
			if grid[i][j] then
				result = result + 1
			end
		end
	end
	return result
end

M["2"] = function(file)
	local data = load_data(file)
	for _, tbl in ipairs(data) do
		local rule, a1, a2, b1, b2 = unpack(tbl)

		for i = a1 + 1, b1 + 1 do
			for j = a2 + 1, b2 + 1 do
				grid[i][j] = grid[i][j] or 0
				if rule == "on" then
					grid[i][j] = grid[i][j] + 1
				elseif rule == "off" then
					grid[i][j] = math.max(grid[i][j] - 1, 0)
				else
					grid[i][j] = grid[i][j] + 2
				end
			end
		end
	end

	local result = 0
	for i = 1, 1000 do
		for j = 1, 1000 do
			if grid[i][j] then
				result = result + grid[i][j]
			end
		end
	end
	return result
end

return M
