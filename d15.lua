local M = {}

local function load_data(file)
	local data = {}

	for line in file:lines() do
		local i, c, d, f, t, k = line:match("(.+):.+ ([%-]*%d+).+ ([%-]*%d+).+ ([%-]*%d+).+ ([%-]*%d+).+ ([%-]*%d+)")
		c = tonumber(c)
		d = tonumber(d)
		f = tonumber(f)
		t = tonumber(t)
		k = tonumber(k)
		table.insert(data, { ingredient = i, capacity = c, durability = d, flavor = f, texture = t, calories = k })
	end

	data[3] = data[3] or { capacity = 0, durability = 0, flavor = 0, texture = 0, calories = 0 }
	data[4] = data[4] or data[3]

	file:close()
	return data
end

local function get_score(data, a, b, c, d, require_500)
	local capacity = data[1].capacity * a + data[2].capacity * b + data[3].capacity * c + data[4].capacity * d
	local durability = data[1].durability * a + data[2].durability * b + data[3].durability * c + data[4].durability * d
	local flavor = data[1].flavor * a + data[2].flavor * b + data[3].flavor * c + data[4].flavor * d
	local texture = data[1].texture * a + data[2].texture * b + data[3].texture * c + data[4].texture * d
	local calories = data[1].calories * a + data[2].calories * b + data[3].calories * c + data[4].calories * d

	if require_500 and calories ~= 500 then
		return 0
	end

	capacity = math.max(0, capacity)
	durability = math.max(0, durability)
	flavor = math.max(0, flavor)
	texture = math.max(0, texture)

	return capacity * durability * flavor * texture
end

M["1"] = function(file, require_500)
	local data = load_data(file)

	local result = 0
	for p1 = 0, 100 do
		for p2 = 0, 100 do
			for p3 = 0, 100 do
				local points = { p1, p2, p3 }
				table.sort(points)

				local a = points[1]
				local b = points[2] - points[1]
				local c = points[3] - points[2]
				local d = 100 - points[3]

				local score = get_score(data, a, b, c, d, require_500)
				result = score > result and score or result
			end
		end
	end

	return result
end

M["2"] = function(file)
	return M["1"](file, true)
end

return M
