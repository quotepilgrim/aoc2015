local t = {}
local result

local function p1(data, p2)
	local result = 0
	p2 = false or p2
	for i = 1, #data do
		local c = data:sub(i, i)
		if c == "(" then
			result = result + 1
		elseif c == ")" then
			result = result - 1
		end
		if p2 and result == -1 then
			return i
		end
	end
	return result
end

function t.load(part, filename)
	local file = assert(io.open(filename))
	local data = file:read()

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
