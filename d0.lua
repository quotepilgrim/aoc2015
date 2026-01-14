local t = {}
local result

local function p1(data)
	print(table.concat(data, "\n"))
end

local function p2(data)
	print(table.concat(data, "\n"))
end

function t.load(part, filename)
	local file = assert(io.open(filename))
	local data = {}

	for line in file:lines() do
		table.insert(data, line)
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
