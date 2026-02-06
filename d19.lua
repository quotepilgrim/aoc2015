local M = {}

local function load_data(file)
	local data = {}
	local molecule = ""
	local line

	while true do
		line = file:read()
		local a, b = line:match("(.+) => (.+)")

		if line == "" then
			break
		end

		table.insert(data, { a, b })
	end

	molecule = file:read()
	file:close()

	return data, molecule
end

local function find_matches(s, m)
	local i, e = 1, 1
	local result = {}

	while true do
		i, e = s:find(m, i)

		if not i then
			break
		end

		table.insert(result, { i, e })
		i = e + 1
	end

	return result
end

local function replace(str, pos, rep)
	return str:sub(1, pos[1] - 1) .. rep .. str:sub(pos[2] + 1)
end

M["1"] = function(file)
	local data, molecule = load_data(file)
	local result = 0
	local unique = {}

	for _, t in ipairs(data) do
		local matches = find_matches(molecule, t[1])
		for _, m in ipairs(matches) do
			unique[replace(molecule, m, t[2])] = true
		end
	end

	for _, _ in pairs(unique) do
		result = result + 1
	end

	return result
end

-- this either finds the answer very fast or gets stuck for a very long time
M["2"] = function(file)
	local data, molecule = load_data(file)
	local result = 0
	local unique = {}
	local found = false

	unique[molecule] = true

	while not found do
		result = result + 1
		for str, _ in pairs(unique) do
			local new_unique = {}
			for _, t in ipairs(data) do
				local matches = find_matches(str, t[2])
				for _, m in ipairs(matches) do
					new_unique[replace(str, m, t[1])] = true
				end
			end

			for k, _ in pairs(new_unique) do
				if k == "e" then
					found = true
					goto breakout
				end
			end

			unique = new_unique
		end
		::breakout::
	end
	return result
end

return M
