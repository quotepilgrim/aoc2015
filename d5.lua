local t = {}

local function load_data(file)
	local data = {}

	for line in file:lines() do
		table.insert(data, line)
	end

	return data
end

t["1"] = function(file)
	local data = load_data(file)
	local invalid_pairs = { "ab", "cd", "pq", "xy" }
	local function is_valid(word)
		for _, v in ipairs(invalid_pairs) do
			if word:find(v) then
				return false
			end
		end

		local _, vowels = word:gsub("[aeiou]", "")
		if vowels < 3 then
			return false
		end

		for i = 1, #word - 1 do
			if word:sub(i, i) == word:sub(i + 1, i + 1) then
				return true
			end
		end

		return false
	end

	local result = 0
	for _, word in ipairs(data) do
		if is_valid(word) then
			result = result + 1
		end
	end
	return result
end

t["2"] = function(file)
	local data = load_data(file)
	local function is_valid(word)
		local doubles = false
		local repeats = false
		for i = 1, #word - 2 do
			local c = word:sub(i, i)
			local cc = word:sub(i, i + 1)
			if word:sub(i + 2, #word):find(cc) then
				doubles = true
			end
			if word:match(c .. "." .. c) then
				repeats = true
			end
		end

		return doubles and repeats
	end

	local result = 0
	for _, word in ipairs(data) do
		if is_valid(word) then
			result = result + 1
		end
	end
	return result
end

return t
