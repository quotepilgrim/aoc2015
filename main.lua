local day, part, filename, result
local rx, ry, rw, rh, dx, dy, ww, wh
local argv = {}

while #arg > 0 do
	local a = table.remove(arg, 1)
	local v
	if a:sub(1, 1) == "-" then
		if #a > 2 then
			v = a:sub(3, #a)
		else
			v = arg[1]
			if not v or v:sub(1, 1) == "-" then
				v = true
			end
		end
		a = #a >= 2 and a:sub(2, 2) or "_"
		argv[a] = v
	end
end

filename = argv.f or ("inputs/d" .. argv.d .. ".txt")
day = require("d" .. argv.d)
part = argv.p

local function random_sign()
	return math.random() > 0.5 and 1 or -1
end

function love.load()
	local file = assert(io.open(filename))

	love.graphics.setFont(love.graphics.newFont(24))
	math.randomseed(os.time())

	if day.load then
		day.load(argv)
	end
	result = day[part or "1"](file) or ""

	ww, wh = love.window.getMode()
	rw = love.graphics.getFont():getWidth(result)
	rh = love.graphics.getFont():getHeight()
	rx = math.random(0, ww - rw)
	ry = math.random(0, wh - rh)
	dx = math.random(50, 100) * random_sign()
	dy = math.random(50, 100) * random_sign()

	if result ~= "" then
		love.system.setClipboardText(result)
	end
end

love.update = day.update
	or function(dt)
		rx = rx + dx * dt
		ry = ry + dy * dt
		if rx + rw > ww or rx < 0 then
			dx = -dx
			rx = math.min(math.max(0, rx), ww - rw)
		end
		if ry + rh > wh or ry < 0 then
			dy = -dy
			ry = math.min(math.max(0, ry), wh - rh)
		end
	end

love.draw = day.draw or function()
	love.graphics.print(result, rx, ry)
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	if day.keypressed then
		return day.keypressed(key)
	end
end

function love.resize(w, h)
	ww = w
	wh = h
end
