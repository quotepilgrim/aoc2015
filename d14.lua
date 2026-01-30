local M = {}
local seconds = 2503

function M.load(argv)
	if argv.f and argv.f:find("t(%d+)") then
		seconds = 1000
	end
end

local function load_data(file)
	local data = {}

	for line in file:lines() do
		local name, speed, fly, rest = line:match("([^%s]+) .+ (%d+) .+ (%d+) .+ (%d+)")
		table.insert(data, {
			name = name,
			speed = tonumber(speed),
			flies = tonumber(fly),
			rests = tonumber(rest),
			flown = 0,
			rested = tonumber(rest),
			travelled = 0,
			points = 0,
		})
	end

	file:close()
	return data
end

local function fly(reindeer)
	if reindeer.rested == reindeer.rests then
		reindeer.flown = reindeer.flown + 1
		reindeer.travelled = reindeer.travelled + reindeer.speed
		if reindeer.flown == reindeer.flies then
			reindeer.flown = 0
			reindeer.rested = 0
		end
	else
		reindeer.rested = reindeer.rested + 1
	end
end

M["1"] = function(file)
	local data = load_data(file)

	for _ = 1, seconds do
		for _, reindeer in ipairs(data) do
			fly(reindeer)
		end
	end

	local max = 0
	for _, reindeer in ipairs(data) do
		max = reindeer.travelled > max and reindeer.travelled or max
	end

	return max
end

M["2"] = function(file)
	local data = load_data(file)

	for _ = 1, seconds do
		local max = 0
		for _, reindeer in ipairs(data) do
			fly(reindeer)
			max = reindeer.travelled > max and reindeer.travelled or max
		end

		for _, reindeer in ipairs(data) do
			if reindeer.travelled == max then
				reindeer.points = reindeer.points + 1
			end
		end
	end

	local max = 0
	for _, reindeer in ipairs(data) do
		max = reindeer.points > max and reindeer.points or max
	end

	return max
end

return M
