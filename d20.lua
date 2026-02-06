local M = {}

local function get_divisors(n)
	if n == 1 then
		return { 1 }
	end

	local divisors = { 1, n }

	for i = 2, math.sqrt(n) do
		if n % i == 0 then
			table.insert(divisors, i)
			if n / i ~= i then
				table.insert(divisors, n / i)
			end
		end
	end

	return divisors
end

M["1"] = function(file)
	local data = assert(tonumber(file:read()))
	file:close()
	local result = 0

	local house = 0
	while result < data do
		result = 0
		house = house + 1

		for _, elf in ipairs(get_divisors(house)) do
			result = result + 10 * elf
		end
	end

	return house
end

M["2"] = function(file)
	local data = assert(tonumber(file:read()))
	file:close()
	local houses = {}
	local enough_gifts = {}

	for elf = 1, 1000000 do
		for i = 1, 50 do
			houses[elf * i] = (houses[elf * i] or 0) + 11 * elf
			if houses[elf * i] > data then
				table.insert(enough_gifts, { elf * i, houses[elf * i] })
			end
		end
	end

	table.sort(enough_gifts, function(a, b)
		return a[1] < b[1]
	end)

	return enough_gifts[1][1]
end

return M
