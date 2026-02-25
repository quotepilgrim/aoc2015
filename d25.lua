local M = {}

local function load_data(file)
	local a, b = file:read():match("(%d+)[^%d]+(%d+)")

	file:close()
	return { tonumber(a), tonumber(b) }
end

local function next(code)
	return code * 252533 % 33554393
end

M["1"] = function(file)
	local data = load_data(file)
	local codes = { 20151125 }

	for i = 1, data[1] * data[2] do
		for j = i, 1, -1 do
			if data[1] == j and data[2] == i - j + 1 then
				return codes[#codes]
			end
			table.insert(codes, next(codes[#codes]))
		end
	end
end

return M
