local M = {}

local tape = {
	children = 3,
	cats = 7,
	samoyeds = 2,
	pomeranians = 3,
	akitas = 0,
	vizslas = 0,
	goldfish = 5,
	trees = 3,
	cars = 2,
	perfumes = 1,
}

local function load_data(file)
	local data = {}
	for line in file:lines() do
		local row = {}
		local id = line:match("Sue (%d+)")
		for comp, num in line:gmatch("([^%s]+): (%d+)") do
			row[comp] = tonumber(num)
		end
		data[tonumber(id)] = row
	end
	file:close()
	return data
end

M["1"] = function(file)
	local data = load_data(file)
	local max = 0
	local max_i = 0

	for i, t in ipairs(data) do
		local matches = 0

		for k, v in pairs(tape) do
			if t[k] and t[k] == v then
				matches = matches + 1
			end
		end

		if matches > max then
			max = matches
			max_i = i
		end
	end

	return max_i
end

M["2"] = function(file)
	local data = load_data(file)
	local max = 0
	local max_i = 0

	for i, t in ipairs(data) do
		local matches = 0

		for k, v in pairs(tape) do
			local match

			if not t[k] then
				goto continue
			elseif k == "cats" or k == "trees" then
				match = t[k] > v
			elseif k == "pomeranians" or k == "goldfish" then
				match = t[k] < v
			else
				match = t[k] == v
			end

			if match then
				matches = matches + 1
			end
			::continue::
		end

		if matches > max then
			max = matches
			max_i = i
		end
	end

	return max_i
end

return M
