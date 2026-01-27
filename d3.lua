local t = {}

local function load_data(file)
	local data = file:read()
	file:close()
	return data
end

t["1"] = function(file)
	local data = load_data(file)
	local x, y = 0, 0
	local locations = {}

	for i = 1, #data do
		locations[x] = locations[x] or {}
		locations[x][y] = locations[x][y] or true
		local c = data:sub(i, i)

		if c == "<" then
			x = x - 1
		elseif c == ">" then
			x = x + 1
		elseif c == "v" then
			y = y + 1
		elseif c == "^" then
			y = y - 1
		end
	end

	local result = 0
	for _, i in pairs(locations) do
		for _ in pairs(i) do
			result = result + 1
		end
	end
	return result
end

t["2"] = function(file)
	local data = load_data(file)
	local x, y, rx, ry = 0, 0, 0, 0
	local locations = {}
	local moves = {
		["<"] = { -1, 0 },
		[">"] = { 1, 0 },
		["v"] = { 0, 1 },
		["^"] = { 0, -1 },
	}

	for i = 1, #data do
		local move = moves[data:sub(i, i)]
		if i % 2 == 0 then
			locations[x] = locations[x] or {}
			locations[x][y] = locations[x][y] or true
			x, y = x + move[1], y + move[2]
		else
			locations[rx] = locations[rx] or {}
			locations[rx][ry] = locations[rx][ry] or true
			rx, ry = rx + move[1], ry + move[2]
		end
	end

	local result = 0
	for _, i in pairs(locations) do
		for _ in pairs(i) do
			result = result + 1
		end
	end
	return result
end

return t
