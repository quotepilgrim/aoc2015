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

M["1"] = function(file)
	local data, molecule = load_data(file)
	local result = 0
	local unique = {}

	for _, t in ipairs(data) do
		local matches = find_matches(molecule, t[1])
		for _, m in ipairs(matches) do
			local replaced = molecule:sub(1, m[1] - 1) .. t[2] .. molecule:sub(m[2] + 1)
			unique[replaced] = true
		end
	end

	for k, _ in pairs(unique) do
		print(k)
		result = result + 1
	end

	return result
end

return M
