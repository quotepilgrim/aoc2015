local M = {}

local grid = {}
local temp = {}
local w, h = 8, 8
local total = 0
local p2

local neighbors = {
	{ -1, -1 },
	{ 0, -1 },
	{ 1, -1 },
	{ -1, 0 },
	{ 1, 0 },
	{ -1, 1 },
	{ 0, 1 },
	{ 1, 1 },
}

M.load = function(argv)
	love.window.setMode(w * 100, h * 100)
end

local function load_data(file)
	for line in file:lines() do
		local row = {}
		for c in line:gmatch(".") do
			if c == "#" then
				table.insert(row, true)
			else
				table.insert(row, false)
			end
		end
		table.insert(grid, row)
		table.insert(temp, {})
	end
end

local function count_neighbors(x, y)
	local count = 0

	for _, neighbor in ipairs(neighbors) do
		local nx, ny = unpack(neighbor)
		if grid[y + ny] and grid[y + ny][x + nx] then
			count = count + 1
		end
	end

	return count
end

local function step()
	for y = 1, #grid do
		for x = 1, #grid do
			local count = count_neighbors(x, y)

			if grid[y][x] and (count == 2 or count == 3) then
				temp[y][x] = true
			elseif count == 3 then
				temp[y][x] = true
			else
				temp[y][x] = false
			end
		end
	end

	grid, temp = temp, grid
end

local function stuck()
	grid[1][1] = true
	grid[#grid][1] = true
	grid[1][#grid[1]] = true
	grid[#grid][#grid[1]] = true
end

M.draw = function()
	love.graphics.translate(-w, -h)
	for y = 1, #grid do
		for x = 1, #grid do
			if grid[y][x] then
				love.graphics.rectangle("fill", x * w, y * h, w - 1, h - 1)
			end
		end
	end
end

local count = 0
M.update = function(dt)
	step()

	if p2 then
		stuck()
	end

	count = count + 1
	if count == 100 then
		for _, t in ipairs(grid) do
			for _, v in ipairs(t) do
				total = v and total + 1 or total
			end
		end
		print(total)
	end
end

M["1"] = function(file)
	load_data(file)
end

M["2"] = function(file)
	load_data(file)
	stuck()
	p2 = true
end

return M
