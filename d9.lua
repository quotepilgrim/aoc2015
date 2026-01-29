local M = {}
local min_distance = 0x7FFFFFFF
local max_distance = 0
local locations = {}
local data = {}
local freq

function M.load(argv)
	love.window.setMode(400, 400)
	freq = tonumber(argv.r) or 1000
end

M["1"] = function(file)
	local seen = {}
	for line in file:lines() do
		local l1, l2, d = line:match("(.+) to (.+) = (.+)")

		if not seen[l1] then
			table.insert(locations, l1)
			seen[l1] = true
		end
		if not seen[l2] then
			table.insert(locations, l2)
			seen[l2] = true
		end

		-- this does duplicate information but makes getting distances faster
		data[l1] = data[l1] or {}
		data[l2] = data[l2] or {}
		data[l1][l2] = tonumber(d)
		data[l2][l1] = tonumber(d)
	end
	file:close()
end

M["2"] = function()
	love.event.quit()
end

local function shuffle(t)
	for i = #t, 2, -1 do
		local j = math.random(i)
		t[i], t[j] = t[j], t[i]
	end
end

local function get_distance(t)
	local distance = 0
	for i = 1, #t - 1 do
		distance = distance + data[t[i]][t[i + 1]]
	end
	return distance
end

function M.update()
	for _ = 1, freq do
		shuffle(locations)
		local dist = get_distance(locations)
		if dist < min_distance then
			min_distance = dist
		end
		if dist > max_distance then
			max_distance = dist
		end
	end
end

function M.draw()
	love.graphics.print(tostring(min_distance), 8, 8)
	love.graphics.print(tostring(max_distance), 8, 40)
	love.graphics.setColor(1, 1, 1, 0.5)
	love.graphics.print(table.concat(locations, "\n"), 8, 72)
	love.graphics.setColor(1, 1, 1, 1)
end

function M.keypressed(key)
	if key == "1" then
		love.system.setClipboardText(tostring(min_distance))
	elseif key == "2" then
		love.system.setClipboardText(tostring(max_distance))
	end
end

return M
