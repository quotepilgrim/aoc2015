local M = {}
local CONWAY = 1.303577269034

local function look_say(s)
	local count = 1
	local result = ""
	for i = 1, #s do
		if s:sub(i + 1, i + 1) == s:sub(i, i) then
			count = count + 1
		else
			result = result .. count .. s:sub(i, i)
			count = 1
		end
	end
	return result
end

M["1"] = function(file, p2)
	local data = file:read()
	file:close()
	for _ = 1, 40 do
		data = look_say(data)
	end
	if p2 then
		for _ = 1, 10 do
			data = look_say(data)
		end
	end
	return #data
end

M["2"] = function()
	print("Please use -p2a or -p2b.")
	love.event.quit()
end

M["2a"] = function(file)
	--run naïve solution; extremely slow
	return M["1"](file, true)
end

M["2b"] = function(file)
	--attempt at a smarter solution; doesn't actually work but gets very close
	return math.floor(M["1"](file) * CONWAY ^ 10)
end

return M
