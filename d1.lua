local t = {}

t["1"] = function(file, p2)
	local result = 0
	local data = file:read()
	file:close()

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

t["2"] = function(file)
	return t["1"](file, true)
end

return t
