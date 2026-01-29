local M = {}
local alphabet = "abcdefghijklmnopqrstuvwxyz"
local letter_index = {}

for i = 1, #alphabet do
	letter_index[alphabet:sub(i, i)] = i
end

local function increment(s)
	local wrap = true
	local pos = #s
	while wrap and pos > 0 do
		local c = s:sub(pos, pos)
		local ix = letter_index[c] % 26 + 1
		s = s:sub(1, pos - 1) .. alphabet:sub(ix, ix) .. s:sub(pos + 1)
		if c ~= "z" then
			wrap = false
		end
		pos = pos - 1
	end
	return s
end

local function validate(s)
	local straight = false
	local iol = s:find("i") or s:find("o") or s:find("l")

	if iol then
		return false
	end

	for i = 1, #alphabet - 2 do
		if s:find(alphabet:sub(i, i + 2)) then
			straight = true
			break
		end
	end

	if not straight then
		return false
	end

	for i = 1, #s - 1 do
		if s:sub(i, i) == s:sub(i + 1, i + 1) then
			for j = i + 2, #s - 1 do
				if s:sub(j, j) == s:sub(j + 1, j + 1) then
					return true
				end
			end
		end
	end

	return false
end

local function solve(data)
	while true do
		data = increment(data)
		if validate(data) then
			return data
		end
	end
end

M["1"] = function(file)
	local data = file:read()
	file:close()
	return solve(data)
end

M["2"] = function(file)
	local data = M["1"](file)
	return solve(data)
end

return M
