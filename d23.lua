local M = {}

local function load_data(file)
	local data = {}
	for line in file:lines() do
		local row = {}
		local matches = line:gmatch("[^%s,]+")

		for match in matches do
			table.insert(row, match)
		end

		row[#row] = tonumber(row[#row]) or row[#row]
		table.insert(data, row)
	end
	return data
end

local function solve(data, registers)
	local function execute(pos)
		local opcode, o1, o2 = unpack(data[pos])

		if opcode == "hlf" then
			registers[o1] = math.floor(registers[o1] / 2)
		end

		if opcode == "tpl" then
			registers[o1] = registers[o1] * 3
		end

		if opcode == "inc" then
			registers[o1] = registers[o1] + 1
		end

		if opcode == "jmp" then
			return pos + o1
		end

		if opcode == "jie" then
			if registers[o1] % 2 == 0 then
				return pos + o2
			end
		end

		if opcode == "jio" then
			if registers[o1] == 1 then
				return pos + o2
			end
		end

		return pos + 1
	end

	local pos = 1
	while pos <= #data do
		pos = execute(pos)
	end

	return registers.b
end

M["1"] = function(file)
	local data = load_data(file)
	return solve(data, { a = 0, b = 0 })
end

M["2"] = function(file)
	local data = load_data(file)
	return solve(data, { a = 1, b = 0 })
end

return M
