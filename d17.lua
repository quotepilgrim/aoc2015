local M = {}

local function load_data(file)
	local data = {}
	for line in file:lines() do
		table.insert(data, { filled = false, capacity = tonumber(line) })
	end
	file:close()
	return data
end

local function increment(t)
	local place = #t
	while place > 0 do
		t[place].filled = not t[place].filled
		if t[place].filled then
			return true
		end
		place = place - 1
	end
	return false
end

local function get_sum(data)
	local sum = 0
	local filled = 0

	for _, v in ipairs(data) do
		if v.filled then
			sum = sum + v.capacity
			filled = filled + 1
		end
	end

	return sum, filled
end

M["1"] = function(file)
	local data = load_data(file)
	local result = 0

	while increment(data) do
		result = get_sum(data) == 150 and result + 1 or result
	end

	return result
end

M["2"] = function(file)
	local data = load_data(file)
	local result = 0
	local minimum = 0x7fffffff

	while increment(data) do
		local sum, filled = get_sum(data)
		minimum = sum == 150 and filled < minimum and filled or minimum -- I know this is stupid.
	end

	while increment(data) do
		local sum, filled = get_sum(data)
		result = sum == 150 and filled == minimum and result + 1 or result -- And this is worse.
	end

	return result
end

return M
