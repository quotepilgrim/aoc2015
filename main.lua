local day, part, filename, result
local rx, ry, rw, rh, dx, dy, ww, wh

while #arg > 0 do
	local a = table.remove(arg, 1)
	local v
	if #a > 2 and a:sub(1, 1) == "-" then
		v = a:sub(3, #a)
		a = a:sub(1, 2)
	end
	if a == "-d" then
		local d = "d" .. (v or table.remove(arg, 1))
		day = require(d)
		if not filename then
			filename = "inputs/" .. d .. ".txt"
		end
	elseif a == "-p" then
		part = v or table.remove(arg, 1)
	elseif a == "-f" then
		filename = v or table.remove(arg, 1)
	end
end

local function random_sign()
	return math.random() > 0.5 and 1 or -1
end

function love.load()
	local file = assert(io.open(filename))

	love.graphics.setFont(love.graphics.newFont(24))
	math.randomseed(os.time())

	if day.load then
		day.load()
	end
	result = day[part or "1"](file) or ""

	ww, wh = love.window.getMode()
	rw = love.graphics.getFont():getWidth(result)
	rh = love.graphics.getFont():getHeight()
	rx = math.random(ww - rw)
	ry = math.random(wh - rh)
	dx = math.random(50, 100) * random_sign()
	dy = math.random(50, 100) * random_sign()

	if result ~= "" then
		love.system.setClipboardText(result)
	end
end

if day.draw then
	love.draw = day.draw
else
	function love.draw()
		love.graphics.print(result, rx, ry)
	end
end

if day.update then
	love.update = day.update
else
	function love.update(dt)
		rx = rx + dx * dt
		ry = ry + dy * dt
		if rx + rw > ww or rx < 0 then
			dx = -dx
		end
		if ry + rh > wh or ry < 0 then
			dy = -dy
		end
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	if day.keypressed then
		return day.keypressed(key)
	end
end
