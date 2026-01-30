local M = {}
local json = require("lib.json")

local function get_sum(s)
	local matches = s:gmatch("[%-]*%d+")

	local result = 0
	for match in matches do
		result = result + tonumber(match)
	end
	return result
end

local function remove_reds(t)
	for k, v in pairs(t) do
		if v == "red" and not tonumber(k) then
			-- I'm not sure why just doing t = nil doesn't work but eh
			for k, _ in pairs(t) do
				t[k] = nil
			end
		end
		if type(v) == "table" then
			remove_reds(v)
		end
	end
end

M["1"] = function(file)
	local data = file:read()
	file:close()
	return get_sum(data)
end

M["2"] = function(file)
	local data = file:read()
	file:close()

	data = json.decode(data)
	remove_reds(data)
	data = json.encode(data)

	return get_sum(data)
end

return M
