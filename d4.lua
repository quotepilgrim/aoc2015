---@diagnostic disable: param-type-mismatch

local t = {}

t["1"] = function(file, p2)
	local data = file:read()
	file:close()
	local i = 0
	while true do
		local str = data .. tostring(i)
		local hash = love.data.encode("string", "hex", love.data.hash("md5", str))
		if hash:sub(1, 5) == "00000" then
			if not p2 then
				return i
			elseif hash:sub(6, 6) == "0" then
				return i
			end
		end
		i = i + 1
	end
end

t["2"] = function(file)
	return t["1"](file, true)
end

return t
