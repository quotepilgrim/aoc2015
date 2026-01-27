local t = {}

local function load_data(file)
	local data = {}

	for line in file:lines() do
		local row = {}
		local matches = line:gmatch("[^x]+")
		for match in matches do
			table.insert(row, match)
		end
		table.insert(data, row)
	end
	return data
end

t["1"] = function(file)
	local result = 0
	local data = load_data(file)
	for _, box in ipairs(data) do
		local sides = {}
		for i = 1, #box do
			for j = i + 1, #box do
				table.insert(sides, box[i] * box[j])
			end
		end

		local smallest = math.min(unpack(sides))
		local surface = 0
		for _, side in ipairs(sides) do
			surface = surface + 2 * side
		end

		result = result + surface + smallest
	end
	return result
end

t["2"] = function(file)
	local result = 0
	local data = load_data(file)
	for _, box in ipairs(data) do
		local sides = {}
		for i = 1, #box do
			for j = i + 1, #box do
				table.insert(sides, (box[i] + box[j]) * 2)
			end
		end

		local smallest = math.min(unpack(sides))
		local bow = 1
		for _, n in ipairs(box) do
			bow = bow * n
		end

		result = result + smallest + bow
	end
	return result
end

return t
