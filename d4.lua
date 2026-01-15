---@diagnostic disable: param-type-mismatch

local t = {}
local result

local function p1(data, p2)
	local i = 0
	while true do
		local str = data .. tostring(i)
		local hash = love.data.encode("string", "hex", love.data.hash("md5", str))
		local found
		if p2 then
			found = hash:sub(1, 6) == "000000"
		else
			found = hash:sub(1, 5) == "00000"
		end
		if found then
			print(hash)
			return i
		end
		i = i + 1
	end
end

function t.load(part, filename)
	local data = "yzbqklnj"

	if part == "1" then
		result = p1(data)
	elseif part == "2" then
		result = p1(data, true)
	end

	return result
end

function t.draw()
	love.graphics.print(result or "")
end

return t
