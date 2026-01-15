local t = {}
local result

local grid = {}

for i = 1, 1000 do
	grid[i] = {}
	for j = 1, 1000 do
		grid[i][j] = false
	end
end

local function p1(data)
	--
end

local function p2(data)
	--
end

function t.load(part, filename)
	local file = assert(io.open(filename))
	local data = {}

	for line in file:lines() do
		line = line:gsub("turn ", "turn"):gsub("through ", "")
		local row = {}
		local matches = line:gmatch("[^%s]+")
		for match in matches do
			table.insert(row, match)
		end
		table.insert(data, row)
	end

	if part == "1" then
		result = p1(data)
	elseif part == "2" then
		result = p2(data)
	end

	return result
end

function t.draw()
	love.graphics.print(result or "")
end

return t
