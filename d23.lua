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
	local function execute(pc)
		local ins, op1, op2 = unpack(data[pc])

		if ins == "hlf" then
			registers[op1] = math.floor(registers[op1] / 2)
		end

		if ins == "tpl" then
			registers[op1] = registers[op1] * 3
		end

		if ins == "inc" then
			registers[op1] = registers[op1] + 1
		end

		if ins == "jmp" then
			return pc + op1
		end

		if ins == "jie" then
			if registers[op1] % 2 == 0 then
				return pc + op2
			end
		end

		if ins == "jio" then
			if registers[op1] == 1 then
				return pc + op2
			end
		end

		return pc + 1
	end

	local pc = 1
	while pc <= #data do
		pc = execute(pc)
	end

	return registers.b
end

M["1"] = function(file)
	return solve(load_data(file), { a = 0, b = 0 })
end

M["2"] = function(file)
	return solve(load_data(file), { a = 1, b = 0 })
end

return M
