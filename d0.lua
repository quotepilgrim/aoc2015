local M = {}

local function load_data(file)
	local data = {}
	for line in file:lines() do
		table.insert(data, line)
	end
	file:close()
	return data
end

M["1"] = function(file)
	local data = load_data(file)
end

M["2"] = function(file)
	local data = load_data(file)
end

return M
