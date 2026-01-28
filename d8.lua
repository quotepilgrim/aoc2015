local M = {}

local function load_data(file)
	local data = {}
	for line in file:lines() do
		table.insert(data, line)
	end
	file:close()
	return data
end

local function decoded_len(str)
	return #str:gsub("\\[^x]", "_"):gsub("\\x..", "_") - 2
end

local function encoded_len(str)
	return #str:gsub('["\\]', "__") + 2
end

M["1"] = function(file)
	local data = load_data(file)
	local result = 0
	for _, str in ipairs(data) do
		result = result + #str - decoded_len(str)
	end
	return result
end

M["2"] = function(file)
	local data = load_data(file)
	local result = 0
	for _, str in ipairs(data) do
		result = result - #str + encoded_len(str)
	end
	return result
end

return M
