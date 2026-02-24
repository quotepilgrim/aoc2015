local M = {}
local shuffle = require("lib.shuffle")

local function load_data(file)
	local data = {}

	for line in file:lines() do
		table.insert(data, tonumber(line))
	end

	file:close()
	return data
end

local function find_slice(t, size)
	local sum = 0
	local count = 1
	local slice, rest = {}, {}

	while sum < size do
		sum = sum + t[count]
		count = count + 1
	end

	if sum > size then
		return nil
	else
		for i = 1, count - 1 do
			table.insert(slice, t[i])
		end

		for i = count, #t do
			table.insert(rest, t[i])
		end

		return slice, rest
	end
end

local function get_size(t, p)
	local sum = 0
	p = p or 3

	for _, v in ipairs(t) do
		sum = sum + v
	end

	return sum / p
end

local function entangle(t)
	local prod = 1

	for _, v in ipairs(t) do
		prod = prod * v
	end

	return prod
end

M["1"] = function(file)
	local data = load_data(file)
	local size = get_size(data)
	local groups = {}

	-- I would go through all possible permutations but this is way faster.
	-- I'm sure there's a smarter solution out there. I won't be finding it.
	for _ = 1, 8000000 do
		shuffle(data)

		local slice1, rest = find_slice(data, size)

		if slice1 then
			local slice2, slice3 = find_slice(rest, size)
			if slice1 and slice2 then
				table.insert(groups, { slice1, slice2, slice3 })
			end
		end
	end

	for _, g in ipairs(groups) do
		table.sort(g, function(a, b)
			return #a < #b
		end)
	end

	table.sort(groups, function(a, b)
		return #a[1] < #b[1]
	end)

	local min_size = #groups[1][1]
	local min = math.huge

	for _, g in ipairs(groups) do
		if #g[1] > min_size then
			break
		end

		if entangle(g[1]) < min then
			min = entangle(g[1])
		end
	end

	return min
end

M["2"] = function(file)
	local data = load_data(file)
	local size = get_size(data, 4)
	local groups = {}

	-- this should be my call to look for a smarter solution, but I'm stubborn
	-- why not just double the number of iterations until it works, after all?
	for _ = 1, 128000000 do
		shuffle(data)
		local slice1, slice2, slice3, slice4, rest

		slice1, rest = find_slice(data, size)

		if slice1 then
			slice2, rest = find_slice(rest, size)
		end

		if slice2 then
			slice3, slice4 = find_slice(rest, size)
			if slice1 and slice2 and slice3 then
				table.insert(groups, { slice1, slice2, slice3, slice4 })
			end
		end
	end

	for _, g in ipairs(groups) do
		table.sort(g, function(a, b)
			return #a < #b
		end)
	end

	table.sort(groups, function(a, b)
		return #a[1] < #b[1]
	end)

	local min_size = #groups[1][1]
	local min = math.huge

	for _, g in ipairs(groups) do
		if #g[1] > min_size then
			break
		end

		if entangle(g[1]) < min then
			min = entangle(g[1])
		end
	end

	return min
end

return M
