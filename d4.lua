---@diagnostic disable: param-type-mismatch

local t = {}
local result

local function p1(data, p2)
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
