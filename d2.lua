local t = {}
local result

local dump = require("lib.dump")

local function p1(data)
	local result = 0
	for _, box in ipairs(data) do
		local sides = {}
		for i = 1, #box do
			for j = i + 1, #box do
				table.insert(sides, box[i] * box[j])
			end
		end

		local smallest = math.min(unpack(sides))
		local surface = 0
		for _, side in ipairs(sides) do
			surface = surface + 2 * side
		end

		result = result + surface + smallest
	end
	return result
end

local function p2(data)
	dump(data)
end

function t.load(part, filename)
	local file = assert(io.open(filename))
	local data = {}

	for line in file:lines() do
		local row = {}
		local matches = line:gmatch("[^x]+")
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
