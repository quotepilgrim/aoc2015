local M = {}

local function load_data(file)
	local data = {}
	for line in file:lines() do
		local a, b = string.match(line, "(.+)%s%->%s(.*)")
		data[b] = tonumber(a) or a
	end
	file:close()
	return data
end

local function solve_wire(data, wire)
	wire = tonumber(wire) or wire

	if type(wire) == "number" then
		return wire
	end

	if type(data[wire]) == "number" then
		return data[wire]
	end

	local splits = {}

	for match in data[wire]:gmatch("[^%s]+") do
		table.insert(splits, match)
	end

	if splits[2] == "AND" then
		data[wire] = bit.band(solve_wire(data, splits[1]), solve_wire(data, splits[3]))
	elseif splits[2] == "OR" then
		data[wire] = bit.band(bit.bor(solve_wire(data, splits[1]), solve_wire(data, splits[3])), 0xFFFF)
	elseif splits[1] == "NOT" then
		data[wire] = bit.band(bit.bnot(solve_wire(data, splits[2])), 0xFFFF)
	elseif splits[2] == "LSHIFT" then
		data[wire] = bit.band(bit.lshift(solve_wire(data, splits[1]), solve_wire(data, splits[3])), 0xFFFF)
	elseif splits[2] == "RSHIFT" then
		data[wire] = bit.rshift(solve_wire(data, splits[1]), solve_wire(data, splits[3]))
	else
		data[wire] = solve_wire(data, splits[1])
	end

	return data[wire]
end

M["1"] = function(file)
	local data = load_data(file)

	for k, _ in pairs(data) do
		solve_wire(data, k)
	end

	return data.a
end

M["2"] = function(file)
	local data = load_data(file)
	local data2 = {}

	for k, v in pairs(data) do
		data2[k] = v
	end

	for k, _ in pairs(data) do
		solve_wire(data, k)
	end

	data2.b = data.a

	for k, _ in pairs(data2) do
		solve_wire(data2, k)
	end

	return data2.a
end

return M
