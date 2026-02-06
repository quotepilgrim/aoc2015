local M = {}

local function divisors(n)
	if n == 1 then
		return { 1 }
	end

	local result = { 1, n }

	for i = 2, math.sqrt(n) do
		if n % i == 0 then
			table.insert(result, i)
			if n / i ~= i then
				table.insert(result, n / i)
			end
		end
	end

	return result
end

M["1"] = function(file)
	local data = assert(tonumber(file:read()))
	file:close()
	local result = 0

	local house = 0
	while result < data do
		result = 0
		house = house + 1

		for _, elf in ipairs(divisors(house)) do
			result = result + 10 * elf
		end
	end

	return house
end

return M
