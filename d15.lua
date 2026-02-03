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

	file:close()
	return data
end

local function get_score(data, a, b, c, d, require_500)
	local capacity, durability, flavor, texture, calories = 0, 0, 0, 0, 0
	for i, v in ipairs({ a, b, c, d }) do
		if not data[i] then
			break
		end
		capacity = capacity + data[i].capacity * v
		durability = durability + data[i].durability * v
		flavor = flavor + data[i].flavor * v
		texture = texture + data[i].texture * v
		calories = calories + data[i].calories * v
	end

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
		for p2 = p1, 100 do
			for p3 = p2, 100 do
				local a = p1
				local b = p2 - p1
				local c = p3 - p2
				local d = 100 - p3

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
