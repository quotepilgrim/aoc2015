local M = {}
local data = {}
local people = {}
local random = love.math.random

local function load_data(file)
	local seen = {}
	for line in file:lines() do
		local person1, sign, happiness, person2 = line:match("(.+) .+ (.+) (%d+).* (.+)%.$")
		happiness = sign == "gain" and tonumber(happiness) or -tonumber(happiness)
		data[person1] = data[person1] or {}
		data[person1][person2] = happiness

		if not seen[person1] then
			table.insert(people, person1)
			seen[person1] = true
		end
	end
	file:close()
end

local function shuffle(t)
	for i = #t, 2, -1 do
		local j = random(i)
		t[i], t[j] = t[j], t[i]
	end
end

local function get_sum(t)
	local result = 0
	local fp, lp = t[1], t[#t]
	for i = 1, #t - 1 do
		local p1, p2 = t[i], t[i + 1]
		result = result + data[p1][p2]
		result = result + data[p2][p1]
	end
	result = result + data[fp][lp]
	result = result + data[lp][fp]
	return result
end

local function solve(i)
	local max = 0

	i = i or 10000
	for _ = 1, i do
		local sum = get_sum(people)
		max = sum > max and sum or max
		shuffle(people)
	end
	return max
end

M["1"] = function(file)
	load_data(file)
	return solve()
end

M["2"] = function(file)
	load_data(file)
	local me = "Pilgrim"

	data[me] = {}
	table.insert(people, me)

	for _, person in ipairs(people) do
		data[person][me] = 0
		data[me][person] = 0
	end

	return solve(50000)
end

return M
